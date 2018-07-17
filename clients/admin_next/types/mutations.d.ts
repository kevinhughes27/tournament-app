interface MutationResult {
  success: boolean;
  message: string;
  userErrors: UserError[];
}

type UpdateTeam = {
  team: Team;
  success: boolean;
  confirm: boolean;
  message: string;
  userErrors: UserError[];
}

type UserError = {
  field: string;
  message: string;
}
