require 'spec_helper'
require 'summary_controller'

describe SummaryController do
  let(:local_repo) { gimme(LocalRepository) }
  let(:trello_repo) { gimme(TrelloRepository) }
  let(:summarizer) { gimme(CardSummarizer) }
  let(:config) { CONFIG.freeze }
  let(:cards) { 'cards' }
  let(:summary) { 'summary' }
  let(:columns) { 'columns' }
  let(:controller) { SummaryController.new local_repo, trello_repo, config }

  before(:each) {
    give(trello_repo).columns { columns }
    give(trello_repo).cards { cards }
    give(CardSummarizer).new { summarizer }
    give(summarizer).summerize(cards) { summary }
  }

  it 'will save the contents of the columns' do
    controller.persist_summary
    verify(local_repo).save_columns columns
  end

  it 'will save the summary of the cards' do
    controller.persist_summary
    verify(local_repo).save_summary summary
  end

  context ', when website requests the graph definition,' do
    let(:summary_1) { { 'date_time' => '2015-12-04T01:00:00.000-06:00', column_1_id => 1, column_2_id => 10, column_3_id => 4 } }
    let(:expected_summary) {
      expected = summary_1.clone
      expected['date_time'] = Date.parse(summary_1['date_time']).strftime '%Y-%m-%d'
      expected.freeze
    }
    let(:column_1_name) { 'some_name' }
    let(:column_2_name) { 'Word' }
    let(:column_3_name) { 'to your ...' }
    let(:column_1_id) { 'col_1' }
    let(:column_2_id) { 'col_2' }
    let(:column_3_id) { 'col_3' }
    let(:column_1) { { 'id' => column_1_id, 'name' => column_1_name, 'pos' => 0 } }
    let(:column_2) { { 'id' => column_2_id, 'name' => column_2_name, 'pos' => 1 } }
    let(:column_3) { { 'id' => column_3_id, 'name' => column_3_name, 'pos' => 2 } }
    let(:columns) { [column_1, column_2, column_3] }

    before(:each) {
      give(local_repo).summaries { [summary_1] }
      give(local_repo).columns { columns }
    }

    it 'will fill in the data for the graph definition' do
      expected = config['graphdef'].clone
      expected['data'] = [expected_summary]
      expected['ykeys'] = [column_1_id, column_2_id, column_3_id]
      expected['labels'] = [column_1_name, column_2_name, column_3_name]

      expect(controller.graph_definition).to eq expected
    end

    context ', when there is an excluded column,' do
      let(:column_1_name) { config['exclude_columns'][0] }
      let(:expected_summary) {
        expected = summary_1.clone
        expected['date_time'] = Date.parse(summary_1['date_time']).strftime '%Y-%m-%d'
        expected.delete(column_1_id)
        expected.freeze
      }

      it 'will fill in the data for the graph definition' do
        expected = config['graphdef'].clone
        expected['data'] = [expected_summary]
        expected['ykeys'] = [column_2_id, column_3_id]
        expected['labels'] = [column_2_name, column_3_name]

        expect(controller.graph_definition).to eq expected
      end
    end
  end
end
