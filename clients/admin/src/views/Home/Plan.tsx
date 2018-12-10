import * as React from 'react';
import pluralize from 'pluralize';
import Card from './Card';
import {
  faUsers,
  faSitemap,
  faMapSigns
} from '@fortawesome/free-solid-svg-icons';

interface Props {
  fields: number;
  teams: number;
  maxTeams: number;
  divisions: number;
}

class Plan extends React.Component<Props> {
  render() {
    const { fields, teams, maxTeams, divisions } = this.props;

    return (
      <>
        <p>
          Create your Field Map, Add/Import Teams and make Divisions in any
          order.
        </p>
        <div
          style={{
            display: 'flex',
            justifyContent: 'space-around',
            paddingBottom: 5
          }}
        >
          <Card
            icon={faMapSigns}
            text={`${fields} ${pluralize('Field', fields)}`}
          />
          <Card
            icon={faUsers}
            text={`${teams} / ${maxTeams} ${pluralize('Team', teams)}`}
          />
          <Card
            icon={faSitemap}
            text={`${divisions} ${pluralize('Division', divisions)}`}
          />
        </div>
      </>
    );
  }
}

export default Plan;
