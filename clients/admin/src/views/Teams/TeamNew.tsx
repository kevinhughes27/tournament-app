import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";
import Breadcrumbs from "../../components/Breadcrumbs";
import TeamForm from "./TeamForm";

interface Props {
  divisions: TeamNew_divisions;
}

class TeamNew extends React.Component<Props> {
  render() {
    const { divisions } = this.props;

    const input = {
      id: "",
      name: "",
      email: "",
      divisionId: "",
      seed: 0
    };

    return (
      <div>
        <Breadcrumbs
          items={[
            {link: "/teams", text: "Teams"},
            {text: "New"}
          ]}
        />
        <TeamForm input={input} divisions={divisions}/>
      </div>
    );
  }
}

export default createFragmentContainer(TeamNew, {
  divisions: graphql`
    fragment TeamNew_divisions on Division @relay(plural: true) {
      ...DivisionPicker_divisions
    }
  `
});
