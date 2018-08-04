import * as React from "react";
import Modal from "../../../components/Modal";
import TeamImportForm from "./TeamImportForm";
import TeamImportStatus from "./TeamImportStatus";
import TeamImporter from "./TeamImporter";

interface Props {
  divisions: TeamImport_divisions;
  open: boolean;
  onClose: () => void;
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
    return (
      <Modal
        title="Import Teams"
        open={this.props.open}
        onClose={this.props.onClose}
      >
        {this.renderContent()}
      </Modal>
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

export default TeamImportModal;
