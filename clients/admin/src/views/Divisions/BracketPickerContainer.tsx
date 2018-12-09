import * as React from "react";
import { query } from "../../queries/BracketPickerQuery";
import renderQuery from "../../helpers/renderQuery";
import BracketPicker from "./BracketPicker";
import BracketLoader from "./BracketLoader";

interface Props {
  numTeams: number;
  numDays: number;
  bracketType: string;
  setValue: (field: string, value: string) => void;
  onChange: (event: React.ChangeEvent<{}>) => void;
}

class BracketPickerContainer extends React.Component<Props> {
  render() {
    const variables = {
      numTeams: this.props.numTeams,
      numDays: this.props.numDays
    };

    if (variables.numTeams && variables.numDays) {
      return renderQuery(query, variables, BracketPicker, {loader: BracketLoader, props: this.props});
    } else {
      return <BracketLoader />;
    }
  }
}

export default BracketPickerContainer;
