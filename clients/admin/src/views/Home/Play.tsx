import * as React from 'react';
import Card from './Card';
import {
  faTrophy,
  faQuestionCircle,
  faExclamationTriangle
} from '@fortawesome/free-solid-svg-icons';

interface Props {
  games: number;
  scored: number;
  missing: number;
  disputes: number;
}

class Play extends React.Component<Props> {
  render() {
    return (
      <>
        <p>
          Players can now submit scores. Review score reports and make sure
          everyone has submitted their scores.
        </p>
        <div
          style={{
            display: 'flex',
            justifyContent: 'space-around',
            paddingBottom: 5
          }}
        >
          <Card
            icon={faTrophy}
            text={`${this.props.scored} / ${this.props.games} Games scored`}
          />
          <Card
            icon={faQuestionCircle}
            text={`${this.props.missing} missing scores`}
          />
          <Card
            icon={faExclamationTriangle}
            text={`${this.props.disputes} score disputes`}
          />
        </div>
      </>
    );
  }
}

export default Play;
