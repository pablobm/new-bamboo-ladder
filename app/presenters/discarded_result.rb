class DiscardedResult

  def initialize(result)
    @result = result
  end

  def self.find(id)
    new(Result.find(id))
  end

  def destroy
    Result.transaction do
      @result.destroy
      EloRating.instance.undo(@result)
    end
  end

end
