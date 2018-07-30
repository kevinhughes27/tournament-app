interface SchedulingResult {
  readonly game: {
    readonly id: string;
    readonly startTime: any | null;
    readonly endTime: any | null;
    readonly field: ({
        readonly id: string;
    }) | null;
  };
  readonly success: boolean;
  readonly message: string | null;
}

interface MutationResult {
  readonly success: boolean;
  readonly message: string | null;
  readonly userErrors: ReadonlyArray<{
      readonly field: string;
      readonly message: string;
  }> | null
}

interface UserError {
  readonly field: string;
  readonly message: string;
}
