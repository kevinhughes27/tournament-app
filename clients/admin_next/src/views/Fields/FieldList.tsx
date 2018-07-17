import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";

import { withStyles, WithStyles } from "@material-ui/core/styles";
import Table from "@material-ui/core/Table";
import TableBody from "@material-ui/core/TableBody";
import TableCell from "@material-ui/core/TableCell";
import TableHead from "@material-ui/core/TableHead";
import TableRow from "@material-ui/core/TableRow";

const styles = {};

interface Props extends WithStyles<typeof styles> {
  fields: Field[];
}

const Row = (f: any) => (
  <TableRow key={f.id}>
    <TableCell>{f.name}</TableCell>
    <TableCell>{f.lat}</TableCell>
    <TableCell>{f.long}</TableCell>
  </TableRow>
);

class FieldList extends React.Component<Props> {
  render() {
    const { fields } = this.props;

    return (
      <Table>
        <TableHead>
          <TableRow>
            <TableCell>Name</TableCell>
            <TableCell>Latitude</TableCell>
            <TableCell>Longitude</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {fields.map(Row)}
        </TableBody>
      </Table>
    );
  }
}

const StyledFieldList = withStyles(styles)(FieldList);

export default createFragmentContainer(StyledFieldList, {
  fields: graphql`
    fragment FieldList_fields on Field @relay(plural: true) {
      id
      name
      lat
      long
    }
  `
});
