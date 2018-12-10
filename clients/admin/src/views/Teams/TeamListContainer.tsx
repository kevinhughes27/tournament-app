import * as React from 'react';
import { query } from '../../queries/TeamListQuery';
import renderQuery from '../../helpers/renderQuery';
import TeamList from './TeamList';

class TeamListContainer extends React.Component {
  render() {
    return renderQuery(query, {}, TeamList);
  }
}

export default TeamListContainer;
