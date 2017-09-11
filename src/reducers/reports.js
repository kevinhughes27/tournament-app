import ls from 'local-storage';

const reportsKey = 'reports';
const initialState = ls.get(reportsKey) || [];

export default (state = initialState, action) => {
  if (action.type === 'SCORE_REPORT_SUBMITTED') {
    let report = { ...action.report, status: 'pending' };
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
