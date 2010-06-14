require 'app.rb'

# Sinatra Settings
set :environment, :development
set :run, false

# App Settings
set :show_hidden, false
set :file_root, '/Users/Andy'

run Sinatra::Application
