import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";
import Breadcrumbs from "../../components/Breadcrumbs";
import DivisionForm from "./DivisionForm";
import { decodeId } from "../../helpers/relay";

interface Props {
  division: DivisionEdit_division;
}

class DivisionEdit extends React.Component<Props> {
  render() {
    const division = this.props.division;
    const divisionId = decodeId(this.props.division.id);

    const input = {
      id: division.id,
      name: division.name,
      numTeams: division.numTeams,
      numDays: division.numDays,
      bracketType: division.bracket.handle
    };

    return (
      <div>
        <Breadcrumbs
          items={[
            {link: "/divisions", text: "Divisions"},
            {link: `/divisions/${divisionId}`, text: division.name},
            {text: "Edit"}
          ]}
        />
        <DivisionForm input={input} cancelPath={`/divisions/${divisionId}`}/>
      </div>
    );
  }
}

export default createFragmentContainer(DivisionEdit, {
  division: graphql`
    fragment DivisionEdit_division on Division {
      id
      name
      numTeams
      numDays
      games {
        pool
        homePrereq
        homeName
        awayPrereq
        awayName
      }
      bracketTree
      bracket {
        name
        handle
        description
      }
    }
  `
});
