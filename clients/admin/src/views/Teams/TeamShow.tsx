import * as React from 'react';
import Breadcrumbs from '../../components/Breadcrumbs';
import TeamForm from './TeamForm';

interface Props {
  team: TeamShowQuery['team'];
}

class TeamShow extends React.Component<Props> {
  render() {
    const { team } = this.props;
    const input = { ...team };

    return (
      <>
        <Breadcrumbs
          items={[{ link: '/teams', text: 'Teams' }, { text: team.name }]}
        />
        <TeamForm input={input} />
      </>
    );
  }
}

export default TeamShow;
