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
import TeamImport from "./TeamImport";

import ActionMenu from "../../components/ActionMenu";
import AddIcon from "@material-ui/icons/Add";
import ImportIcon from "@material-ui/icons/GroupAdd";

interface Props extends RouteComponentProps<{}> {
  teams: TeamList_teams;
  divisions: TeamImport_divisions;
}

class TeamList extends React.Component<Props> {
  state = {
    modalOpen: false
  };

  openTeamNew = () => {
    this.props.history.push("/teams/new");
  }

  openImportModal = () => {
    this.setState({modalOpen: true});
  }

  closeImportModal = () => {
    this.setState({modalOpen: false});
  }

  render() {
    const { teams } = this.props;

    const actions = [
      {icon: <AddIcon/>, name: "Add Team", handler: this.openTeamNew },
      {icon: <ImportIcon/>, name: "Import Teams", handler: this.openImportModal}
    ];

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
        <ActionMenu actions={actions}/>
        <TeamImport
          divisions={this.props.divisions}
          open={this.state.modalOpen}
          handleClose={this.closeImportModal}
        />
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
