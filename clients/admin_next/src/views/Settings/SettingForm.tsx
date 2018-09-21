import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import { FormikValues, FormikProps } from "formik";
import { isEmpty } from "lodash";

import Radio from "@material-ui/core/Radio";
import RadioButtonUncheckedIcon from "@material-ui/icons/RadioButtonUnchecked";
import RadioButtonCheckedIcon from "@material-ui/icons/RadioButtonChecked";
import RadioGroup from "@material-ui/core/RadioGroup";
import FormControlLabel from "@material-ui/core/FormControlLabel";

import TextField from "@material-ui/core/TextField";
import FormButtons from "../../components/FormButtons";
import Form from "../../components/Form";
import UpdateSettingsMutation from "../../mutations/UpdateSettings";

interface Props extends RouteComponentProps<any> {
  input: UpdateSettingsMutationVariables["input"];
}

class SettingForm extends Form<Props> {

  initialValues = () => {
    const { input } = this.props;
    return {
      name: input.name || "",
      handle: input.handle || "",
      timezone: input.timezone || "",
      scoreSubmitPin: input.scoreSubmitPin || "",
      gameConfirmSetting: input.gameConfirmSetting || ""
    };
  }

  mutation = () => {
    return UpdateSettingsMutation;
  }

  mutationInput = (values: FormikValues) => {
    return {input: values};
  }

  renderForm = (formProps: FormikProps<FormikValues>) => {
    const {
      values,
      dirty,
      errors,
      handleChange,
      handleSubmit,
      isSubmitting
    } = formProps;

    return (
      <form onSubmit={handleSubmit}>
        <TextField
          name="name"
          label="Name"
          type="name"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.name}
          onChange={handleChange}
        />
        <TextField
          name="handle"
          label="Handle"
          type="name"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.handle}
          onChange={handleChange}
        />
        <TextField
          name="timezone"
          label="TimeZone"
          type="name"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.timezone}
          onChange={handleChange}
        />
        <TextField
          name="scoreSubmitPin"
          label="Score Submit Pin Code"
          type="name"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.scoreSubmitPin}
          onChange={handleChange}
        />
        <label>Score Confirmation Settings</label>
        <RadioGroup
          aria-label="gameConfirmSetting"
          name="gameConfirmSetting"
          value={values.gameConfirmSetting}
          onChange={handleChange}
        >
            <FormControlLabel value="single" onChange={handleChange} control={<Radio />} label="Single" />
            <FormControlLabel value="multiple" onChange={handleChange} control={<Radio />} label="Multiple" />
        </RadioGroup>
        <FormButtons
          formDirty={dirty}
          formValid={isEmpty(errors)}
          submitting={isSubmitting}
        />
      </form>
    );
  }
}

export default withRouter(SettingForm);
