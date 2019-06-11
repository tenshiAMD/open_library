# frozen_string_literal: true

APP_ROOT = ENV.fetch("APP_HOME") { Dir.pwd }

min_threads = ENV.fetch("RAILS_MIN_THREADS") { 5 }.to_i
max_threads = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
workers ENV.fetch("WEB_CONCURRENCY") { 1 }
threads min_threads > max_threads ? max_threads : min_threads, max_threads

rackup DefaultRackup

if ENV["APP_USER"]
  bind "unix:///var/#{ENV['APP_USER']}/run/puma.sock"
  pidfile "/var/#{ENV['APP_USER']}/run/puma.pid"
  state_path "/var/#{ENV['APP_USER']}/run/puma.state"
  activate_control_app "unix:///var/#{ENV['APP_USER']}/run/pumactl.sock"
end

environment ENV.fetch("RAILS_ENV") { "development" }
early_hints(ENV.key?("WEB_EARLY_HINTS"))
preload_app!

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
