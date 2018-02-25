class ScoreGenerator
  class << self
    def generate
      self.new.score
    end
  end

  def initialize
    @score1 = random_score
    @score2 = random_score
    while @score2 == @score1
      @score2 = random_score
    end
  end

  def score
    [@score1, @score2]
  end

  private

  def random_score
    Faker::Number.between(1, 15)
  end
end
