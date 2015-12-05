require 'sinatra'
require 'json'
require 'yconfig'
require 'fileutils'
require 'trello'
require 'rufus-scheduler'
require_relative 'local_repository'
require_relative 'trello_user_factory'
require_relative 'trello_repository'
require_relative 'summary_controller'

configure do
  pwd = File.dirname(File.expand_path(__FILE__))
  config_dir = File.join pwd, '..', 'config'
  config = YConfig.new(config_dir).parse('config.yml').freeze
  member = TrelloUserFactory.new.generate config, Trello
  lrepo = LocalRepository.new config, FileUtils
  trepo = TrelloRepository.new member, config
  set :config, config
  set :sum_controller, SummaryController.new(lrepo, trepo, config)
  set :scheduler, Rufus::Scheduler.new
end

settings.scheduler.cron settings.config['daily_cfd_schedule'] do
  settings.sum_controller.persist_summary
end

get '/metrics' do
  @graphdef = settings.sum_controller.graph_definition.to_json
  erb :metrics
end

get '/new_details' do
  settings.sum_controller.graph_definition.to_json
end
