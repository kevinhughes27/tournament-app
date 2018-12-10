import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import TableCell from "@material-ui/core/TableCell";
import TableRow from "@material-ui/core/TableRow";
import TeamsCell from "./TeamsCell";
import SeededCell from "./SeededCell";

interface Props extends RouteComponentProps<any> {
  division: DivisionListQuery_divisions;
}

class DivisionListItem extends React.Component<Props> {
  handleClick = () => {
    this.props.history.push(`/divisions/${this.props.division.id}`);
  }

  render() {
    const { division } = this.props;

    return (
      <TableRow hover onClick={this.handleClick}>
      <TableCell>{division.name}</TableCell>
      <TableCell>{division.bracket.handle}</TableCell>
      <TableCell>{TeamsCell(division)}</TableCell>
      <TableCell>{SeededCell(division)}</TableCell>
    </TableRow>
    );
  }
}

export default withRouter(DivisionListItem)
