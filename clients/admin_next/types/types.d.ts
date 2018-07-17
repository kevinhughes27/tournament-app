type Team = {
  id: string;
  name: string;
  email: string;
  division: Division;
  seed: number;
}

type Division = {
  id: string;
  name: string;
  bracketType: string;
  teamsCount: number;
  numTeams: number;
  isSeeded: boolean;
}

type Field = {
  id: string;
  name: string;
  lat: number;
  long: number;
}

type Game = {
  id: string;
  pool: string;
  homeName: string;
  awayName: string;
  homeScore: number;
  awayScore: number;
  division : Division;
}
