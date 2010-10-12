require 'rubygems'
require 'bundler'
Bundler.setup

require 'sinatra'
require 'sinatra/reloader'
run Sinatra::Application
