import * as React from "react";
import Modal from "../../../components/Modal";
import FieldImporter from "./FieldImporter";
import FieldImportForm from "./FieldImportForm";
import FieldImportStatus from "./FieldImportStatus";
import FieldImportResult from "./FieldImportResult";

interface Props {
  open: boolean;
  onClose: () => void;
}

class FieldImportModal extends React.Component<Props> {
  importer: FieldImporter;

  constructor(props: Props) {
    super(props);
    this.importer = new FieldImporter(this);
  }

  startImport = (data: string[][]) => {
    this.importer.start(data);
  }

  onClose = () => {
    if (this.importer.progress === 100) {
      this.importer = new FieldImporter(this);
      this.props.onClose();
    } else if (!this.importer.started) {
      this.props.onClose();
    }
  }

  render() {
    return (
      <Modal
        title="Import Fields"
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
        <FieldImportResult
          completed={this.importer.completed}
          errors={this.importer.errors}
          onClose={this.onClose}
        />
      );
    } else if (this.importer.started) {
      return <FieldImportStatus progress={this.importer.progress} errors={this.importer.errors} />;
    } else {
      return <FieldImportForm startImport={this.startImport} closeModal={this.onClose} />;
    }
  }
}

export default FieldImportModal;
