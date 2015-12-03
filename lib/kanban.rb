require 'sinatra'
require 'json'
require 'yconfig'

configure do
  pwd = File.dirname(File.expand_path(__FILE__))
  config_dir = File.join pwd, "..", "config"
  set :config, YConfig.new(config_dir).parse("config.yml")
end

def time
  Array.new(7) do | day | { "date" => ((Time.now + day * 86500).strftime "%Y-%m-%d") } end
end

def values key, vals
  vals.map { | value | { key => value } }
end

def merge_array_o_hashes a1, a2
  a1.zip(a2).map do | h1, h2 | h1.merge h2 end
end

def combine_all time, done, in_progress, ready, backlog
  a = merge_array_o_hashes time, done
  a = merge_array_o_hashes a, in_progress
  a = merge_array_o_hashes a, ready
  merge_array_o_hashes a, backlog
end

get '/hi' do
  time_vals = time
  categories = ["Done", "In Progress", "Ready", "Backlog"]
  done = values categories[0], [0, 5, 9, 16, 22, 25, 29]
  in_progress = values categories[1], [1, 1, 2, 1, 2, 1, 1]
  ready = values categories[2], [6, 7, 6, 8, 7, 7, 6]
  backlog = values categories[3], [20, 22, 25, 29, 31, 35, 38]
  graphdef = {
    "element" => 'uv-div',
    "data" => combine_all(time_vals, done, in_progress, ready, backlog),
    "xkey" => "date",
    "ykeys" => categories,
    "labels" => categories,
    "hideHover" => 'auto',
    "resize" => true,
    "lineColors" => ['green', 'yellow', 'grey', 'blue']
  }
  @graphdef = graphdef.to_json
  erb :metrics
end
