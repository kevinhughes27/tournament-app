import * as React from "react";
import ImportModal from "../../../components/Importer/ImportModal";
import TeamImportForm from "./TeamImportForm";
import TeamImporter from "./TeamImporter";

interface Props {
  divisions: TeamImport_divisions;
  open: boolean;
  onClose: () => void;
}

class TeamImportModal extends React.Component<Props> {
  render() {
    return(
      <ImportModal
        formComponent={TeamImportForm}
        importerClass={TeamImporter}
        importerData={this.props.divisions}
        object="teams"
        open={this.props.open}
        onClose={this.props.onClose}
      />
    );
  }
}

export default TeamImportModal;
