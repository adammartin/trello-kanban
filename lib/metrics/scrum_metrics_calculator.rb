require_relative 'scrum_data_transformer'

class ScrumMetricsCalculator
  def initialize board_config, local_repository
    self.board_config = board_config
    self.local_repo = local_repository
    self.transformer = ScrumDataTransformer.new
  end

  def metrics
    result = transformer.transform local_repo.summaries, local_repo.columns, board_config['iteration']
    { 'average_velocity' => average_velocity(result), 'last_iteration' => last_iteration(result) }
  end

  private

  attr_accessor :board_config, :local_repo, :transformer

  def average_velocity result
    number_of_iterations = (result.length.to_f / board_config['iteration']['length'])
    return 0 if result.empty? || number_of_iterations <= 1
    result.inject(0, :+).to_f / number_of_iterations
  end

  def last_iteration result
    return 0 if (result.length.to_f / board_config['iteration']['length']) <= 1
    result.last(board_config['iteration']['length']).inject(0, :+)
  end
end
