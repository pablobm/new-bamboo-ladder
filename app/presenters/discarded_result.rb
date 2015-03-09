class DiscardedResult

  def self.destroy(id)
    Result.transaction do
      result = Result.find(id)
      result.destroy
      EloRating.instance.resolve_from(result)
    end
  end

end
