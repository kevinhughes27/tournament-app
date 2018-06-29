module BracketDb
  class Pools
    def self.[](template)
      TEMPLATES[template].deep_dup
    end

    TEMPLATES = {
      '3.1' => [
        {round: 1, home_pool_seed: 1, away_pool_seed: 3},
        {round: 2, home_pool_seed: 2, away_pool_seed: 3},
        {round: 3, home_pool_seed: 1, away_pool_seed: 2}
      ],
      '4.1' => [
        {round: 1, home_pool_seed: 1, away_pool_seed: 3},
        {round: 2, home_pool_seed: 1, away_pool_seed: 4},
        {round: 3, home_pool_seed: 1, away_pool_seed: 2},

        {round: 1, home_pool_seed: 2, away_pool_seed: 4},
        {round: 2, home_pool_seed: 2, away_pool_seed: 3},
        {round: 3, home_pool_seed: 3, away_pool_seed: 4}
      ],
      '5.1.1' => [
        {round: 1, home_pool_seed: 1, away_pool_seed: 2},
        {round: 2, home_pool_seed: 1, away_pool_seed: 4},
        {round: 3, home_pool_seed: 1, away_pool_seed: 3},
        {round: 4, home_pool_seed: 2, away_pool_seed: 4},
        {round: 5, home_pool_seed: 2, away_pool_seed: 3},

        {round: 1, home_pool_seed: 3, away_pool_seed: 4},
        {round: 2, home_pool_seed: 2, away_pool_seed: 5},
        {round: 3, home_pool_seed: 4, away_pool_seed: 5},
        {round: 4, home_pool_seed: 3, away_pool_seed: 5},
        {round: 5, home_pool_seed: 1, away_pool_seed: 5}
      ],
      '5.1.2' => [
        {round: 1, home_pool_seed: 1, away_pool_seed: 2},
        {round: 2, home_pool_seed: 1, away_pool_seed: 4},
        {round: 3, home_pool_seed: 1, away_pool_seed: 3},
        {round: 4, home_pool_seed: 2, away_pool_seed: 4},
        {round: 5, home_pool_seed: 2, away_pool_seed: 3},

        {round: 1, home_pool_seed: 3, away_pool_seed: 4},
        {round: 2, home_pool_seed: 2, away_pool_seed: 5},
        {round: 3, home_pool_seed: 4, away_pool_seed: 5},
        {round: 4, home_pool_seed: 3, away_pool_seed: 5},
        {round: 5, home_pool_seed: 1, away_pool_seed: 5}
      ],
      '5.1.3' => [
        {round: 1, home_pool_seed: 1, away_pool_seed: 5},
        {round: 2, home_pool_seed: 1, away_pool_seed: 3},
        {round: 3, home_pool_seed: 4, away_pool_seed: 5},
        {round: 4, home_pool_seed: 1, away_pool_seed: 4},
        {round: 5, home_pool_seed: 1, away_pool_seed: 2},

        {round: 1, home_pool_seed: 3, away_pool_seed: 4},
        {round: 2, home_pool_seed: 2, away_pool_seed: 4},
        {round: 3, home_pool_seed: 2, away_pool_seed: 3},
        {round: 4, home_pool_seed: 2, away_pool_seed: 5},
        {round: 5, home_pool_seed: 3, away_pool_seed: 5}
      ],
      '5.1.4' => [
        {round: 1, home_pool_seed: 1, away_pool_seed: 2},
        {round: 2, home_pool_seed: 1, away_pool_seed: 4},
        {round: 3, home_pool_seed: 2, away_pool_seed: 5},
        {round: 4, home_pool_seed: 2, away_pool_seed: 4},
        {round: 5, home_pool_seed: 2, away_pool_seed: 3},

        {round: 1, home_pool_seed: 4, away_pool_seed: 5},
        {round: 2, home_pool_seed: 3, away_pool_seed: 5},
        {round: 3, home_pool_seed: 3, away_pool_seed: 4},
        {round: 4, home_pool_seed: 1, away_pool_seed: 3},
        {round: 5, home_pool_seed: 1, away_pool_seed: 5}
      ],
      '6.1.2' => [
        {round: 1, home_pool_seed: 1, away_pool_seed: 3},
        {round: 2, home_pool_seed: 1, away_pool_seed: 5},
        {round: 3, home_pool_seed: 1, away_pool_seed: 2},
        {round: 4, home_pool_seed: 1, away_pool_seed: 4},
        {round: 5, home_pool_seed: 1, away_pool_seed: 6},


        {round: 1, home_pool_seed: 2, away_pool_seed: 5},
        {round: 2, home_pool_seed: 2, away_pool_seed: 4},
        {round: 3, home_pool_seed: 3, away_pool_seed: 4},
        {round: 4, home_pool_seed: 2, away_pool_seed: 6},
        {round: 5, home_pool_seed: 2, away_pool_seed: 3},


        {round: 1, home_pool_seed: 4, away_pool_seed: 6},
        {round: 2, home_pool_seed: 3, away_pool_seed: 6},
        {round: 3, home_pool_seed: 5, away_pool_seed: 6},
        {round: 4, home_pool_seed: 3, away_pool_seed: 5},
        {round: 5, home_pool_seed: 4, away_pool_seed: 5}
      ],
      '6.1.4' => [
        {round: 1, home_pool_seed: 1, away_pool_seed: 3},
        {round: 2, home_pool_seed: 1, away_pool_seed: 2},
        {round: 3, home_pool_seed: 1, away_pool_seed: 4},
        {round: 4, home_pool_seed: 1, away_pool_seed: 6},
        {round: 5, home_pool_seed: 1, away_pool_seed: 5},


        {round: 1, home_pool_seed: 2, away_pool_seed: 5},
        {round: 2, home_pool_seed: 3, away_pool_seed: 4},
        {round: 3, home_pool_seed: 2, away_pool_seed: 6},
        {round: 4, home_pool_seed: 2, away_pool_seed: 3},
        {round: 5, home_pool_seed: 2, away_pool_seed: 4},


        {round: 1, home_pool_seed: 4, away_pool_seed: 6},
        {round: 2, home_pool_seed: 5, away_pool_seed: 6},
        {round: 3, home_pool_seed: 3, away_pool_seed: 5},
        {round: 4, home_pool_seed: 4, away_pool_seed: 5},
        {round: 5, home_pool_seed: 3, away_pool_seed: 6}
      ],
      'pp6' => [
        {round: 1, home_pool_seed: 1, away_pool_seed: 5},
        {round: 2, home_pool_seed: 1, away_pool_seed: 3},
        {round: 3, home_pool_seed: 1, away_pool_seed: 4},
        {round: 4, home_pool_seed: 1, away_pool_seed: 2},


        {round: 1, home_pool_seed: 2, away_pool_seed: 4},
        {round: 2, home_pool_seed: 2, away_pool_seed: 6},
        {round: 3, home_pool_seed: 2, away_pool_seed: 3},
        {round: 4, home_pool_seed: 3, away_pool_seed: 5},


        {round: 1, home_pool_seed: 3, away_pool_seed: 6},
        {round: 2, home_pool_seed: 4, away_pool_seed: 5},
        {round: 3, home_pool_seed: 5, away_pool_seed: 6},
        {round: 4, home_pool_seed: 4, away_pool_seed: 6}
      ],
      '7.1.1' => [
        {round: 1, home_pool_seed: 5, away_pool_seed: 6},
        {round: 2, home_pool_seed: 1, away_pool_seed: 4},
        {round: 3, home_pool_seed: 1, away_pool_seed: 2},
        {round: 4, home_pool_seed: 1, away_pool_seed: 5},
        {round: 5, home_pool_seed: 1, away_pool_seed: 7},

        {round: 7, home_pool_seed: 1, away_pool_seed: 3},
        {round: 8, home_pool_seed: 1, away_pool_seed: 6},


        {round: 1, home_pool_seed: 2, away_pool_seed: 7},
        {round: 2, home_pool_seed: 2, away_pool_seed: 6},
        {round: 3, home_pool_seed: 5, away_pool_seed: 7},

        {round: 5, home_pool_seed: 2, away_pool_seed: 3},

        {round: 7, home_pool_seed: 2, away_pool_seed: 5},
        {round: 8, home_pool_seed: 2, away_pool_seed: 4},


        {round: 1, home_pool_seed: 3, away_pool_seed: 4},
        {round: 2, home_pool_seed: 3, away_pool_seed: 7},
        {round: 3, home_pool_seed: 3, away_pool_seed: 6},
        {round: 4, home_pool_seed: 4, away_pool_seed: 6},
        {round: 5, home_pool_seed: 4, away_pool_seed: 5},
        {round: 6, home_pool_seed: 6, away_pool_seed: 7},
        {round: 7, home_pool_seed: 4, away_pool_seed: 7},
        {round: 8, home_pool_seed: 3, away_pool_seed: 5}
      ],
      '7.1.2' => [
        {round: 1, home_pool_seed: 1, away_pool_seed: 7},
        {round: 2, home_pool_seed: 1, away_pool_seed: 4},
        {round: 3, home_pool_seed: 1, away_pool_seed: 2},
        {round: 4, home_pool_seed: 1, away_pool_seed: 6},
        {round: 5, home_pool_seed: 1, away_pool_seed: 7},

        {round: 7, home_pool_seed: 1, away_pool_seed: 3},
        {round: 8, home_pool_seed: 1, away_pool_seed: 5},


        {round: 1, home_pool_seed: 2, away_pool_seed: 3},
        {round: 2, home_pool_seed: 2, away_pool_seed: 6},
        {round: 3, home_pool_seed: 4, away_pool_seed: 6},
        {round: 4, home_pool_seed: 5, away_pool_seed: 7},
        {round: 5, home_pool_seed: 5, away_pool_seed: 6},

        {round: 7, home_pool_seed: 2, away_pool_seed: 5},
        {round: 8, home_pool_seed: 2, away_pool_seed: 4},


        {round: 1, home_pool_seed: 4, away_pool_seed: 5},
        {round: 2, home_pool_seed: 3, away_pool_seed: 7},
        {round: 3, home_pool_seed: 3, away_pool_seed: 5},
        {round: 4, home_pool_seed: 3, away_pool_seed: 4},

        {round: 6, home_pool_seed: 6, away_pool_seed: 7},
        {round: 7, home_pool_seed: 4, away_pool_seed: 7},
        {round: 8, home_pool_seed: 3, away_pool_seed: 6}
      ],
      'beach_12' => [
        # Day 1
        {round: 1, home_pool_seed: 1, away_pool_seed: 9},
        {round: 1, home_pool_seed: 2, away_pool_seed: 10},
        {round: 1, home_pool_seed: 3, away_pool_seed: 11},

        {round: 2, home_pool_seed: 4, away_pool_seed: 12},
        {round: 2, home_pool_seed: 6, away_pool_seed: 3},
        {round: 2, home_pool_seed: 10, away_pool_seed: 7},

        {round: 3, home_pool_seed: 7, away_pool_seed: 2},
        {round: 3, home_pool_seed: 5, away_pool_seed: 4},
        {round: 3, home_pool_seed: 8, away_pool_seed: 1},

        {round: 4, home_pool_seed: 9, away_pool_seed: 8},
        {round: 4, home_pool_seed: 12, away_pool_seed:5},
        {round: 4, home_pool_seed: 11, away_pool_seed: 6},

        # Day 2
        {round: 5, home_pool_seed: 1, away_pool_seed: 10},
        {round: 5, home_pool_seed: 8, away_pool_seed: 7},

        {round: 6, home_pool_seed: 9, away_pool_seed: 2},
        {round: 6, home_pool_seed: 3, away_pool_seed: 4},

        {round: 7, home_pool_seed: 6, away_pool_seed: 12},
        {round: 7, home_pool_seed: 11, away_pool_seed: 5},

        {round: 8, home_pool_seed: 1, away_pool_seed: 7},
        {round: 8, home_pool_seed: 8, away_pool_seed: 2},

        {round: 9, home_pool_seed: 9, away_pool_seed: 10},
        {round: 9, home_pool_seed: 3, away_pool_seed: 12},

        {round: 10, home_pool_seed: 6, away_pool_seed: 5},
        {round: 10, home_pool_seed: 11, away_pool_seed: 4},

        # Day 3
        {round: 11, home_pool_seed: 8, away_pool_seed: 3},
        {round: 11, home_pool_seed: 7, away_pool_seed: 12},

        {round: 12, home_pool_seed: 10, away_pool_seed: 5},
        {round: 12, home_pool_seed: 1, away_pool_seed: 11},

        {round: 13, home_pool_seed: 8, away_pool_seed: 6},
        {round: 13, home_pool_seed: 9, away_pool_seed: 3},

        {round: 14, home_pool_seed: 1, away_pool_seed: 6},
        {round: 14, home_pool_seed: 2, away_pool_seed: 4},

        {round: 15, home_pool_seed: 9, away_pool_seed: 11},
        {round: 15, home_pool_seed: 7, away_pool_seed: 5},

        {round: 16, home_pool_seed: 2, away_pool_seed: 12},
        {round: 16, home_pool_seed: 10, away_pool_seed: 4},

        # Day 4
        {round: 17, home_pool_seed: 9, away_pool_seed: 6},
        {round: 17, home_pool_seed: 8, away_pool_seed: 11},

        {round: 18, home_pool_seed: 7, away_pool_seed: 4},
        {round: 18, home_pool_seed: 1, away_pool_seed: 3},

        {round: 19, home_pool_seed: 11, away_pool_seed: 12},
        {round: 19, home_pool_seed: 2, away_pool_seed: 5},

        {round: 20, home_pool_seed: 1, away_pool_seed: 2},
        {round: 20, home_pool_seed: 8, away_pool_seed: 10},

        {round: 21, home_pool_seed: 9, away_pool_seed: 7},
        {round: 21, home_pool_seed: 3, away_pool_seed: 5},

        {round: 22, home_pool_seed: 6, away_pool_seed: 4},
        {round: 22, home_pool_seed: 10, away_pool_seed: 12}
      ]
    }
  end
end
