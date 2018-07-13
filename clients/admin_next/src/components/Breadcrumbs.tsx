import * as React from "react";
import ReactJoin from "react-join";
import { Link } from "react-router-dom";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import { Breadcrumbs as styles } from "../assets/jss/styles";
import Typography from "@material-ui/core/Typography";

interface Props extends WithStyles<typeof styles> {
  items: Array<{link?: string, text: string}>;
}

class Breadcrumbs extends React.Component<Props> {
  render() {
    const { classes } = this.props;

    return (
      <div className={classes.container}>
        <Typography variant="subheading">
          <ReactJoin separator={" / "}>
            {this.props.items.map((i) => BreadcrumbItem(i.link, i.text, classes.link))}
          </ReactJoin>
        </Typography>
      </div>
    );
  }
}

const BreadcrumbItem = (link: string | undefined, text: string, linkClass: string) => {
  if (link) {
    return (
      <Link key={text} to={link} className={linkClass}>
        {text}
      </Link>
    );
  } else {
    return text;
  }
};

export default withStyles(styles)(Breadcrumbs);
