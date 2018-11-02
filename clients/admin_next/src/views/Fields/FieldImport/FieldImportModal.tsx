import * as React from "react";
import ImportModal from "../../../components/Importer/ImportModal";
import FieldImporter from "./FieldImporter";
import FieldImportForm from "./FieldImportForm";

interface Props {
  open: boolean;
  onClose: () => void;
}

class FieldImportModal extends React.Component<Props> {
  render() {
    return(
      <ImportModal
        formComponent={FieldImportForm}
        importerClass={FieldImporter}
        object="fields"
        open={this.props.open}
        onClose={this.props.onClose}
      />
    );
  }
}

export default FieldImportModal;
