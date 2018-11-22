import * as React from "react";
import {createFragmentContainer, graphql} from "react-relay";
import Avatar from "@material-ui/core/Avatar";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faEdit } from "@fortawesome/free-solid-svg-icons";
import gravatarUrl from "gravatar-url";
import PasswordForm from "./PasswordForm";

interface Props {
  viewer: UserShow_viewer;
}

class UserShow extends React.Component<Props> {
  render() {
    const { viewer } = this.props;
    const avatarUrl = gravatarUrl(viewer.email, {size: 100});

    return (
       <div className="user_info">
        <div className="col-md-6 col-md-offset-3">
          <div className="user-email">
            <span className="user-image"><Avatar alt={viewer.email} src={avatarUrl} />
              <span>
                <a href="https://en.gravatar.com/" target="blank">
                  <FontAwesomeIcon icon={faEdit} />
                </a>
              </span>
            </span>
            <div className="extra-wrap">
              <div>{viewer.name}</div>
              <div>{viewer.email}</div>
            </div>
          </div>
          <PasswordForm />
        </div>
      </div>
    );
  }
}

export default createFragmentContainer(UserShow, {
  viewer: graphql`
    fragment UserShow_viewer on User {
      name
      email
    }
  `
});
