export default (state = true, action) => {
  switch (action.type) {
    case 'LOAD_COMPLETED':
      return false;

    case 'LOAD_FAILED':
      return state;

    default:
      return state;
  }
};
