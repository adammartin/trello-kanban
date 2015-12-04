require 'json'
require 'fileutils'

class LocalRepository
  # rubocop:disable Metrics/AbcSize
  def initialize config, file_utils
    self.config = config
    self.file_utils = file_utils
    self.board_dir = File.join config['datadir'], config['board']
    self.columns_file = File.join board_dir, 'columns.json'
    self.summary_file = File.join board_dir, 'summary.jsonl'
    file_utils.mkdir_p board_dir unless File.exist? board_dir
  end
  # rubocop:enable

  def save_columns columns
    File.open(columns_file, 'w+') do |file| file.write columns.to_json end
  end

  def columns
    return JSON.parse File.open(columns_file, 'r').read if File.exist? columns_file
    []
  end

  def save_summary summary
    File.open(summary_file, 'a:UTF-8') do |file| file.write summary.to_json + "\n" end
  end

  def summaries
    File.open(summary_file, 'r:UTF-8').read.split("\n").map do |line|
      JSON.parse line
    end
  end

  private

  attr_accessor :config, :file_utils, :columns_file, :summary_file, :board_dir
end
