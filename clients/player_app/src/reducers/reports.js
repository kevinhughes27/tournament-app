import ls from 'local-storage';

const reportsKey = 'reports';
const initialState = ls.get(reportsKey) || [];

function loadReport(state, action) {
  return state.find((r) => r.gameId === action.report.gameId ) || {}
}

export default (state = initialState, action) => {
  if (action.type === 'SCORE_REPORT_SUBMITTED') {
    let prevReport = loadReport(state, action);
    let report = {...prevReport, ...action.report, status: 'pending' };
    let reports = [...state, report];
    ls.set(reportsKey, reports);
    return reports;
  } else if (action.type === 'SCORE_REPORT_RECIEVED') {
    let lastReport = state.pop();
    let report = { ...lastReport, status: 'success' };
    let reports = [...state, report];
    ls.set(reportsKey, reports);
    return reports;
  } else if (action.type === 'SCORE_REPORT_FAILED') {
    let lastReport = state.pop();
    let report = { ...lastReport, status: 'error' };
    let reports = [...state, report];
    ls.set(reportsKey, reports);
    return reports;
  }

  return state;
};
