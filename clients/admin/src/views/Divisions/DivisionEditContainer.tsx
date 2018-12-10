import * as React from 'react';
import { withRouter, RouteComponentProps } from 'react-router-dom';
import { query } from '../../queries/DivisionEditQuery';
import renderQuery from '../../helpers/renderQuery';
import DivisionEdit from './DivisionEdit';

interface Props extends RouteComponentProps<any> {}

class DivisionEditContainer extends React.Component<Props> {
  render() {
    const divisionId = this.props.match.params.divisionId;
    return renderQuery(query, { divisionId }, DivisionEdit);
  }
}

export default withRouter(DivisionEditContainer);
