require 'spec_helper'
require 'summarizer/card_summarizer_factory'

describe CardSummarizerFactory do
  let(:kanban_board) { CONFIG['boards'][0] }
  let(:scrum_board) { CONFIG['boards'][1] }

  let(:factory) { CardSummarizerFactory.new }

  it "can create a kanban card summarizer" do
    expect(factory.create kanban_board).to be_a KanbanCardSummarizer
  end

  it "can create a scrum card summarizer" do
    expect(factory.create scrum_board).to be_a ScrumCardSummarizer
  end

  it "will return nil when passed an invalid config" do
    invalid_config = kanban_board.clone
    invalid_config['type'] = nil
    expect(factory.create invalid_config).to be nil
  end
end
