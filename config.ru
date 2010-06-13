require 'file_manager.rb'

set :environment, :development
set :run, false
set :path, 'Andy'

run Sinatra::Application
