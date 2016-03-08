require_relative 'local_repository'
require_relative 'trello_repository'
require_relative 'summary_controller'
require_relative 'kanban_metrics_calculator'

class BoardFactory
  def construct member, config, file_utils
    data_dir = config['datadir']
    config['boards'].map do |board|
      board_config = { 'config' => board, 'local_repo' => LocalRepository.new(data_dir, board, file_utils), 'trello_repo' => TrelloRepository.new(member, board) }
      board_config['controller'] = SummaryController.new(board_config['local_repo'], board_config['trello_repo'], board)
      board_config['calculator'] = KanbanMetricsCalculator.new(board, board_config['local_repo'])
      board_config
    end
  end
end
