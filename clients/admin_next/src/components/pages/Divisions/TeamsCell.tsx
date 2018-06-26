import * as React from "react";

const TeamsCell = ({teamsCount, numTeams}: any) => {
  let color;

  if (teamsCount === numTeams) {
    color = "green";
  } else if (teamsCount > numTeams) {
    color = "orange";
  } else {
    color = "inherit";
  }

  return (
    <span style={{color}}>
      {teamsCount} / {numTeams}
    </span>
  );
};

export default TeamsCell;
