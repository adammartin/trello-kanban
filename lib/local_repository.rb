require 'json'
require 'fileutils'

class LocalRepository
  def initialize config, file_utils
    self.config = config
    self.file_utils = file_utils
    self.columns_file = File.join config['datadir'], 'columns.json'
    file_utils.mkdir_p config['datadir'] unless File.exist? config['datadir']
  end

  def save_columns columns
    File.open(columns_file, 'w+') do |file| file.write columns.to_json end
  end

  def columns
    return JSON.parse File.open(columns_file, 'r').read if File.exist? columns_file
    []
  end

  private

  attr_accessor :config, :file_utils, :columns_file
end
