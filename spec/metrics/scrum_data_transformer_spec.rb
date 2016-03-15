require 'metrics/scrum_data_transformer'
require 'spec_helper'

describe ScrumDataTransformer do
  let(:first_friday) { Time.parse '2016-01-01T01:00:00.000-06:00' }
  let(:days_as_seconds) { 86400 }
  let(:board_config) { CONFIG['boards'][1] }
  let(:done_column_key) { 'blarg_blarg_blarg' }
  let(:other_column_key) { 'bark_bark' }
  let(:done_column_name) { board_config['iteration']['end'] }
  let(:other_column_name) { 'useless' }
  let(:count_1) { 3 }
  let(:count_2) { 10 }
  let(:count_3) { 17 }
  let(:count_4) { 24 }
  let(:end_days) {
    [
      { 'date_time' => '2016-01-04 01:00:00 -0600', done_column_key => count_1 },
      { 'date_time' => '2016-01-11 01:00:00 -0600', done_column_key => count_2 },
      { 'date_time' => '2016-01-18 01:00:00 -0600', done_column_key => count_3 },
      { 'date_time' => '2016-01-25 01:00:00 -0600', done_column_key => count_4 }
    ]
  }
  let(:columns) {
    [{ 'id' => done_column_key, 'name' => done_column_name },
     { 'id' => other_column_key, 'name' => other_column_name }]
  }

  let(:transformer) { ScrumDataTransformer.new }

  def row_data known_columns, datetime, done_column_key, index
    if known_columns.empty?
      { 'date_time' => datetime.to_s, done_column_key => index }
    else
      known_columns[0]
    end
  end

  def summaries done_counts
    done_counts.map.with_index do |_count, index|
      datetime = first_friday + (index * days_as_seconds)
      known_columns = end_days.select do |record| Time.parse(record['date_time']) == datetime end
      row_data known_columns, datetime, done_column_key, index
    end
  end

  it 'returns an ordered list of velocities by week' do
    our_summaries = summaries 1..31
    expect(transformer.transform our_summaries, columns, board_config['iteration']).to eq [(count_2 - count_1), (count_3 - count_2), (count_4 - count_3)]
  end

  context "when many iterations don't have anything done" do
    let(:end_days) {
      [
        { 'date_time' => '2016-01-04 01:00:00 -0600' },
        { 'date_time' => '2016-01-11 01:00:00 -0600' },
        { 'date_time' => '2016-01-18 01:00:00 -0600' },
        { 'date_time' => '2016-01-25 01:00:00 -0600', done_column_key => count_4 }
      ]
    }
    let(:count_4) { 8 }

    it 'returns an ordered list of velocities by week' do
      our_summaries = summaries 1..31
      expect(transformer.transform our_summaries, columns, board_config['iteration']).to eq [0, 0, (count_4 - 0)]
    end
  end
end
