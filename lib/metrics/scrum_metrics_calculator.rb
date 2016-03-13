require_relative 'scrum_data_transformer'

class ScrumMetricsCalculator
  def initialize board_config, local_repository
    self.board_config = board_config
    self.local_repo = local_repository
    self.transformer = ScrumDataTransformer.new
  end

  def metrics
    result = transformer.transform local_repo.summaries, local_repo.columns, board_config['iteration']
    { 'average_velocity' => average_velocity(result), 'last_week' => result.last }
  end

  private
  attr_accessor :board_config, :local_repo, :transformer

  def average_velocity result
    result.inject(0,:+).to_f/(result.length.to_f/board_config['iteration']['length'])
  end
end
