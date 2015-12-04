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
  let(:board_dir) { File.join CONFIG['datadir'], CONFIG['board'] }
  let(:column_file_name) { File.join board_dir, 'columns.json' }
  let(:column_file) { gimme(File) }
  let(:repo) { LocalRepository.new CONFIG, file_utils }

  before(:each) {
    give(File).exist?(board_dir) { dir_exists? }
    give(File).exist?(column_file_name) { columns_exists? }
    give(File).open(column_file_name, column_read_mode) { column_file }
    give(File).open(column_file_name, column_write_mode) { |block|
      block.call column_file unless block.nil?
      column_file
    }
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
    let(:summary_write_mode) { 'a:UTF-8' }
    let(:summary_read_mode) { 'r:UTF-8' }
    let(:summary_file_name) { File.join board_dir, 'summary.jsonl' }
    let(:summary_file) { gimme(File) }

    before(:each) {
      give(File).open(summary_file_name, summary_write_mode) { |block|
        block.call summary_file unless block.nil?
        summary_file
      }
      give(File).open(summary_file_name, summary_read_mode) { summary_file }
      give(summary_file).read {
        "#{time_unit_card_summary_1.to_json}\n#{time_unit_card_summary_2.to_json}\n"
      }
    }

    it 'will append the contents in proper jsonl format to the end of the summary file' do
      repo.save_summary time_unit_card_summary_1
      verify(summary_file).write time_unit_card_summary_1.to_json + "\n"
    end

    it 'will read contents of the summary file' do
      expect(repo.summaries).to eq [time_unit_card_summary_1, time_unit_card_summary_2]
    end
  end
end
