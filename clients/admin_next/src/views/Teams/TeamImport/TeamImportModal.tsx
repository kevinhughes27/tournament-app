import * as React from "react";
import { Modal as styles } from "../../../assets/jss/styles";
import { withStyles, WithStyles } from "@material-ui/core/styles";
import Modal from "@material-ui/core/Modal";
import Typography from "@material-ui/core/Typography";
import IconButton from "@material-ui/core/IconButton";
import CloseIcon from "@material-ui/icons/Close";
import TeamImportForm from "./TeamImportForm";
import TeamImportStatus from "./TeamImportStatus";
import TeamImporter from "./TeamImporter";

interface Props extends WithStyles<typeof styles> {
  divisions: TeamImport_divisions;
  open: boolean;
  handleClose: () => void;
}

interface State {
  importer: TeamImporter | null;
}

class TeamImportModal extends React.Component<Props, State> {
  state = {
    importer: null
  };

  importTeams = (csvData: string) => {
    const importer = new TeamImporter(csvData, this.props.divisions);

    this.setState({importer});

    importer.start();
  }

  render() {
    const { classes } = this.props;

    return (
      <Modal open={this.props.open} onClose={this.props.handleClose}>
        <div className={classes.paper}>
          {this.renderTitle()}
          {this.renderContent()}
        </div>
      </Modal>
    );
  }

  renderTitle = () => {
    const style = {
      display: "flex",
      justifyContent: "space-between",
      alignItems: "center"
    };

    return (
      <div style={style}>
        <Typography variant="title">
          Import Teams
        </Typography>
        <IconButton onClick={this.props.handleClose}>
          <CloseIcon />
        </IconButton>
      </div>
    );
  }

  renderContent = () => {
    const importer = this.state.importer;

    if (importer === null) {
      return <TeamImportForm importTeams={this.importTeams} />;
    } else {
      return <TeamImportStatus importer={importer} />;
    }
  }
}

export default withStyles(styles)(TeamImportModal);
