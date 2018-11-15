import { requestSubscription, GraphQLTaggedNode  } from "react-relay";
import environment from "../helpers/relay";

export default (
  subscription: GraphQLTaggedNode,
  updater: any
) => {
  requestSubscription(
    environment,
    {
      subscription,
      variables: {},
      updater,
      onCompleted: () => {/* server closed the subscription */},
      onError: error => console.error(error),
    }
  );
}
