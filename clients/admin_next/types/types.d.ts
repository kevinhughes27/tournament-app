type ID = string;

type Team = {
  id: ID;
  name: string;
  email: string;
  division: Division;
  seed: number;
}

type Division = {
  id: ID;
  name: string;
  bracketType: string;
  teamsCount: number;
  numTeams: number;
  isSeeded: boolean;
}

type MapType = {
  lat: number;
  long: number;
  zoom: number;
}

type Field = {
  id: ID;
  name: string;
  lat: number;
  long: number;
  geoJson: string;
}

type Game = {
  id: ID;
  pool: string;
  homeName: string;
  awayName: string;
  homePrereq: string;
  awayPrereq: string;
  homePoolSeed: number;
  awayPoolSeed: number;
  bracketUid: string;
  homeScore: number;
  awayScore: number;
  division : Division;
  field: Field;
  startTime: string;
  endTime: string;
  updatedAt: string;
  scheduled: boolean;
}
