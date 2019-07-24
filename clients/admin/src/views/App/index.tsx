import * as React from 'react';
import Device from './Device';
import Hidden from '@material-ui/core/Hidden';

const getTournamentDomain = () => {
  if (window.location.host === 'localhost:4000') {
    return 'http://no-borders.lvh.me:3000';
  } else {
    return window.location.protocol + '//' + window.location.host;
  }
};

const tournamentDomain = getTournamentDomain();

class App extends React.Component {
  renderCopy = () => {
    return (
      <>
        <p>
          Your app is available at{' '}
          <a href={tournamentDomain} target="_blank" rel="noopener noreferrer">
            {tournamentDomain}
          </a>{' '}
          (its the same as your admin url without the <mark>/admin</mark> part).
        </p>

        <p>
          The app is a mobile first website which means its feels very natural
          to use on a phone but doesn't require downloading anything.
        </p>

        <p>
          Using the app anyone can view the schedule, field map, find a team or
          field and submit score reports along with the spirt of the game
          survey.
        </p>

        <p>
          Before your tournament starts you should send the link to the app to
          all teams in your tournament.
        </p>
      </>
    );
  };

  render() {
    return (
      <div style={{ display: 'flex', justifyContent: 'space-around' }}>
        <Hidden smDown>
          <Device src={tournamentDomain} />
        </Hidden>
        <div style={{ margin: 50 }}>{this.renderCopy()}</div>
      </div>
    );
  }
}

export default App;
