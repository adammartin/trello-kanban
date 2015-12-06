require 'json'
require 'fileutils'

class LocalRepository
  def initialize config, file_utils
    self.config = config
    self.file_utils = file_utils
    self.board_dir = File.join config['datadir'], config['board']
    self.columns_file = File.join board_dir, 'columns.json'
    self.summary_file = File.join board_dir, 'summary.jsonl'
    self.card_file = File.join board_dir, 'cards.jsonl'
    file_utils.mkdir_p board_dir unless File.exist? board_dir
  end

  def save_columns columns
    File.open(columns_file, 'w+') do |file| file.write columns.to_json end
  end

  def columns
    return JSON.parse File.open(columns_file, 'r').read if File.exist? columns_file
    []
  end

  def save_summary summary
    write_jsonl summary_file, APPEND_RTF8, [summary]
  end

  def summaries
    read_jsonl summary_file, READ_RTF8
  end

  def save_cards cards
    write_jsonl card_file, OVERWRITE_RTF8, cards
  end

  def cards
    read_jsonl card_file, READ_RTF8
  end

  private

  attr_accessor :config, :file_utils, :columns_file, :summary_file, :board_dir, :card_file

  READ_RTF8 = 'r:UTF-8'.freeze
  APPEND_RTF8 = 'a:UTF-8'.freeze
  OVERWRITE_RTF8 = 'w+:UTF-8'.freeze

  def read_jsonl file_name, read_mode
    File.open(file_name, read_mode).read.split("\n").map do |line|
      JSON.parse line
    end
  end

  def write_jsonl file_name, write_mode, contents
    File.open(file_name, write_mode) do |file|
      contents.each do |line|
        file.write line.to_json + "\n"
      end
    end
  end
end
