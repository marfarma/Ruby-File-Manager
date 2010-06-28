require 'rubygems'
require 'sinatra'

enable :sessions

# Set utf-8 for outgoing
before do
  headers "Content-Type" => "text/html; charset=utf-8"
end

# Helpers
helpers do
  def site_title
    'FileManager'
  end
end

# Select File
get '/select/*' do |dir|
  path = '/' + dir.to_s.strip
  parent = File.dirname(path)

  session[:dir] = path
  session[:file] = path

  redirect parent
end


# List Directory
get '/*?' do |dir|

  # Build Path from URL parameters
  path = '/' + dir.to_s.strip
  path << '/' unless path[-1, 1] == '/'

  # Path to the Parent of the directory  
  @parent = File.dirname(path)

  # Generate breadcrumb style links from the path
  @path = [] # Array to store the links
  paths = path.split('/') # Array of path steps to iterate through
  paths.each_with_index do |item, index|
    if index == paths.length-1
      @path[index] = item
    else
      @path[index] = "<a href=\"#{paths[0..index].join('/')}\">#{item}</a>" unless item.to_s.length == 0
    end
  end
 @path = path == '/' ? '[root]' : '<a href="/">[root]</a>' + @path.join('/')

  # Get a list of files and directories in the current directory
  @directories = ""
  @files = ""
  Dir.foreach("#{settings.file_root + path}") do |x|
    full_path = settings.file_root + path + '/' + x
    if x != '.' && x != '..'
      if( (x[0, 1] == '.' && settings.show_hidden == true) || x[0, 1] != '.' ) # if it starts with a dot (.) don't show it unless show_hidden = true
        if File.directory?(full_path)
          @directories << "\n<li class=\"dir\"><a href=\"#{path + x}\">#{x}</a></li>"
        else
          ext = File.extname(full_path)
          @files << "\n<li class=\"#{ ext[1..ext.length-1]}\"><a href=\"/select#{path + x}\">#{x}</a></li>"
        end
      end
    end
  end

  erb :index
end
