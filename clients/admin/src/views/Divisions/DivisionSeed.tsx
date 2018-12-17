import * as React from 'react';
import { withRouter, RouteComponentProps } from 'react-router-dom';
import Breadcrumbs from '../../components/Breadcrumbs';
import BlankSlate from '../../components/BlankSlate';
import FormButtons from '../../components/FormButtons';
import Seeds from './Seeds';
import runMutation from '../../helpers/runMutation';
import SeedDivision from '../../mutations/SeedDivision';

interface Props extends RouteComponentProps<{}> {
  division: DivisionSeedQuery['division'];
  teams: DivisionSeedQuery['teams'];
}

interface State {
  submitting: boolean;
}

class DivisionSeed extends React.Component<Props, State> {
  state = {
    submitting: false
  };

  submit = () => {
    this.setState({ submitting: true });

    runMutation(SeedDivision, this.seedInput(), {
      complete: this.seedComplete,
      failed: this.seedFailed
    });
  };

  seedInput = () => {
    const division = this.props.division;

    return {
      input: {
        divisionId: division.id
      }
    };
  };

  seedComplete = () => {
    this.props.history.push(`/divisions/${this.props.division.id}`);
  };

  seedFailed = () => {
    this.setState({ submitting: false });
  };

  render() {
    const { division, teams } = this.props;

    if (teams.length === 0) {
      return (
        <BlankSlate>
          <h3>Manage Seeding for your Tournament</h3>
          <p>You need to create Teams before you can seed divisions.</p>
        </BlankSlate>
      );
    } else {
      return (
        <>
          <Breadcrumbs
            items={[
              { link: '/divisions', text: 'Divisions' },
              { link: `/divisions/${division.id}`, text: division.name },
              { text: 'Seed' }
            ]}
          />
          <Seeds division={division} teams={teams} />
          <FormButtons
            submit={this.submit}
            submitIcon={<span>Seed</span>}
            submitting={this.state.submitting}
            cancelLink={`/divisions/${division.id}`}
          />
        </>
      );
    }
  }
}

export default withRouter(DivisionSeed);
