require 'spec_helper'
require 'metrics/kanban_metrics_calculator'

describe KanbanMetricsCalculator do
  let(:board_config) { CONFIG['boards'][0] }
  let(:local_repo) { gimme(LocalRepository) }
  let(:filter) { gimme(CardArrayFilter) }
  let(:transformer) { gimme(CardActivityTransformer) }
  let(:lead_time_calc) { gimme(TimeCalculator) }
  let(:cycle_time_calc) { gimme(TimeCalculator) }
  let(:lead_time_accumulator) { gimme(TimeAccumulator) }
  let(:cycle_time_accumulator) { gimme(TimeAccumulator) }
  let(:card_1) { gimme }
  let(:card_2) { gimme }
  let(:card_activity_record1) { gimme }
  let(:card_activity_record2) { gimme }
  let(:unfiltered_cards) { gimme }
  let(:filtered_cards) { [card_1, card_2] }
  let(:cards) { [card_activity_record1, card_activity_record2] }
  let(:lead_time) { gimme }
  let(:cycle_time) { gimme }
  let(:calculator) { KanbanMetricsCalculator.new board_config, local_repo }

  before(:each) {
    give(CardArrayFilter).new(END_COLUMNS) { filter }
    give(CardActivityTransformer).new { transformer }
    give(TimeCalculator).new(LEAD_START_COLUMNS, END_COLUMNS) { lead_time_calc }
    give(TimeCalculator).new(CYCLE_START_COLUMNS, END_COLUMNS) { cycle_time_calc }
    give(TimeAccumulator).new(lead_time_calc) { lead_time_accumulator }
    give(TimeAccumulator).new(cycle_time_calc) { cycle_time_accumulator }
    give(local_repo).cards { unfiltered_cards }
    give(filter).filter(unfiltered_cards) { filtered_cards }
    give(transformer).transform(card_1) { card_activity_record1 }
    give(transformer).transform(card_2) { card_activity_record2 }
    give(lead_time_accumulator).average(cards) { lead_time }
    give(cycle_time_accumulator).average(cards) { cycle_time }
  }

  it 'will calculate the average lead time of the cards in the repository' do
    expect(calculator.metrics['lead_time']).to eq lead_time
  end

  it 'will calculate the average cycle time of the cards in the repository' do
    expect(calculator.metrics['cycle_time']).to eq cycle_time
  end
end
