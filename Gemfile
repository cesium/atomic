ruby '2.7.5'

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.3"

gem "rails", "7.0.0"

gem "dotenv"
gem "dotenv-rails", require: "dotenv/rails-now"

# Temporary fix
gem "mimemagic", github: "mimemagicrb/mimemagic", ref: "01f92d86d15d85cfd0f20dabd025dcbd36a8a60f"

gem "google-analytics-rails", "1.1.0"
gem "jquery-rails"
gem "jquery-ui-rails"
gem "listen"
gem "sass-rails", "~> 5.0"
gem "slim-rails"

gem "puma"
gem "retina_tag"
gem "uglifier", ">= 1.3.0"

gem 'bootsnap', '~> 1.9', '>= 1.9.3'
gem 'webpacker'

# landing page gems
gem "animate-rails"
gem "bootstrap-sass"
gem "font-awesome-sass"
gem "owlcarousel-rails"
gem "wow-rails"

# atomic gems
gem "paperclip", "~> 5.2"
gem "pg"
gem "redcarpet"
gem 'will_paginate'
gem "will_paginate-bootstrap"

# omniauth gems
gem "cancancan"
gem "omniauth-github"
gem "omniauth-google-oauth2"

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "web-console"
end

group :development, :test do
  gem "awesome_print"
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "factory_bot_rails"
  gem "faker"
  gem "pry-remote"
  gem "rspec-rails", "~> 3.5.1"
  gem 'rubocop', '~> 1.4'
  gem 'rubocop-rspec', '~> 1.30', '>= 1.30.1'
  gem "scss_lint", require: false

  # capistrano
  gem "capistrano", "~> 3.4.0"
  gem "capistrano-bundler", "~> 1.6"
  gem "capistrano-rails", "~> 1.1.1"
  gem "capistrano-rails-console", require: false
  gem "capistrano-rbenv", github: "capistrano/rbenv"
  gem "capistrano3-puma"
end

group :test do
  gem "database_cleaner"
  gem "rails-controller-testing"
  gem "shoulda-matchers"
end
