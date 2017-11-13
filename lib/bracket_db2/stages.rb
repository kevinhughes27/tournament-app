module BracketDb
  class Stage
    attr_reader :games

    def initialize
      @games = []
    end
  end

  class PoolStage < Stage
    def pool(identifier, type, input)
      @games += [
        {"pool":identifier, "round":1, "home_pool_seed":1, "away_pool_seed":3},
        {"pool":identifier, "round":2, "home_pool_seed":1, "away_pool_seed":4},
        {"pool":identifier, "round":3, "home_pool_seed":1, "away_pool_seed":2},

        {"pool":identifier, "round":1, "home_pool_seed":2, "away_pool_seed":4},
        {"pool":identifier, "round":2, "home_pool_seed":2, "away_pool_seed":3},
        {"pool":identifier, "round":3, "home_pool_seed":3, "away_pool_seed":4}
      ]
    end
  end

  class BracketStage < Stage
    def bracket(type, input)
      @games += [
        {"round": 1, "bracket_uid":"a", "home_prereq":"A1", "away_prereq":"B4"},
        {"round": 1, "bracket_uid":"b", "home_prereq":"B2", "away_prereq":"A3"},
        {"round": 1, "bracket_uid":"c", "home_prereq":"A2", "away_prereq":"B3"},
        {"round": 1, "bracket_uid":"d", "home_prereq":"B1", "away_prereq":"A4"},

        {"round": 2, "bracket_uid": "e", "home_prereq":"Wa", "away_prereq":"Wb"},
        {"round": 2, "bracket_uid": "f", "home_prereq":"Wc", "away_prereq":"Wd"},
        {"round": 2, "bracket_uid": "h", "home_prereq":"La", "away_prereq":"Lb"},
        {"round": 2, "bracket_uid": "i", "home_prereq":"Lc", "away_prereq":"Ld"},

        {"round": 3, "bracket_uid": "1", "home_prereq":"We", "away_prereq":"Wf"},
        {"round": 3, "bracket_uid": "3", "home_prereq":"Le", "away_prereq":"Lf"},
        {"round": 3, "bracket_uid": "5", "home_prereq":"Wh", "away_prereq":"Wi"},
        {"round": 3, "bracket_uid": "7", "home_prereq":"Lh", "away_prereq":"Li"}
      ]
    end
  end

  class ResultsStage
  end
end
