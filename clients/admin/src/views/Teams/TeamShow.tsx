import * as React from 'react';
import Breadcrumbs from '../../components/Breadcrumbs';
import TeamForm from './TeamForm';

interface Props {
  team: TeamShowQuery['team'];
  divisions: TeamShowQuery['divisions'];
}

class TeamShow extends React.Component<Props> {
  render() {
    const { team, divisions } = this.props;

    const input = {
      ...team,
      divisionId: team.division && team.division.id
    };

    return (
      <>
        <Breadcrumbs
          items={[{ link: '/teams', text: 'Teams' }, { text: team.name }]}
        />
        <TeamForm input={input} divisions={divisions} />
      </>
    );
  }
}

export default TeamShow;
