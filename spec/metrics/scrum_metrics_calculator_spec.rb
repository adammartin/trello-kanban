require 'local_repository'
require 'metrics/scrum_metrics_calculator'
require 'spec_helper'

describe ScrumMetricsCalculator do
  let(:length_in_weeks) { 1 }
  let(:board_config) {
    config = CONFIG['boards'][1].clone
    config['iteration']['length'] = length_in_weeks
    config
  }
  let(:transformer) { gimme(ScrumDataTransformer) }
  let(:local_repo) { gimme(LocalRepository) }
  let(:columns) { 'columns' }
  let(:summaries) { 'summaries' }
  let(:transformed_results) { [1, 2, 3, 4] }

  let(:calculator) { ScrumMetricsCalculator.new board_config, local_repo }

  before(:each) {
    give(local_repo).summaries { summaries }
    give(local_repo).columns { columns }
    give(ScrumDataTransformer).new { transformer }
    give(transformer).transform(summaries, columns, board_config['iteration']) { transformed_results }
  }

  it 'can average velocity for one week iterations' do
    expect(calculator.metrics['average_velocity']).to eq 2.5
  end

  it 'shows the the last weeks velocity' do
    expect(calculator.metrics['last_iteration']).to eq 4
  end

  context 'when length of iterations are more then a week' do
    let(:length_in_weeks) { 2 }

    it 'can average velocity for more than one week iterations' do
      expect(calculator.metrics['average_velocity']).to eq 5
    end

    it 'gives the the previous velocity for the past 2 weeks' do
      expect(calculator.metrics['last_iteration']).to eq 7
    end
  end

  context 'when in the first iteration' do
    let(:transformed_results) { [] }

    it 'returns an average velocity of 0' do
      expect(calculator.metrics['average_velocity']).to eq 0
    end

    it 'returns a last iteration velocity of 0' do
      expect(calculator.metrics['last_iteration']).to eq 0
    end

    context 'when the iteration is 2 weeks long' do
      let(:transformed_results) { [3] }
      let(:length_in_weeks) { 2 }

      it 'returns an average velocity of 0', :focus => true do
        expect(calculator.metrics['average_velocity']).to eq 0
      end

      it 'returns a last iteration velocity of 0' do
        expect(calculator.metrics['last_iteration']).to eq 0
      end
    end
  end
end
