class DivisionDelete < ApplicationOperation
  input :division, accepts: Division, required: true
  input :confirm, default: false

  class Failed < StandardError
    attr_reader :division

    def initialize(division, *args)
      @division = division
      super('DivisionCreate failed.', *args)
    end
  end

  def execute
    raise ConfirmationRequired if !(confirm == 'true' || division.safe_to_delete?)
    raise Failed(division) unless division.destroy
  end
end
