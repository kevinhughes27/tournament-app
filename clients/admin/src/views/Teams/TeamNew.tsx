import * as React from 'react';
import Breadcrumbs from '../../components/Breadcrumbs';
import TeamForm from './TeamForm';

interface Props {
  divisions: TeamNewQuery['divisions'];
}

class TeamNew extends React.Component<Props> {
  render() {
    const { divisions } = this.props;

    const input = {
      id: '',
      name: '',
      email: '',
      divisionId: '',
      seed: 0
    };

    return (
      <>
        <Breadcrumbs
          items={[{ link: '/teams', text: 'Teams' }, { text: 'New' }]}
        />
        <TeamForm input={input} divisions={divisions} />
      </>
    );
  }
}

export default TeamNew;
