require_relative 'local_repository'
require_relative 'trello_repository'
require_relative 'card_summarizer'

class SummaryController
  def initialize local_repo, trello_repo, config
    self.local_repo = local_repo
    self.trello_repo = trello_repo
    self.config = config
    self.summarizer = CardSummarizer.new
  end

  def persist_summary
    local_repo.save_columns trello_repo.columns
    local_repo.save_summary summarizer.summerize trello_repo.cards
  end

  def graph_definition
    columns = local_repo.columns
    graph_def = config['graphdef'].clone
    graph_def['data'] = local_repo.summaries
    graph_def['ykeys'] = columns.map do |column| column['id'] end
    graph_def['labels'] = columns.map do |column| column['name'] end
    graph_def
  end

  private

  attr_accessor :local_repo, :trello_repo, :summarizer, :config
end
