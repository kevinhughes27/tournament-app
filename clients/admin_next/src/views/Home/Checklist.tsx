import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";
import Stepper from '@material-ui/core/Stepper';
import Step from "@material-ui/core/Step";
import StepButton from "@material-ui/core/StepButton";
import StepContent from "@material-ui/core/StepContent";
import { sumBy } from "lodash";
import Plan from "./Plan";
import Schedule from "./Schedule";
import Seed from "./Seed";
import Play from "./Play";

interface Props {
  fields: Checklist_fields;
  teams: Checklist_teams;
  divisions: Checklist_divisions;
  games: Checklist_games;
  scoreDisputes: Checklist_scoreDisputes;
}

interface State {
  activeStep: number;
  completed: Set<number>;
}

class Checklist extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);

    const { fields, teams, divisions, games } = this.props;

    const divisionsAndFields = divisions.length > 0 && fields.length > 0;
    const enoughTeams = sumBy(divisions, "numTeams") === teams.length;

    const completed = new Set();

    if (divisionsAndFields && enoughTeams) {
      completed.add(0);
    }

    const scheduleBuilt = games.filter((g) => g.scheduled).length === games.length;

    if (completed.has(0) && scheduleBuilt) {
      completed.add(1);
    }

    const divisionsSeeded = divisions.filter((d) => d.isSeeded).length === divisions.length

    if (completed.has(1) && divisionsSeeded) {
      completed.add(2);
    }

    const activeStep = Math.max(...completed.values()) + 1;

    this.state = {
      activeStep,
      completed
    };
  }

  handleStep = (step: number) => () => {
    this.setState({
      activeStep: step,
    });
  }

  render() {
    const { activeStep } = this.state;
    const { fields, teams, divisions, games, scoreDisputes } = this.props;

    const maxTeams = sumBy(divisions, "numTeams");

    const scheduledGames = games.filter((g) => g.scheduled);

    const seededDivisions = divisions.filter((d) => d.isSeeded)

    const missingScores = games.filter((g) => {
      const finished = g.endTime && new Date(g.endTime) < new Date();
      return finished && !g.scoreConfirmed;
    });

    return (
      <div style={{height: "100%"}}>
        <Stepper nonLinear activeStep={activeStep} orientation="vertical">
          <Step key="plan">
            <StepButton
              onClick={this.handleStep(0)}
              completed={this.state.completed.has(0)}
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
              completed={this.state.completed.has(1)}
            >
              Schedule
            </StepButton>
            <StepContent>
              <Schedule
                games={games.length}
                scheduled={scheduledGames.length}
              />
            </StepContent>
          </Step>

          <Step key="seed">
            <StepButton
              onClick={this.handleStep(2)}
              completed={this.state.completed.has(2)}
            >
              Seed
            </StepButton>
            <StepContent>
              <Seed
                divisions={divisions.length}
                seeded={seededDivisions.length}
              />
            </StepContent>
          </Step>

          <Step key="play">
            <StepButton
              onClick={this.handleStep(3)}
              completed={false}
            >
              Play
            </StepButton>
            <StepContent>
              <Play
                games={games.length}
                scored={games.filter((g) => g.scoreConfirmed).length}
                missing={missingScores.length}
                disputes={scoreDisputes.length}
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
      isSeeded
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
  scoreDisputes: graphql`
    fragment Checklist_scoreDisputes on ScoreDispute @relay(plural: true) {
      id
    }
  `,
});
