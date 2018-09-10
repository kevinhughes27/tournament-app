import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";
import Breadcrumbs from "../../components/Breadcrumbs";
import UserEditForm from "./UserEditForm";

interface Props {
  viewer: UserEdit_viewer;
}

class UserEdit extends React.Component<Props> {
  render() {
    const { viewer } = this.props;
    const input = {
      viewerId: viewer.id,
      name: viewer.name || 0,
      email: viewer.email || 0
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
