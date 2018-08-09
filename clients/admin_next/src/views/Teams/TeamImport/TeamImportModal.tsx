import * as React from "react";
import Modal from "../../../components/Modal";
import TeamImporter from "./TeamImporter";
import TeamImportForm from "./TeamImportForm";
import TeamImportStatus from "./TeamImportStatus";
import TeamImportResult from "./TeamImportResult";

interface Props {
  divisions: TeamImport_divisions;
  open: boolean;
  onClose: () => void;
}

class TeamImportModal extends React.Component<Props> {
  importer: TeamImporter;

  constructor(props: Props) {
    super(props);
    this.importer = new TeamImporter(this, this.props.divisions);
  }

  startImport = (data: string[][]) => {
    this.importer.start(data);
  }

  onClose = () => {
    if (this.importer.progress === 100) {
      this.importer = new TeamImporter(this, this.props.divisions);
      this.props.onClose();
    } else if (!this.importer.started) {
      this.props.onClose();
    }
  }

  render() {
    return (
      <Modal
        title="Import Teams"
        open={this.props.open}
        onClose={this.onClose}
      >
        {this.renderContent()}
      </Modal>
    );
  }

  renderContent = () => {
    if (this.importer.progress === 100) {
      return (
        <TeamImportResult
          completed={this.importer.completed}
          errors={this.importer.errors}
          onClose={this.onClose}
        />
      );
    } else if (this.importer.started) {
      return <TeamImportStatus progress={this.importer.progress} errors={this.importer.errors} />;
    } else {
      return <TeamImportForm startImport={this.startImport} />;
    }
  }
}

export default TeamImportModal;
