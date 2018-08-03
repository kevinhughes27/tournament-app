import TeamImportModal from "./TeamImportModal";
import {createFragmentContainer, graphql} from "react-relay";

export default createFragmentContainer(TeamImportModal, {
  divisions: graphql`
    fragment TeamImport_divisions on Division @relay(plural: true) {
      id
      name
    }
  `
});
