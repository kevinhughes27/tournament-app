import * as React from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faCheck, faTimes, faExclamationCircle } from "@fortawesome/free-solid-svg-icons";

const SeededCell = ({isSeeded, needsSeed}: any) => {
  let icon;
  let color;

  if (isSeeded && !needsSeed) {
    icon = faCheck;
    color = "green";
  } else if (!isSeeded) {
    icon = faTimes;
    color = "orange";
  } else {
    icon = faExclamationCircle;
    color = "orange";
  }

  return (
    <FontAwesomeIcon icon={icon} style={{color}}/>
  );
};

export default SeededCell;
