require 'daemons'

pwd = File.dirname(File.expand_path(__FILE__))
file = File.join pwd, 'lib', 'kanban.rb'

Daemons.run_proc('kanban') do
  Dir.chdir pwd
  exec "bundle exec ruby #{file} -o 0.0.0.0 -p 4567"
end
