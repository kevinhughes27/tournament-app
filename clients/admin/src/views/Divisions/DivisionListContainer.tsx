import * as React from 'react';
import { query } from '../../queries/DivisionListQuery';
import renderQuery from '../../helpers/renderQuery';
import DivisionList from './DivisionList';

class DivisionListContainer extends React.Component {
  render() {
    return renderQuery(query, {}, DivisionList);
  }
}

export default DivisionListContainer;
