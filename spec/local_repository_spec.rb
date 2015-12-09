require 'spec_helper'
require 'local_repository'

describe LocalRepository do
  let(:file_utils) { gimme(FileUtils) }
  let(:dir_exists?) { true }
  let(:columns_exists?) { true }
  let(:column_1) { { 'id' => 'foo', 'name' => 'bar', 'pos' => 1 } }
  let(:column_2) { { 'id' => 'ping', 'name' => 'pong', 'pos' => 2 } }
  let(:columns) { [column_1, column_2] }
  let(:column_write_mode) { 'w+' }
  let(:column_read_mode) { 'r' }
  let(:append_write_mode) { 'a:UTF-8' }
  let(:jsonl_read_mode) { 'r:UTF-8' }
  let(:jsonl_overwrite_mode) { 'w+:UTF-8' }
  let(:board_dir) { File.join CONFIG['datadir'], CONFIG['board']['name'] }
  let(:column_file_name) { File.join board_dir, 'columns.json' }
  let(:column_file) { gimme(File) }
  let(:repo) { LocalRepository.new CONFIG, file_utils }

  def give_file_open_behavior file, file_name, file_mode
    give(File).open(file_name, file_mode) { |block|
      block.call file unless block.nil?
      file
    }
  end

  before(:each) {
    give(File).exist?(board_dir) { dir_exists? }
    give(File).exist?(column_file_name) { columns_exists? }
    give_file_open_behavior column_file, column_file_name, column_read_mode
    give_file_open_behavior column_file, column_file_name, column_write_mode
    give(column_file).read { columns.to_json }
  }

  it 'will not automatically create a storage directory when it already exists' do
    repo
    verify_never(file_utils).mkdir_p anything
  end

  it 'will create a columns file' do
    repo.save_columns columns
    verify(column_file).write columns.to_json
  end

  it 'will read contents of a columns file' do
    expect(repo.columns).to eq columns
  end

  context 'column file does not exist' do
    let(:columns_exists?) { false }

    it 'will not try to read the columns' do
      repo.columns
      verify_never(column_file).read
    end

    it 'will return an empty array' do
      expect(repo.columns).to eq []
    end
  end

  context 'data storage directory does not exist' do
    let(:dir_exists?) { false }

    it 'will create the storage directory' do
      repo
      verify(file_utils).mkdir_p board_dir
    end
  end

  context ', when daily summarized data is exists,' do
    let(:time_unit_card_summary_1) { { 'time' => 'now', 'column_id' => 1 } }
    let(:time_unit_card_summary_2) { { 'time' => 'now', 'column_id' => 2 } }
    let(:summary_file_name) { File.join board_dir, 'summary.jsonl' }
    let(:summary_file) { gimme(File) }
    let(:summary_file_contents) { "#{time_unit_card_summary_1.to_json}\n#{time_unit_card_summary_2.to_json}\n" }

    before(:each) {
      give_file_open_behavior summary_file, summary_file_name, append_write_mode
      give_file_open_behavior summary_file, summary_file_name, jsonl_read_mode
      give(summary_file).read { summary_file_contents }
    }

    it 'will append the contents in proper jsonl format to the end of the summary file' do
      repo.save_summary time_unit_card_summary_1
      verify(summary_file).write time_unit_card_summary_1.to_json + "\n"
    end

    it 'will read contents of the summary file' do
      expect(repo.summaries).to eq [time_unit_card_summary_1, time_unit_card_summary_2]
    end
  end

  context ', when card data exists,' do
    context 'cards directory does not exist' do
      let(:card_file_name) { File.join board_dir, 'cards.jsonl' }
      let(:card_file) { gimme(File) }
      let(:card_1_id) { 'card_uno' }
      let(:card_2_id) { 'card_dos' }
      let(:card_1) { { 'id' => card_1_id, 'other' => 'stuff' } }
      let(:card_2) { { 'id' => card_2_id, 'other' => 'stuff' } }
      let(:card_file_contents) { "#{card_1.to_json}\n#{card_2.to_json}\n" }

      before(:each) {
        give_file_open_behavior card_file, card_file_name, jsonl_overwrite_mode
        give_file_open_behavior card_file, card_file_name, jsonl_read_mode
        give(card_file).read { card_file_contents }
      }

      it 'will write the cards to the jsonl content file' do
        repo.save_cards [card_1, card_2]
        verify(card_file, 1).write card_1.to_json + "\n"
        verify(card_file, 1).write card_2.to_json + "\n"
      end

      it 'will read contents of the card file' do
        expect(repo.cards).to eq [card_1, card_2]
      end
    end
  end
end
