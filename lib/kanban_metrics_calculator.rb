require_relative 'time_calculator'
require_relative 'time_accumulator'
require_relative 'card_array_filter'
require_relative 'card_activity_transformer'
require_relative 'local_repository'

class KanbanMetricsCalculator
  def initialize board_config, local_repository
    cycle_time_config = board_config['cycle_time']
    self.lead_time_config = board_config['lead_time']
    self.local_repo = local_repository
    self.lead_time_accumulator = TimeAccumulator.new TimeCalculator.new lead_time_config['start'], lead_time_config['end']
    self.cycle_time_accumulator = TimeAccumulator.new TimeCalculator.new cycle_time_config['start'], cycle_time_config['end']
  end

  def metrics
    { 'lead_time' => lead_time_accumulator.average(cards), 'cycle_time' => cycle_time_accumulator.average(cards) }
  end

  private

  attr_accessor :lead_time_config, :local_repo, :lead_time_accumulator, :cycle_time_accumulator

  def cards
    filter = CardArrayFilter.new lead_time_config['end']
    transformer = CardActivityTransformer.new
    filter.filter(local_repo.cards).map do |card| transformer.transform card end
  end
end
