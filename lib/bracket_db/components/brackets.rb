module BracketDb
  class Brackets
    def self.[](template)
      TEMPLATES[template].deep_dup
    end

    TEMPLATES = {
      '8.1' => [
        {round: 1, bracket_uid: "a", home_prereq: "A1", away_prereq: "B4"},
        {round: 1, bracket_uid: "b", home_prereq: "B2", away_prereq: "A3"},
        {round: 1, bracket_uid: "c", home_prereq: "A2", away_prereq: "B3"},
        {round: 1, bracket_uid: "d", home_prereq: "B1", away_prereq: "A4"},

        {round: 2, bracket_uid: "e", home_prereq: "Wa", away_prereq: "Wb"},
        {round: 2, bracket_uid: "f", home_prereq: "Wc", away_prereq: "Wd"},
        {round: 2, bracket_uid: "h", home_prereq: "La", away_prereq: "Lb"},
        {round: 2, bracket_uid: "i", home_prereq: "Lc", away_prereq: "Ld"},

        {round: 3, bracket_uid: "1", home_prereq: "We", away_prereq: "Wf"},
        {round: 3, bracket_uid: "3", home_prereq: "Le", away_prereq: "Lf"},
        {round: 3, bracket_uid: "5", home_prereq: "Wh", away_prereq: "Wi"},
        {round: 3, bracket_uid: "7", home_prereq: "Lh", away_prereq: "Li"}
      ],
      '8.2.1' => [
        {round: 1, bracket_uid: "a", home_prereq: "A1", away_prereq: "B2"},
        {round: 1, bracket_uid: "b", home_prereq: "A2", away_prereq: "B1"},
        {round: 2, bracket_uid: "1", home_prereq: "Wa", away_prereq: "Wb"},

        {round: 1, bracket_uid: "d", home_prereq: "A3", away_prereq: "B4"},
        {round: 1, bracket_uid: "e", home_prereq: "A4", away_prereq: "B3"},
        {round: 2, bracket_uid: "f", home_prereq: "La", away_prereq: "Wd"},
        {round: 2, bracket_uid: "g", home_prereq: "We", away_prereq: "Lb"},

        {round: 3, bracket_uid: "h", home_prereq: "Wf", away_prereq: "Wg"},
        {round: 4, bracket_uid: "2", home_prereq: "L1", away_prereq: "Wh"},

        {round: 3, bracket_uid: "5", home_prereq: "Lf", away_prereq: "Lg"},
        {round: 3, bracket_uid: "7", home_prereq: "Ld", away_prereq: "Le"}
      ],
      '16.1' => [
        {round: 1, bracket_uid: "a", home_prereq: "B2", away_prereq: "C3"},
        {round: 1, bracket_uid: "b", home_prereq: "C2", away_prereq: "B3"},
        {round: 1, bracket_uid: "c", home_prereq: "D2", away_prereq: "A3"},
        {round: 1, bracket_uid: "d", home_prereq: "A2", away_prereq: "D3"},

        {round: 2, bracket_uid: "e", home_prereq: "A1", away_prereq: "Wa"},
        {round: 2, bracket_uid: "f", home_prereq: "D1", away_prereq: "Wb"},
        {round: 2, bracket_uid: "g", home_prereq: "C1", away_prereq: "Wc"},
        {round: 2, bracket_uid: "h", home_prereq: "B1", away_prereq: "Wd"},

        {round: 2, bracket_uid: "k", home_prereq: "La", away_prereq: "Lb"},
        {round: 2, bracket_uid: "l", home_prereq: "Lc", away_prereq: "Ld"},

        {round: 3, bracket_uid:  "i", home_prereq: "We", away_prereq: "Wf"},
        {round: 3, bracket_uid:  "j", home_prereq: "Wg", away_prereq: "Wh"},

        {round: 3, bracket_uid: "9", home_prereq: "Wk", away_prereq: "Wl"},
        {round: 3, bracket_uid: "11", home_prereq: "Lk", away_prereq: "Ll"},

        {round: 3, bracket_uid: "m", home_prereq: "Le", away_prereq: "Lf"},
        {round: 3, bracket_uid: "n", home_prereq: "Lg", away_prereq: "Lh"},

        {round: 4, bracket_uid: "1", home_prereq: "Wi", away_prereq: "Wj"},
        {round: 4, bracket_uid: "3", home_prereq: "Li", away_prereq: "Lj"},
        {round: 4, bracket_uid: "5", home_prereq: "Wm", away_prereq: "Wn"},
        {round: 4, bracket_uid: "7", home_prereq: "Lm", away_prereq: "Ln"}
      ]
    }
  end
end
