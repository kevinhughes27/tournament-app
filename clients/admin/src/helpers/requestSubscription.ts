import { requestSubscription, GraphQLTaggedNode  } from "react-relay";
import environment from "../modules/relay";

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
