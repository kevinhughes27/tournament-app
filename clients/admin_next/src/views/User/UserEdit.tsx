import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";
import Avatar from "@material-ui/core/Avatar";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faEdit } from "@fortawesome/free-solid-svg-icons";
import gravatarUrl from "gravatar-url";
import UserEditForm from "./UserEditForm";

interface Props {
  viewer: UserEdit_viewer;
}

class UserEdit extends React.Component<Props> {
  render() {
    const { viewer } = this.props;
    const avatarUrl = gravatarUrl(viewer.email, {size: 100});
    const input = {
      id: viewer.id,
      password: ""
    };
    return (
       <div className="user_info">
        <div className="col-md-6 col-md-offset-3">
          <div className="user-email">
            <span className="user-image"><Avatar alt={viewer.email} src={avatarUrl} />
            <span><FontAwesomeIcon icon={faEdit} /></span>
            </span>
            <div className="extra-wrap">
              <div>{viewer.name}</div>
              <div>{viewer.email}</div>
            </div>
          </div>
           <UserEditForm input={input} />
        </div>
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
