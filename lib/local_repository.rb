require 'json'
require 'fileutils'

class LocalRepository
  def initialize config, file_utils
    self.config = config
    self.file_utils = file_utils
    self.columns_file = File.join config['datadir'], 'columns.json'
    self.summary_file = File.join config['datadir'], 'summary.jsonl'
    file_utils.mkdir_p config['datadir'] unless File.exist? config['datadir']
  end

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

  attr_accessor :config, :file_utils, :columns_file, :summary_file
end
