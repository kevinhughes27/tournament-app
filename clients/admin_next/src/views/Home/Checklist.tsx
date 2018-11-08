import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";
import Stepper from '@material-ui/core/Stepper';
import Step from "@material-ui/core/Step";
import StepButton from "@material-ui/core/StepButton";
import StepContent from "@material-ui/core/StepContent";
import { sumBy } from "lodash";
import Plan from "./Plan";
import Schedule from "./Schedule";
import Play from "./Play";

interface Props {
  fields: Checklist_fields;
  teams: Checklist_teams;
  divisions: Checklist_divisions;
  games: Checklist_games;
  disputes: Checklist_disputes;
}

interface State {
  activeStep: number;
}

class Checklist extends React.Component<Props, State> {
  state = {
    activeStep: 0
  }

  handleStep = (step: number) => () => {
    this.setState({
      activeStep: step,
    });
  }

  render() {
    const { activeStep } = this.state;
    const { fields, teams, divisions, games, disputes } = this.props;

    const maxTeams = sumBy(divisions, "numTeams");

    const missingScores = games.filter((g) => {
      const finished = g.endTime && new Date(g.endTime) < new Date();
      return finished && !g.scoreConfirmed
    });

    return (
      <div style={{height: "100%"}}>
        <Stepper nonLinear activeStep={activeStep} orientation="vertical">
          <Step key="plan">
            <StepButton
              onClick={this.handleStep(0)}
              completed={false}
            >
              Plan
            </StepButton>
            <StepContent>
              <Plan
                fields={fields.length}
                teams={teams.length}
                maxTeams={maxTeams}
                divisions={divisions.length}
              />
            </StepContent>
          </Step>

          <Step key="schedule">
            <StepButton
              onClick={this.handleStep(1)}
              completed={false}
            >
              Schedule
            </StepButton>
            <StepContent>
              <Schedule
                games={games.length}
                scheduled={games.filter((g) => g.scheduled).length}
              />
            </StepContent>
          </Step>

          <Step key="play">
            <StepButton
              onClick={this.handleStep(2)}
              completed={false}
            >
              Play
            </StepButton>
            <StepContent>
              <Play
                games={games.length}
                scored={games.filter((g) => g.scoreConfirmed).length}
                missing={missingScores.length}
                disputes={disputes.length}
              />
            </StepContent>
          </Step>
        </Stepper>
      </div>
    );
  }
}

export default createFragmentContainer(Checklist, {
  fields: graphql`
    fragment Checklist_fields on Field @relay(plural: true) {
      id
    }
  `,
  teams: graphql`
    fragment Checklist_teams on Team @relay(plural: true) {
      id
    }
  `,
  divisions: graphql`
    fragment Checklist_divisions on Division @relay(plural: true) {
      id
      numTeams
    }
  `,
  games: graphql`
    fragment Checklist_games on Game @relay(plural: true) {
      id
      scheduled
      endTime
      scoreConfirmed
    }
  `,
  disputes: graphql`
    fragment Checklist_disputes on ScoreDispute @relay(plural: true) {
      id
    }
  `,
});
