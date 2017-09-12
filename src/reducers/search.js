import ls from 'local-storage';

const searchKey = 'search';
const initialState = ls.get(searchKey) || '';

export default function(state = initialState, action) {
  switch (action.type) {
    case 'SET_SEARCH':
      const search = action.value;
      ls.set(searchKey, search);
      return search;

    default:
      return state;
  }
}
