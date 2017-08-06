import React, { Component } from 'react';
import './App.css';

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      games: []
    };
  }

  componentDidMount() {
    (async () => {
      const response = await fetch('http://no-borders.lvh.me:3000/api/games');
      const games = await response.json();
      this.setState({ games });
    })();
  }

  render() {
    const { games } = this.state;

    return (
      <div>
        {games.map(game => {
          return (
            <p key={game.id}>
              {game.id}
            </p>
          );
        })}
      </div>
    );
  }
}

export default App;
