class Team < ActiveRecord::Base
  include BulkSet
  belongs_to :tournament
end
