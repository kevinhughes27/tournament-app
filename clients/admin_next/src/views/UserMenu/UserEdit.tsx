import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";
import UserEditForm from "./UserEditForm";

interface Props {
  viewer: UserEdit_viewer;
}

class UserEdit extends React.Component<Props> {
  render() {
    const { viewer } = this.props;
    const input = {
      id: viewer.id,
      name: viewer.name || "",
      email: viewer.email || ""
    };
    return (
       <div>
        <UserEditForm input={input} />
      </div>
    );
  }
}

export default createFragmentContainer(UserEdit, {
  viewer: graphql`
    fragment UserEdit_viewer on User {
      id
      name
      email
    }
  `
});
