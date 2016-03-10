require_relative 'kanban_card_summarizer'
require_relative 'scrum_card_summarizer'

class CardSummarizerFactory
  def create board_config
    return KanbanCardSummarizer.new if board_config['type'] == 'kanban'
    return ScrumCardSummarizer.new board_config if board_config['type'] == 'scrum'
  end
end
