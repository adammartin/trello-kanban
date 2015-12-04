require 'spec_helper'
require 'card_summarizer'

describe CardSummarizer do
  let(:time) { 'time_summerized' }
  let(:column_1_id) { '1' }
  let(:column_2_id) { '2' }
  let(:card_1) { { :id => 'a', :column_id => column_1_id } }
  let(:card_2) { { :id => 'b', :column_id => column_2_id } }
  let(:card_3) { { :id => 'c', :column_id => column_1_id } }
  let(:cards) { [card_1, card_2, card_3] }
  let(:summerizer) { CardSummarizer.new }

  before(:each) {
    give(Time).now { time }
  }

  it 'will properly map and summerize the cards' do
    expected = { 'date_time' => time, column_1_id => 2, column_2_id => 1 }
    expect(summerizer.summerize cards).to eq expected
  end
end
