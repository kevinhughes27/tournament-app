import { DataProxy } from "apollo-cache";

function updater<MutationType> (implementation: (store: DataProxy, payload: MutationType) => void) {
  return (store: DataProxy, response: any) => {
    implementation(store, response.data);
  }
}

export default updater;
