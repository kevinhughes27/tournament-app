import * as React from 'react';
import { query } from '../../queries/TeamNewQuery';
import renderQuery from '../../helpers/renderQuery';
import TeamNew from './TeamNew';

class TeamNewContainer extends React.Component {
  render() {
    return renderQuery(query, {}, TeamNew);
  }
}

export default TeamNewContainer;
