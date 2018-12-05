import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";

import Table from "@material-ui/core/Table";
import TableBody from "@material-ui/core/TableBody";
import TableCell from "@material-ui/core/TableCell";
import TableHead from "@material-ui/core/TableHead";
import TableRow from "@material-ui/core/TableRow";
import BlankSlate from "../../components/BlankSlate";

import Breadcrumbs from "../../components/Breadcrumbs";
import TeamListItem from "./TeamListItem";
import TeamImport from "./TeamImport";

import ActionMenu from "../../components/ActionMenu";
import AddIcon from "@material-ui/icons/Add";
import ImportIcon from "@material-ui/icons/GroupAdd";

interface Props extends RouteComponentProps<{}> {
  teams: TeamListQuery['teams'];
  divisions: TeamListQuery['divisions'];
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

  renderContent = () => {
    const { teams } = this.props;

    if (teams && teams.length > 0) {
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
              {teams.map((t) => <TeamListItem key={t.id} team={t}/>)}
            </TableBody>
          </Table>
        </div>
      );
    } else {
      return (
        <BlankSlate>
          <h3>Manage Your Teams</h3>
          <p>You can add teams manually or import from a CSV file.</p>
        </BlankSlate>
      );
    }
  }

  render() {
    const actions = [
      {icon: <AddIcon/>, name: "Add Team", handler: this.openTeamNew },
      {icon: <ImportIcon/>, name: "Import Teams", handler: this.openImportModal}
    ];

    return (
      <div>
        {this.renderContent()}
        <ActionMenu actions={actions}/>
        <TeamImport
          divisions={this.props.divisions}
          open={this.state.modalOpen}
          onClose={this.closeImportModal}
        />
      </div>
    );
  }
}

export default withRouter(TeamList);
