import * as React from "react";
import { Theme, createStyles, WithStyles, withStyles } from "@material-ui/core/styles";
import Tooltip from "@material-ui/core/Tooltip";

const styles = (theme: Theme) => createStyles({
  lightTooltip: {
    background: theme.palette.common.white,
    color: theme.palette.text.primary,
    boxShadow: theme.shadows[1],
    fontSize: 11,
  }
});

interface Props extends WithStyles<typeof styles> {
  text: string;
  children: React.ReactElement<any>;
}

class MapTooltip extends React.Component<Props> {
  render() {
    const { text, classes } = this.props;

    return (
      <Tooltip
        title={text}
        placement="right"
        disableFocusListener
        disableTouchListener
        classes={{ tooltip: classes.lightTooltip }}
      >
        {this.props.children}
      </Tooltip>
    );
  }
}

export default withStyles(styles)(MapTooltip);
