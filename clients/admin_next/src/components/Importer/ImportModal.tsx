import * as React from "react";
import Modal from "../Modal";
import ImportStatus from "./ImportStatus";
import ImportResult from "./ImportResult";

interface Props {
  open: boolean;
  onClose: () => void;
  object: string;
  importerClass: any;
  importerData?: any;
  formComponent: any;
}

class ImportModal extends React.Component<Props> {
  importer: any;

  constructor(props: Props) {
    super(props);
    this.importer = this.buildImporter();
  }

  buildImporter = () => {
    if (this.props.importerData) {
      return new this.props.importerClass(this, this.props.importerData);
    } else {
      return new this.props.importerClass(this);
    }
  }

  startImport = (data: string[][]) => {
    this.importer.start(data);
  }

  onClose = () => {
    if (this.importer.progress === 100) {
      this.importer = this.buildImporter();
      this.props.onClose();
    } else if (!this.importer.started) {
      this.props.onClose();
    }
  }

  render() {
    return (
      <Modal
        title={`Import ${this.props.object}`}
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
        <ImportResult
          completed={this.importer.completed}
          errors={this.importer.errors}
          object={this.props.object}
          onClose={this.onClose}
        />
      );
    } else if (this.importer.started) {
      return <ImportStatus progress={this.importer.progress} errors={this.importer.errors} />;
    } else {
      return <this.props.formComponent startImport={this.startImport} closeModal={this.onClose} />;
    }
  }
}

export default ImportModal;
