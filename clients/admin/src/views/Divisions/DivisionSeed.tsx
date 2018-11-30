import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import {createFragmentContainer, graphql} from "react-relay";
import Breadcrumbs from "../../components/Breadcrumbs";
import FormButtons from "../../components/FormButtons";
import Seeds from "./Seeds";
import runMutation from "../../helpers/runMutation";
import SeedDivision from "../../mutations/SeedDivision";
import { decodeId } from "../../helpers/relay";

interface Props extends RouteComponentProps<{}> {
  division: DivisionSeed_division;
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
    const divisionId = decodeId(this.props.division.id);
    this.props.history.push(`/divisions/${divisionId}`);
  }

  seedFailed = () => {
    this.setState({submitting: false});
  }

  render() {
    const division = this.props.division;
    const divisionId = decodeId(this.props.division.id);

    return (
      <div>
        <Breadcrumbs
          items={[
            {link: "/divisions", text: "Divisions"},
            {link: `/divisions/${divisionId}`, text: division.name},
            {text: "Seed"}
          ]}
        />
        <Seeds teams={division.teams} />
        <FormButtons
          submit={this.submit}
          submitIcon={<span>Seed</span>}
          submitting={this.state.submitting}
          cancelLink={`/divisions/${divisionId}`}
        />
      </div>
    );
  }
}

export default createFragmentContainer(withRouter(DivisionSeed), {
  division: graphql`
    fragment DivisionSeed_division on Division {
      id
      name
      teams {
        id
        name
        seed
      }
    }
  `
});
