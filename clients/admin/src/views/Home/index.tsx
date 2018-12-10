import * as React from 'react';
import { query } from '../../queries/HomeQuery';
import renderQuery from '../../helpers/renderQuery';
import Checklist from './Checklist';

class Home extends React.Component {
  render() {
    return renderQuery(query, {}, Checklist, {
      fetchPolicy: 'cache-and-network'
    });
  }
}

export default Home;
