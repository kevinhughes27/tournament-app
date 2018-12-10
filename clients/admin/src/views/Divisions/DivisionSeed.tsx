import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import Breadcrumbs from "../../components/Breadcrumbs";
import FormButtons from "../../components/FormButtons";
import Seeds from "./Seeds";
import runMutation from "../../helpers/runMutation";
import SeedDivision from "../../mutations/SeedDivision";

interface Props extends RouteComponentProps<{}> {
  division: DivisionSeedQuery_division;
}

interface State {
  submitting: boolean;
}

class DivisionSeed extends React.Component<Props, State> {
  state = {
    submitting: false
  };

  submit = () => {
    this.setState({submitting: true});

    runMutation(
      SeedDivision,
      this.seedInput(),
      {
        complete: this.seedComplete,
        failed: this.seedFailed
      }
    );
  }

  seedInput = () => {
    const division = this.props.division;

    return {
      input: {
        divisionId: division.id,
        teamIds: division.teams.map((t) => t.id),
        seeds: division.teams.map((t) => t.seed),
      }
    };
  }

  seedComplete = () => {
    this.props.history.push(`/divisions/${this.props.division.id}`);
  }

  seedFailed = () => {
    this.setState({submitting: false});
  }

  render() {
    const division = this.props.division;

    return (
      <div>
        <Breadcrumbs
          items={[
            {link: "/divisions", text: "Divisions"},
            {link: `/divisions/${division.id}`, text: division.name},
            {text: "Seed"}
          ]}
        />
        <Seeds teams={division.teams} />
        <FormButtons
          submit={this.submit}
          submitIcon={<span>Seed</span>}
          submitting={this.state.submitting}
          cancelLink={`/divisions/${division.id}`}
        />
      </div>
    );
  }
}

export default withRouter(DivisionSeed);
