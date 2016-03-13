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
  let(:columns) { "columns" }
  let(:summaries) { "summaries" }
  let(:transformed_results) { [1, 2, 3, 4] }

  let(:calculator) { ScrumMetricsCalculator.new board_config, local_repo }

  before(:each) {
    give(local_repo).summaries { summaries }
    give(local_repo).columns { columns }
    give(ScrumDataTransformer).new { transformer }
    give(transformer).transform(summaries, columns, board_config['iteration']) { transformed_results }
  }

  it "can average one week iterations" do
    expect(calculator.metrics['average_velocity']).to eq 2.5
  end

  it "shows the the last weeks velocity" do
    expect(calculator.metrics['last_week']).to eq 4
  end

  context "when length of iterations are more then a week" do
    let(:length_in_weeks) { 2 }


    it "can average one week iterations" do
      expect(calculator.metrics['average_velocity']).to eq 5
    end
  end
end
