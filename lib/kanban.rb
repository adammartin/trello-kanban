require 'sinatra'
require 'json'
require 'yconfig'

configure do
  pwd = File.dirname(File.expand_path(__FILE__))
  config_dir = File.join pwd, "..", "config"
  set :config, YConfig.new(config_dir).parse("config.yml")
end

def add_array(a,b)
  a.zip(b).map do | pair | pair.reduce(&:+) end
end

def dataset config_key, label, data, previous_dataset=nil
  data = add_array data, previous_dataset[:data] if previous_dataset
  info = { :data => data, :label => label }
  settings.config[config_key].merge info
end

get '/hi' do
  done = dataset "done", "Done", [0, 5, 9, 16, 22, 25, 29]
  in_progress = dataset "in_progress", "In Progress", [1, 1, 2, 1, 2, 1, 1], done
  ready = dataset "ready", "Ready", [6, 7, 6, 8, 7, 7, 6], in_progress
  backlog = dataset "backlog", "Backlog", [20, 22, 25, 29, 31, 35, 38], backlog
  @labels = Array.new(7) { | day | (Time.now + day * 86500).strftime "%Y-%m-%d" }
  @datasets = [backlog, ready, in_progress, done].to_json
  erb :metrics
end
