require 'date'
require_relative 'local_repository'
require_relative 'trello_repository'
require_relative 'summarizer/card_summarizer_factory'

class SummaryController
  def initialize local_repo, trello_repo, board_config
    self.local_repo = local_repo
    self.trello_repo = trello_repo
    self.board_config = board_config
    self.summarizer = CardSummarizerFactory.new.create board_config
  end

  def persist_summary
    cards = trello_repo.cards
    local_repo.save_columns trello_repo.columns
    local_repo.save_cards cards
    local_repo.save_summary summarizer.summarize cards
  end

  def graph_definition
    cols = columns
    graph_def = board_config['graphdef'].clone
    graph_def['data'] = summaries cols[:deleted]
    graph_def['ykeys'] = cols[:columns].map do |column| column['id'] end.reverse
    graph_def['labels'] = cols[:columns].map do |column| column['name'] end.reverse
    graph_def
  end

  private

  attr_accessor :local_repo, :trello_repo, :summarizer, :board_config

  def deleted_columns columns
    columns.select do |column|
      board_config['exclude_columns'].include? column['name']
    end
  end

  def summaries deleted
    data = local_repo.summaries
    result = data.map do |record|
      deleted.each do |column|
        record.delete column['id']
      end
      record['date_time'] = Date.parse(record['date_time']).strftime '%Y-%m-%d'
      record
    end
    result
  end

  def columns
    columns = local_repo.columns
    deleted = deleted_columns columns
    { :columns => columns - deleted, :deleted => deleted }
  end
end
