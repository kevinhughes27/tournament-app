import * as React from "react";
import { withRouter, RouteComponentProps } from "react-router-dom";
import { FormikValues, FormikProps, FormikErrors } from "formik";
import { isEmpty } from "lodash";

import TextField from "@material-ui/core/TextField";
import BracketPicker from "./BracketPickerContainer";
import FormButtons from "../../components/FormButtons";

import Form from "../../components/Form";
import runMutation from "../../helpers/mutationHelper";
import CreateDivisionMutation from "../../mutations/CreateDivision";
import UpdateDivisionMutation from "../../mutations/UpdateDivision";
import DeleteDivisionMutation from "../../mutations/DeleteDivision";

interface Props extends RouteComponentProps<any> {
  input: UpdateDivisionMutationVariables["input"] & CreateDivisionMutationVariables["input"];
}

class DivisionForm extends Form<Props> {
  initialValues = () => {
    return {
      name: this.props.input.name,
      numTeams: this.props.input.numTeams,
      numDays: this.props.input.numDays,
      bracketType: this.props.input.bracketType,
    };
  }

  validate = (values: FormikValues) => {
    const errors: FormikErrors<FormikValues> = {};

    if (!values.name) {
      errors.name = "Required";
    }

    if (values.numTeams && values.numTeams <= 0) {
      errors.numTeams = "Must be greater than 0";
    }

    if (values.numDays && values.numDays <= 0) {
      errors.numDays = "Must be greater than 0";
    }

    return errors;
  }

  submit = (values: FormikValues) => {
    const divisionId = this.props.input.id;

    if (divisionId) {
      return UpdateDivisionMutation.commit({input: {id: divisionId, ...values}});
    } else {
      return CreateDivisionMutation.commit({input: {...values}});
    }
  }

  delete = () => {
    const divisionId = this.props.input.id;

    if (divisionId) {
      return () => {
          runMutation(
          DeleteDivisionMutation,
          {input: {id: divisionId}},
          () => this.props.history.push("/divisions")
        );
      };
    } else {
      return undefined;
    }
  }

  renderForm = (formProps: FormikProps<FormikValues>) => {
    const {
      values,
      dirty,
      errors,
      setFieldValue,
      handleChange,
      handleSubmit,
      isSubmitting
    } = formProps;

    return (
      <form onSubmit={handleSubmit}>
        <TextField
          name="name"
          label="Name"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.name}
          onChange={handleChange}
          helperText={errors.name}
        />
        <TextField
          name="numTeams"
          label="Number of Teams"
          type="number"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.numTeams}
          onChange={handleChange}
          helperText={errors.numTeams}
        />
        <TextField
          name="numDays"
          label="Number of Days"
          type="number"
          margin="normal"
          autoComplete="off"
          fullWidth
          value={values.numDays}
          onChange={handleChange}
          helperText={errors.numDays}
        />
        <BracketPicker
          numTeams={values.numTeams}
          numDays={values.numDays}
          bracketType={values.bracketType}
          setValue={setFieldValue}
          onChange={handleChange}
        />
        <FormButtons
          formDirty={dirty}
          formValid={isEmpty(errors)}
          submitting={isSubmitting}
          cancelLink={"/divisions"}
          delete={this.delete()}
        />
      </form>
    );
  }
}

export default withRouter(DivisionForm);
