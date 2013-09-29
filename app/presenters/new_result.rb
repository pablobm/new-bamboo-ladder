class NewResult
  extend Forwardable

  def_delegators :@result, :id

  attr_reader :result

  def initialize(result)
    @result = result
  end

  def self.create!(attrs)
    new(Result.create!(attrs.merge(previous_state: State.dump))).tap do |e|
      EloRating.instance.resolve(e.result)
    end
  end

end
