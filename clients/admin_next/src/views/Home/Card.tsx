import * as React from "react";
import UiCard from "@material-ui/core/Card";
import CardContent from "@material-ui/core/CardContent";
import Hidden from '@material-ui/core/Hidden';

import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { IconDefinition } from "@fortawesome/fontawesome-svg-core";

interface Props {
  text: string;
  icon: IconDefinition;
}

class Card extends React.Component<Props> {
  render() {
    return(
      <UiCard>
        <CardContent style={{paddingBottom: 10}}>
          <Hidden only="xs">
            <div className="home-card">
              {this.props.text}
              <div>
                <div className="icon">
                  <FontAwesomeIcon icon={this.props.icon} />
                </div>
              </div>
            </div>
          </Hidden>
          <Hidden smUp>
            {this.props.text}
          </Hidden>
        </CardContent>
      </UiCard>
    );
  }
}

export default Card;
