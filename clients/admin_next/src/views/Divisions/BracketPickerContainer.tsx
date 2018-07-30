import * as React from "react";
import { graphql } from "react-relay";
import renderQuery from "../../helpers/renderHelper";
import BracketPicker from "./BracketPicker";
import BracketLoader from "./BracketLoader";

interface Props {
  numTeams: number;
  numDays: number;
  bracketType: string;
  onChange: (event: React.ChangeEvent<{}>) => void;
}

class BracketPickerContainer extends React.Component<Props> {
  render() {
    const query = graphql`
      query BracketPickerContainerQuery($numTeams: Int!, $numDays: Int!) {
        brackets(numTeams: $numTeams, numDays: $numDays) {
          ...BracketPicker_brackets
        }
      }
    `;

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
