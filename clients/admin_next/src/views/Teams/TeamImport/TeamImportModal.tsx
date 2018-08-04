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

class TeamImportModal extends React.Component<Props> {
  importer: TeamImporter;

  constructor(props: Props) {
    super(props);
    this.importer = new TeamImporter(this, this.props.divisions);
  }

  startImport = (csvData: string) => {
    this.importer.start(csvData);
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
    if (this.importer.progress === 100) {
      return <p>Done</p>;
    } else if (this.importer.started) {
      return <TeamImportStatus progress={this.importer.progress} errors={this.importer.errors} />;
    } else {
      return <TeamImportForm startImport={this.startImport} />;
    }
  }
}

export default TeamImportModal;
