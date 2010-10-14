%w(sinatra/reloader i18n mongo_mapper uri digest/md5 haml zip fileutils).each { |gem| require gem}
require 'active_support/lazy_load_hooks'

set :haml, {:format => :html5}
#set :views, File.dirname(FILE) + "/views"

enable :run


APP_ROOT = File.expand_path(File.dirname(__FILE__))
FILE_DIR = '/public/files/'

get '/404' do
  status 404
  "Request not found"
end

get '/' do
  haml :index
end

post '/upload' do
  unless params[:file] 
    @error = "No file selected"
    return haml(:index)
  end
  id = rand(10000000).to_s
  "sinatra_root => #{APP_ROOT}"
  FileUtils.mkdir APP_ROOT + FILE_DIR + id
  filenames = Array.new
  params[:f].each do |file| 
    type = file[1][:type]
    head = file[1][:head]
    filename = file[1][:filename]
    name = file[1][:name]
    tempfile = file[1][:tempfile]
    filenames << filename
    save_file(tempfile, filename, id)   
  end
  @zipfile = APP_ROOT + FILE_DIR + "#{id}.zip"
  puts "zipfile => #{@zipfile}"
  create_zip(@zipfile, id)
  # Dir.chdir("#{APP_ROOT}")
  haml :success
end  

def save_file(tempfile, filename, id)
  puts "Saving @ => #{APP_ROOT}/#{FILE_DIR}/#{id}"
  directory = APP_ROOT + FILE_DIR + id
  Dir.chdir(directory)
  path = File.join(directory, filename)
  File.open(path, "wb") do |file|
    file.write tempfile.read
  end
end

def create_zip(zipfile, id)
  Dir.chdir("#{APP_ROOT}/#{FILE_DIR}/#{id}")
  Zip::ZipFile.open(zipfile, Zip::ZipFile::CREATE) do |zf| 
#    Dir.entries.(".").each { |f| zf.add(f, f) }
    Dir.new(".").each do |f|
      unless ['.', '..'].include? f
        zf.add(f,f)    
      end
    end
  end
#  Dir.chdir("#{APP_ROOT}/#{FILE_DIR}")
end

get '/contact' do
  haml :contact
end

post '/contact' do
  puts "params.class => #{params.class}"
  files = params  
  files.each do |k, v|
    puts "#{k} => #{v}"
  end
  "Thank you"
end
Sinatra::Application.run!
