class ResultFlash

  def initialize(opts)
    result_id = opts.fetch(:result_id)
    @result = Result.find(result_id)
  end

  def template
    'flashes/result'
  end

  def locals
    {result: @result}
  end

end
