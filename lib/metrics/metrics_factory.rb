require_relative 'kanban_metrics_calculator'
require_relative 'scrum_metrics_calculator'

class MetricsFactory
  def create board_config, local_repository
    return KanbanMetricsCalculator.new board_config, local_repository if board_config['type'] == 'kanban'
    return ScrumMetricsCalculator.new board_config, local_repository if board_config['type'] == 'scrum'
  end
end
