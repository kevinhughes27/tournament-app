import * as React from "react";
import Breadcrumbs from "../../components/Breadcrumbs";
import DivisionForm from "./DivisionForm";

class TeamNew extends React.Component {
  render() {
    const input = {
      id: "",
      name: "",
      numTeams: 8,
      numDays: 2,
      bracketType: "USAU 8.1"
    };

    return (
      <div>
        <Breadcrumbs
          items={[
            {link: "/divisions", text: "Divisions"},
            {text: "New"}
          ]}
        />
        <DivisionForm input={input} cancelPath="/divisions"/>
      </div>
    );
  }
}

export default TeamNew;
