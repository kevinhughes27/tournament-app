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
  type: string;
}
