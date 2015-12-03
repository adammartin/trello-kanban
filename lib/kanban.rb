require 'sinatra'
require 'json'
require 'yconfig'

configure do
  pwd = File.dirname(File.expand_path(__FILE__))
  config_dir = File.join pwd, "..", "config"
  set :config, YConfig.new(config_dir).parse("config.yml")
end

def time
  Array.new(7) do | day | { "name" => ((Time.now + day * 86500).strftime "%Y-%m-%d") } end
end

def values vals
  vals.map { | value | { "value" => value } }
end

def dataset category, vals
  vals = values vals
  result = vals.zip(time).map do | h1, h2 | h1.merge h2 end
  { category => result }
end

get '/hi' do
  done = dataset "Done", [0, 5, 9, 16, 22, 25, 29]
  in_progress = dataset "In Progress", [1, 1, 2, 1, 2, 1, 1]
  ready = dataset "Ready", [6, 7, 6, 8, 7, 7, 6]
  backlog = dataset "Backlog", [20, 22, 25, 29, 31, 35, 38]
  dataset = { "dataset" => done.merge(in_progress).merge(ready).merge(backlog) }
  graphdef = { "categories" => dataset["dataset"].keys }.merge(dataset)
  @graphdef = graphdef.to_json
  erb :metrics
end
