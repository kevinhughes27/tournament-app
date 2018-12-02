import * as React from "react";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import { ReportsBadge as styles } from "../../assets/jss/styles";
import Badge from "@material-ui/core/Badge";

interface Props extends WithStyles<typeof styles> {
  count: number;
  disputed: boolean;
}

class ReportsBadge extends React.Component<Props> {
  color = () => {
    if (this.props.disputed) {
      return "error";
    } else {
      return "primary";
    }
  }

  render() {
    const { classes, count, children } = this.props;
    const color = this.color();

    return(
      <Badge color={color} classes={{ badge: classes.badge}} badgeContent={count}>
        {children}
      </Badge>
    );
  }
}

export default withStyles(styles)(ReportsBadge);
