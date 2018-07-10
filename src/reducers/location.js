import ReactGA from 'react-ga';

export default function(state = {}, action) {
  switch (action.type) {
    case '@@router/LOCATION_CHANGE':
      if (window.location.hostname !== 'localhost') {
        ReactGA.set({ page: window.location.pathname });
        ReactGA.pageview(window.location.pathname);
      }
      return state;
    default:
      return state;
  }
}
