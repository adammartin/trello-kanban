require 'sinatra'
require 'json'
require 'yconfig'
require 'fileutils'
require 'trello'
require 'rufus-scheduler'
require 'uri'
require_relative 'local_repository'
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
  lrepo = LocalRepository.new config['datadir'], config['boards'][0], FileUtils
  trepo = TrelloRepository.new member, config['boards'][0]
  set :config, config
  set :sum_controller, SummaryController.new(lrepo, trepo, config['boards'][0])
  set :scheduler, Rufus::Scheduler.new
  set :calculator, KanbanMetricsCalculator.new(config['boards'][0], lrepo)
end

settings.scheduler.cron settings.config['daily_cfd_schedule'] do
  settings.sum_controller.persist_summary
end

get '/metrics' do
  @graphdef = settings.sum_controller.graph_definition.to_json
  @lead_time = TimeDataFormatter.new.format_time settings.calculator.lead_time
  @cycle_time = TimeDataFormatter.new.format_time settings.calculator.cycle_time
  erb :metrics
end
