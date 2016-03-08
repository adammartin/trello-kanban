require 'board_factory'
require 'fileutils'
require 'trello'
require 'spec_helper'

describe BoardFactory do
  let(:config1) { CONFIG['boards'][0] }
  let(:config2) { CONFIG['boards'][1] }
  let(:file_utils) { gimme(FileUtils) }
  let(:local_repo1) { gimme(LocalRepository) }
  let(:trello_repo1) { gimme(TrelloRepository) }
  let(:controller1) { gimme(SummaryController) }
  let(:local_repo2) { gimme(LocalRepository) }
  let(:trello_repo2) { gimme(TrelloRepository) }
  let(:controller2) { gimme(SummaryController) }
  let(:calculator1) { gimme(KanbanMetricsCalculator) }
  let(:calculator2) { gimme(KanbanMetricsCalculator) }
  let(:member) { gimme(Member) }

  let(:factory) { BoardFactory.new }

  before(:each) {
    give(LocalRepository).new(CONFIG['datadir'], config1, file_utils) { local_repo1 }
    give(LocalRepository).new(CONFIG['datadir'], config2, file_utils) { local_repo2 }
    give(TrelloRepository).new(member, config1) { trello_repo1 }
    give(TrelloRepository).new(member, config2) { trello_repo2 }
    give(SummaryController).new(local_repo1, trello_repo1, config1) { controller1 }
    give(SummaryController).new(local_repo2, trello_repo2, config2) { controller2 }
    give(KanbanMetricsCalculator).new(config1, local_repo1) { calculator1 }
    give(KanbanMetricsCalculator).new(config2, local_repo2) { calculator2 }
  }

  def values_from_array hash_key, array_of_hashes
    array_of_hashes.map do |hash| hash[hash_key] end
  end

  it 'will construct an array of board definitions' do
    expect(factory.construct(member, CONFIG, file_utils).length).to be 2
  end

  it 'will construct definitions with board_config' do
    boards = factory.construct(member, CONFIG, file_utils)
    expect(values_from_array('config', boards)).to contain_exactly config1, config2
  end

  it 'will construct definitions with local repositories' do
    boards = factory.construct(member, CONFIG, file_utils)
    expect(values_from_array('local_repo', boards)).to contain_exactly local_repo1, local_repo2
  end

  it 'will construct definitions with trello repositories' do
    boards = factory.construct(member, CONFIG, file_utils)
    expect(values_from_array('trello_repo', boards)).to contain_exactly trello_repo1, trello_repo2
  end

  it 'will construct definitions with controllers' do
    boards = factory.construct(member, CONFIG, file_utils)
    expect(values_from_array('controller', boards)).to contain_exactly controller1, controller2
  end

  it 'will construct definitions with calculators' do
    boards = factory.construct(member, CONFIG, file_utils)
    expect(values_from_array('calculator', boards)).to contain_exactly calculator1, calculator2
  end
end
