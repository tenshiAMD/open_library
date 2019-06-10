source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.3"

rails_version = ENV["RAILS_VERSION"] || "~> 6.0.0.rc1"
if rails_version == "master" || rails_version =~ /stable$/
  gem "rails", github: "rails/rails", branch: rails_version
else
  gem "rails", rails_version # rubocop:disable Bundler/DuplicatedGem
end

gem "google-cloud-storage", "~> 1.11", require: false

## Rails Essentials
## Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.2", require: false
gem "concurrent-ruby", "~> 1.1.5"
gem "foreman"
gem "image_processing", "~> 1.2"
gem "puma", "~> 3.11"
gem "webpacker", "~> 4.0"

## Databases
gem "mysql2"
gem "pg", "~> 0.21"
gem "sqlite3", "~> 1.4"

gem "activeadmin", git: "https://github.com/activeadmin/activeadmin"
gem "devise", git: "https://github.com/plataformatec/devise"

gem "sidekiq"
gem "yell"

## Search Engine
gem "elasticsearch-model", github: "elastic/elasticsearch-rails", branch: "5.x"
gem "elasticsearch-rails", github: "elastic/elasticsearch-rails", branch: "5.x"

## Views
gem "bootstrap", "~> 4.3.1"
gem "coffee-rails", "~> 4.0"
gem "sass-rails"
gem "slim-rails"
gem "uglifier"

# rubocop:disable Security/Eval
eval(File.read(File.dirname(__FILE__) + "/common_dependencies.rb"))
# rubocop:enable Security/Eval
