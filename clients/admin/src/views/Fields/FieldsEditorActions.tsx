import * as React from 'react';
import ActionMenu from '../../components/ActionMenu';
import FormButtons from '../../components/FormButtons';
import EditIcon from '@material-ui/icons/Edit';
import AddIcon from '@material-ui/icons/Add';
import ImportIcon from '@material-ui/icons/AddToPhotos';
import DownloadIcon from '@material-ui/icons/CloudDownload';

interface Props {
  mode: 'none' | 'view' | 'editMap' | 'addField' | 'editField';
  valid: boolean;
  submitting: boolean;
  editMap: () => void;
  addField: () => void;
  saveMap: () => void;
  createField: () => void;
  saveField: () => void;
  deleteField: () => void;
  importFields: () => void;
  cancel: () => void;
}

class FieldsEditorActions extends React.Component<Props> {
  exportFields = () => {
    const url = '/fields.csv';
    window.location.href = url;
  };

  render() {
    const {
      mode,
      valid,
      submitting,
      saveMap,
      createField,
      saveField,
      deleteField,
      cancel
    } = this.props;

    if (mode === 'view') {
      return this.viewActions();
    } else if (mode === 'editMap') {
      return (
        <FormButtons submitting={submitting} submit={saveMap} cancel={cancel} />
      );
    } else if (mode === 'addField') {
      return (
        <FormButtons
          formValid={valid}
          submitting={submitting}
          submit={createField}
          cancel={cancel}
        />
      );
    } else if (mode === 'editField') {
      return (
        <FormButtons
          formValid={valid}
          submitting={submitting}
          submit={saveField}
          delete={deleteField}
          cancel={cancel}
        />
      );
    } else {
      return null;
    }
  }

  viewActions = () => {
    const { editMap, addField, importFields } = this.props;

    const actions = [
      { icon: <EditIcon />, name: 'Edit Map', handler: editMap },
      { icon: <AddIcon />, name: 'Add Field', handler: addField },
      { icon: <ImportIcon />, name: 'Import Fields', handler: importFields },
      {
        icon: <DownloadIcon />,
        name: 'Export Fields',
        handler: this.exportFields
      }
    ];

    return <ActionMenu actions={actions} />;
  };
}

export default FieldsEditorActions;
