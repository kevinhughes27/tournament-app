import _map from 'lodash/map';
import _findIndex from 'lodash/findIndex';

import React from 'react';
import ReactDOM from 'react-dom';
import ReactGridLayout from 'react-grid-layout';

class ScheduleEditor extends React.Component {
  constructor(props) {
    super(props);

    this.fields = JSON.parse(this.props.fields);
    this.games = JSON.parse(this.props.games);
    this.scheduledGames = this.games.filter((g) => { return g.scheduled });

    this.renderGame = this.renderGame.bind(this);
  }

  renderHeader() {
    let fields = this.fields;
    let width = this.props.width;
    let colWidth = width / fields.length;

    return (
      <div style={{display: 'flex', marginLeft: '10px'}}>
        { _map(fields, (f) => this.renderFieldCell(f, colWidth)) }
      </div>
    );
  }

  renderFieldCell(field, width) {
    return (
      <div key={field.name} style={{minWidth: width, maxWidth: width}}>
        {field.name}
      </div>
    );
  }

  renderGame(game) {
    let x = _findIndex(this.fields, (f) => { return f.id == game.field_id });

    let dataGrid = {
      x: x,
      y: 0, // based on start time
      w: 1, // constant
      h: 2, // based on game length
      minW: 1, // constant
      maxW: 1 // constant
    };

    return (
      <div key={game.id} data-grid={dataGrid}>
        {game.name}
      </div>
    );
  }

  render() {
    let fields = this.fields;
    let scheduledGames = this.scheduledGames;

    let gridProps = {
      cols: fields.length,
      rowHeight: 30,
      width: this.props.width, // this should be calculated by a field width multiplier
      verticalCompact: false,
      autoSize: false
    };

    return (
      <div>
        {this.renderHeader(fields)}
        <ReactGridLayout {...gridProps}>
          {_map(scheduledGames, this.renderGame)}
        </ReactGridLayout>
      </div>
    );
  }
}

ScheduleEditor.defaultProps = {
  width: 1200
};

module.exports = ScheduleEditor;
