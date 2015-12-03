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
  let(:column_file_name) { File.join CONFIG['datadir'], 'columns.json' }
  let(:column_file) { gimme(File) }
  let(:repo) { LocalRepository.new CONFIG, file_utils }

  before(:each) {
    give(File).exist?(CONFIG['datadir']) { dir_exists? }
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
    verify_never(file_utils).mkdir_p CONFIG['datadir']
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
      verify(file_utils).mkdir_p CONFIG['datadir']
    end
  end
end
