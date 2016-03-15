require 'metrics/metrics_factory'
require 'spec_helper'

describe MetricsFactory do
  let(:config1) { CONFIG['boards'][0] }
  let(:config2) { CONFIG['boards'][1] }
  let(:local_repo) { gimme(LocalRepository) }
  let(:calculator1) { gimme(KanbanMetricsCalculator) }
  let(:calculator2) { gimme(ScrumMetricsCalculator) }

  let(:factory) { MetricsFactory.new }

  before(:each) {
    give(KanbanMetricsCalculator).new(config1, local_repo) { calculator1 }
    give(ScrumMetricsCalculator).new(config2, local_repo) { calculator2 }
  }

  it 'will create a kanban metrics calculator' do
    expect(factory.create config1, local_repo).to eq calculator1
  end

  it 'will create a scrum metrics calculator' do
    expect(factory.create config2, local_repo).to eq calculator2
  end

  it 'will return nil for an invalid request' do
    bad_config = config1.clone
    bad_config['type'] = 'junk'
    expect(factory.create bad_config, local_repo).to eq nil
  end
end
