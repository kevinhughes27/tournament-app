import * as React from 'react';
import ReactGA from 'react-ga';
import { withRouter, RouteComponentProps } from 'react-router-dom';
import { Location } from 'history';

ReactGA.initialize('UA-76316112-5');

interface Props extends RouteComponentProps<{}> {}

class Analytics extends React.Component<Props> {
  componentDidMount() {
    this.sendPageView(this.props.history.location);
    this.props.history.listen(this.sendPageView);
  }

  sendPageView(location: Location<any>) {
    const host = window.location.hostname;

    if (host !== 'localhost' && !host.match(/lvh\.me/)) {
      ReactGA.set({ page: location.pathname });
      ReactGA.pageview(location.pathname);
    }
  }

  render() {
    return this.props.children;
  }
}

export default withRouter(Analytics);
