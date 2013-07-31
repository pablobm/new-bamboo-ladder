class MessagePresenter
  def self.new_result_summary(result)
    I18n.t('result.summary',
           winner: result.winner.name,
           loser: result.loser.name)
  end
end
