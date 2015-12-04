require 'spec_helper'
require 'summary_controller'

describe SummaryController do
  let(:local_repo) { gimme(LocalRepository) }
  let(:trello_repo) { gimme(TrelloRepository) }
  let(:summarizer) { gimme(CardSummarizer) }
  let(:cards) { "cards" }
  let(:summary) { "summary" }
  let(:columns) { "columns" }
  let(:controller) { SummaryController.new local_repo, trello_repo }

  before(:each) {
    give(trello_repo).columns { columns }
    give(trello_repo).cards { cards }
    give(CardSummarizer).new { summarizer }
    give(summarizer).summerize(cards) { summary }
  }

  it "will save the contents of the columns" do
    controller.persist_summary
    verify(local_repo).save_columns columns
  end

  it "will save the summary of the cards" do
    controller.persist_summary
    verify(local_repo).save_summary summary
  end
end
