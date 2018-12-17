import * as React from 'react';
import Breadcrumbs from '../../components/Breadcrumbs';
import TeamForm from './TeamForm';

class TeamNew extends React.Component {
  render() {
    const input = {
      id: '',
      name: '',
      email: ''
    };

    return (
      <>
        <Breadcrumbs
          items={[{ link: '/teams', text: 'Teams' }, { text: 'New' }]}
        />
        <TeamForm input={input} />
      </>
    );
  }
}

export default TeamNew;
