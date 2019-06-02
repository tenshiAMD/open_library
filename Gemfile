RUBY_VERSION = ENV['RUBY_VERSION'] || '2.6.3'


source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby RUBY_VERSION

if ENV.key?('RAILS_VERSION')
  gem 'rails', "~> #{ENV['RAILS_VERSION']}"
else
  gem 'rails', git: 'https://github.com/rails/rails', branch: :master
end

gem 'concurrent-ruby', '~> 1.1.5'

## Database
gem 'mysql2'
gem 'pg', '~> 0.21'
gem 'sqlite3', '~> 1.4'

# # Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false
gem 'listen'

# gem 'rails_admin', git: 'https://github.com/sferik/rails_admin', branch: :master
gem 'activeadmin', git: 'https://github.com/activeadmin/activeadmin', branch: :master
gem 'devise'
gem 'puma', '~> 3.11'
gem 'webpacker', '~> 4.0'

gem 'sass-rails'
gem "coffee-rails", '~> 4.0'
gem "uglifier"

eval(File.read(File.dirname(__FILE__) + "/common_dependencies.rb"))

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
