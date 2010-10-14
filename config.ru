require 'rubygems'
require 'bundler'
Bundler.setup

require 'sinatra'
require './zipandgo'
run Sinatra::Application
