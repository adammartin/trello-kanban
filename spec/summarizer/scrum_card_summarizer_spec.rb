require 'summarizer/scrum_card_summarizer'

describe ScrumCardSummarizer do
  let(:time) { 'time_summerized' }
  let(:delim_start) { '(' }
  let(:delim_stop) { ')' }
  let(:board_config) {
    board_config = CONFIG['boards'][1].clone
    board_config['delimiter']['start'] = delim_start
    board_config['delimiter']['end'] = delim_stop
    board_config
  }
  let(:value1) { 1 }
  let(:value2) { 5 }
  let(:value3) { 3 }
  let(:name1) { "This is the title of a card #{delim_start}#{value1}#{delim_stop}" }
  let(:name2) { "This is the title of another card #{delim_start}#{value2}#{delim_stop}" }
  let(:name3) { "This is the third title of a card #{delim_start}#{value3}#{delim_stop}" }
  let(:column_1_id) { '1' }
  let(:column_2_id) { '2' }
  let(:card_1) { { :id => 'a', :column_id => column_1_id, :name => name1 } }
  let(:card_2) { { :id => 'b', :column_id => column_2_id, :name => name2 } }
  let(:card_3) { { :id => 'c', :column_id => column_1_id, :name => name3 } }
  let(:cards) { [card_1, card_2, card_3] }
  let(:summerizer) { ScrumCardSummarizer.new board_config }

  before(:each) {
    give(Time).now { time }
  }

  it 'will properly map and summerize the cards' do
    expected = { 'date_time' => time, column_1_id => 4, column_2_id => 5 }
    expect(summerizer.summarize cards).to eq expected
  end

  context ', when supplied a different delimiter' do
    let(:delim_start) { '{' }
    let(:delim_stop) { '}' }

    it 'will properly map and summerize the cards' do
      expected = { 'date_time' => time, column_1_id => 4, column_2_id => 5 }
      expect(summerizer.summarize cards).to eq expected
    end
  end

  context ', when given an invalid title that has no delimeter' do
    let(:name1) { "This is the title of a card #{value1}" }

    it 'will properly map and summerize the cards' do
      expected = { 'date_time' => time, column_1_id => 3, column_2_id => 5 }
      expect(summerizer.summarize cards).to eq expected
    end
  end

  context ', when given an invalid title that has no valid value' do
    let(:name2) { "This is the title of a card #{delim_start}foo#{value1}#{delim_stop}" }

    it 'will properly map and summerize the cards' do
      expected = { 'date_time' => time, column_1_id => 4, column_2_id => 0 }
      expect(summerizer.summarize cards).to eq expected
    end
  end

  context ', when given a titles that are all invalid' do
    let(:name1) { "This is the title of a card" }
    let(:name2) { "This is the title of another card" }
    let(:name3) { "This is the third title of a card" }

    it 'will properly map and summerize the cards' do
      expected = { 'date_time' => time, column_1_id => 0, column_2_id => 0 }
      expect(summerizer.summarize cards).to eq expected
    end
  end
end
