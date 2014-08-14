class NewResult
  extend Forwardable

  def_delegators :@result, :id

  attr_reader :result
  attr_accessor :points

  def initialize(result)
    @result = result
  end

  def self.create!(attrs)
    result = Result.create!(attrs.merge(previous_state: State.dump))
    new(result).tap do |e|
      point_difference = EloRating.instance.resolve(e.result)
      e.points = point_difference
    end
  end

end
