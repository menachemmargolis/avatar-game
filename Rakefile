require_relative './config/environment'


require 'sinatra/activerecord/rake'
require 'colorize'

desc "Start our app console"
task :console do
  # enables logging in Pry console whenever ActiveRecord writes SQL for us
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  # open Pry console, similar to binding.pry
  Pry.start
end

desc "Start our app"
task :start do
  menu = Menu.new
  menu.main_menu
end