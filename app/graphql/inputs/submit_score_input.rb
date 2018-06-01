class Inputs::SubmitScoreInput < Inputs::BaseInputObject
  argument :gameId, ID, required: true
  argument :teamId, ID, required: true
  argument :submitterFingerprint, String, required: true
  argument :homeScore, Int, required: true
  argument :awayScore, Int, required: true
  argument :rulesKnowledge, Int, required: true
  argument :fouls, Int, required: true
  argument :fairness, Int, required: true
  argument :attitude, Int, required: true
  argument :communication, Int, required: true
  argument :comments, String, required: false
end
