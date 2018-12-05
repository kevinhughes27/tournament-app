import * as React from "react";
import ImportIcon from "@material-ui/icons/GroupAdd";
import ImportModal from "../../../components/Importer/ImportModal";
import TeamImporter from "./TeamImporter";

const CSVHeader = ["Name", "Email", "Division", "Seed"];

interface Props {
  divisions: TeamListQuery['divisions'];
  open: boolean;
  onClose: () => void;
}

class TeamImportModal extends React.Component<Props> {
  render() {
    return(
      <ImportModal
        icon={<ImportIcon />}
        object="teams"
        csvHeader={CSVHeader}
        importerClass={TeamImporter}
        importerData={this.props.divisions}
        open={this.props.open}
        onClose={this.props.onClose}
      />
    );
  }
}

export default TeamImportModal;
