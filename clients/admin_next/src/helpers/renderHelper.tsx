import * as React from "react";
import Loader from "../components/Loader";

const render = (Component: React.ComponentType<any>) =>
  ({error, props}: any) => {
    if (error) {
      return <div>{error.message}</div>;
    } else if (props) {
      return <Component {...props}/>;
    } else {
      return <Loader />;
    }
  };

export default render;
