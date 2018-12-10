import * as React from 'react';
import ImportIcon from '@material-ui/icons/AddToPhotos';
import ImportModal from '../../../components/Importer/ImportModal';
import FieldImporter from './FieldImporter';

const CSVHeader = ['Name', 'Latitude', 'Longitude', 'GeoJSON'];

interface Props {
  open: boolean;
  onClose: () => void;
}

class FieldImportModal extends React.Component<Props> {
  render() {
    return (
      <ImportModal
        icon={<ImportIcon />}
        object="fields"
        csvHeader={CSVHeader}
        importerClass={FieldImporter}
        open={this.props.open}
        onClose={this.props.onClose}
      />
    );
  }
}

export default FieldImportModal;
