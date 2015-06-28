class Field < ActiveRecord::Base
  has_many :games
  belongs_to :tournament

  validates_uniqueness_of :name, scope: :tournament

  def serializable_hash(options={})
    options.merge!(methods: :errors)
    super(options)
  end
end
