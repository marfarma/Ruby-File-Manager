require 'rubygems'
require 'sinatra'

# Set utf-8 for outgoing
before do
  headers "Content-Type" => "text/html; charset=utf-8"
end

# Helpers
helpers do
  def site_title
    #'FileManager'
  end
end

# Root Path
root = '/Users/Andy'

# Show Hidden Items
SHOW_HIDDEN = false

# List Directory
get '/*?' do |dir|
  # Join the directories with a slash
  path = '/' + params[:splat].join('/')
  path << '/' unless path[-1, 1] == '/'
  full_path = root + path

  # Prev Dir
  prev_path = params[:splat].to_s.split('/')
  prev_path.pop
  prev_path = '/' + prev_path.join('/')
  full_prev_path = root + prev_path

  @list = '<ul>'
  @list << "<li><a href=\"#{prev_path}\">..</a></li>"
  Dir.foreach("#{full_path}") do |x|
    if x != '.' && x != '..'
      if( (x[0, 1] == '.' && SHOW_HIDDEN == true) || x[0, 1] != '.' )
        @list << "\n<li class=\"#{File.directory?(x) ? 'dir' : File.extname(x)[1..File.extname(x).length-1] }\"><a href=\"#{path + x}\">#{path + x}</a></li>"
      end
    end
  end
  @list << '<ul>'

  erb "Path: #{path}<br />Full Path: #{full_path}" << @list
end
