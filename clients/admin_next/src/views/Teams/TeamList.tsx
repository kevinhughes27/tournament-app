import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import {createFragmentContainer, graphql} from "react-relay";

import Table from "@material-ui/core/Table";
import TableBody from "@material-ui/core/TableBody";
import TableCell from "@material-ui/core/TableCell";
import TableHead from "@material-ui/core/TableHead";
import TableRow from "@material-ui/core/TableRow";

import Breadcrumbs from "../../components/Breadcrumbs";
import TeamListItem from "./TeamListItem";
import ActionButton from "../../components/ActionButton";

interface Props extends RouteComponentProps<{}> {
  teams: TeamList_teams;
}

class TeamList extends React.Component<Props> {
  render() {
    const { teams } = this.props;

    return (
      <div>
        <Breadcrumbs items={[{text: "Teams"}]} />
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>Name</TableCell>
              <TableCell>Division</TableCell>
              <TableCell>Seed</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {teams.map((t) => <TeamListItem key={t.id} team={t as TeamListItem_team}/>)}
          </TableBody>
        </Table>
        <ActionButton icon="add" onClick={() => this.props.history.push("/teams/new")}/>
      </div>
    );
  }
}

export default createFragmentContainer(withRouter(TeamList), {
  teams: graphql`
    fragment TeamList_teams on Team @relay(plural: true) {
      id
      ...TeamListItem_team
    }
  `
});
