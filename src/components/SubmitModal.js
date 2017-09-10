import React from 'react';
import Dialog from 'material-ui/Dialog';
import ScoreForm from './ScoreForm';

const customContentStyle = {
  width: '96%',
  maxWidth: 'none'
};

export default class SubmitModal extends React.Component {
  state = {
    open: false
  };

  handleOpen = () => {
    this.setState({ open: true });
  };

  handleClose = () => {
    this.setState({ open: false });
  };

  render() {
    const game = this.props.game;

    return (
      <div>
        <div onTouchTap={this.handleOpen}>
          {game.home_name} vs {game.away_name}
        </div>

        <Dialog
          title="Submit Score"
          modal={false}
          open={this.state.open}
          onRequestClose={this.handleClose}
          autoScrollBodyContent={true}
          contentStyle={customContentStyle}
        >
          <ScoreForm game={game} handleClose={this.handleClose} />
        </Dialog>
      </div>
    );
  }
}
