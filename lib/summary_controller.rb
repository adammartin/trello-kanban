require_relative 'local_repository'
require_relative 'trello_repository'
require_relative 'card_summarizer'

class SummaryController
  def initialize local_repo, trello_repo
    self.local_repo = local_repo
    self.trello_repo = trello_repo
    self.summarizer = CardSummarizer.new
  end

  def persist_summary
    local_repo.save_columns trello_repo.columns
    local_repo.save_summary summarizer.summerize trello_repo.cards
  end

  private
  attr_accessor :local_repo, :trello_repo, :summarizer
end
