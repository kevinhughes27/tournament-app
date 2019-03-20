import ReactGA from 'react-ga';

export default function(state = {}, action) {
  const host = window.location.hostname;

  switch (action.type) {
    case '@@router/LOCATION_CHANGE':
      if (host !== 'localhost' && host !== 'lvh.me') {
        ReactGA.set({ page: window.location.pathname });
        ReactGA.pageview(window.location.pathname);
      }
      return state;
    default:
      return state;
  }
}
