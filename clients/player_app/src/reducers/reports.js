import ls from 'local-storage';

const reportsKey = 'reports';
const initialState = ls.get(reportsKey) || [];

function loadReport(state, gameId) {
  return state.find((r) => r.gameId === gameId ) || {}
}

export default (state = initialState, action) => {
  if (action.type === 'SCORE_REPORT_SUBMITTED') {
    const gameId = action.report.gameId;
    const prevReport = loadReport(state, gameId);
    const updatedReport = {...prevReport, ...action.report, status: 'pending' };
    const reports = [...state, updatedReport];
    ls.set(reportsKey, reports);
    return reports;

  } else if (action.type === 'SCORE_REPORT_RECIEVED') {
    const gameId = action.response.gameId;
    const status = action.response.success ? 'success' : 'error';
    const prevReport = loadReport(state, gameId);
    const updatedReport = { ...prevReport, status: status };
    const reports = [...state, updatedReport];
    ls.set(reportsKey, reports);
    return reports;

  } else if (action.type === 'SCORE_REPORT_FAILED') {
    const gameId = action.gameId;
    const prevReport = loadReport(state, gameId);
    const updatedReport = { ...prevReport, status: 'error' };
    const reports = [...state, updatedReport];
    ls.set(reportsKey, reports);
    return reports;
  }

  return state;
};
