import * as React from "react";
import gql from "graphql-tag";
import { Query } from "react-apollo";
import Loader from "../../components/Loader";
import Checklist from "./Checklist";

const query = gql`
  query HomeQuery {
    fields {
      id
    }
    teams {
      id
    }
    divisions {
      id
      numTeams
      isSeeded
    }
    games {
      id
      scheduled
      endTime
      scoreConfirmed
    }
    scoreDisputes {
      id
    }
  }
`;

class Home extends React.Component {
  render() {
    return (
      <Query query={query}>
        {({ loading, error, data }) => {
          if (loading) return <Loader />;
          if (error) return <div>{error.message}</div>;

          return <Checklist {...data} />;
        }}
      </Query>
    )
  }
}

export default Home;
