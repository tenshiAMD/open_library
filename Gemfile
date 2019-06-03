source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'rails', "~> 6.0.0.rc1"

## Rails Essentials
gem 'bootsnap', '>= 1.4.2', require: false ## Reduces boot times through caching; required in config/boot.rb
gem 'concurrent-ruby', '~> 1.1.5'
gem 'foreman'
gem 'image_processing', '~> 1.2'
gem 'puma', '~> 3.11'
gem 'webpacker', '~> 4.0'

## Databases
gem 'mysql2'
gem 'pg', '~> 0.21'
gem 'sqlite3', '~> 1.4'

gem 'activeadmin', git: 'https://github.com/activeadmin/activeadmin', branch: :master
gem 'devise', git: 'https://github.com/plataformatec/devise', branch: :master

gem 'sidekiq'
gem 'yell'

## Views
gem 'bootstrap', '~> 4.3.1'
gem "coffee-rails", '~> 4.0'
gem 'sass-rails'
gem 'slim-rails'
gem "uglifier"

eval(File.read(File.dirname(__FILE__) + "/common_dependencies.rb"))
