import * as React from 'react';
import Breadcrumbs from '../../components/Breadcrumbs';
import DivisionForm from './DivisionForm';

interface Props {
  division: DivisionEditQuery_division;
}

class DivisionEdit extends React.Component<Props> {
  render() {
    const division = this.props.division;

    const input = {
      id: division.id,
      name: division.name,
      numTeams: division.numTeams,
      numDays: division.numDays,
      bracketType: division.bracket.handle
    };

    return (
      <>
        <Breadcrumbs
          items={[
            { link: '/divisions', text: 'Divisions' },
            { link: `/divisions/${division.id}`, text: division.name },
            { text: 'Edit' }
          ]}
        />
        <DivisionForm input={input} cancelPath={`/divisions/${division.id}`} />
      </>
    );
  }
}

export default DivisionEdit;
