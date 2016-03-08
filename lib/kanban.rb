require 'sinatra'
require 'json'
require 'yconfig'
require 'fileutils'
require 'trello'
require 'rufus-scheduler'
require 'uri'
require_relative 'local_repository'
require_relative 'board_factory'
require_relative 'trello_user_factory'
require_relative 'trello_repository'
require_relative 'summary_controller'
require_relative 'kanban_metrics_calculator'
require_relative 'time_data_formatter'

configure do
  pwd = File.dirname(File.expand_path(__FILE__))
  config_dir = File.join pwd, '..', 'config'
  config = YConfig.new(config_dir).parse('config.yml').freeze
  member = TrelloUserFactory.new.generate config, Trello
  set :config, config
  set :boards, BoardFactory.new.construct(member, config, FileUtils)
  set :scheduler, Rufus::Scheduler.new
end

settings.scheduler.cron settings.config['daily_cfd_schedule'] do
  settings.boards.each do |board| board['controller'].persist_summary end
end

get '/metrics' do
  "This address is no longer valid please use /metrics/[trello_board_name]. Where [trello_board_name] is the name of the board you wish to see."
end

get '/metrics/:board' do
  selected = URI.unescape params['board']
  board_config = settings.boards.select do |board| board['config']['name'] == selected end[0]
  @graphdef = board_config['controller'].graph_definition.to_json
  @lead_time = TimeDataFormatter.new.format_time board_config['calculator'].lead_time
  @cycle_time = TimeDataFormatter.new.format_time board_config['calculator'].cycle_time
  erb :metrics
end
