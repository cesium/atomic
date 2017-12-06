source 'https://rubygems.org'

gem 'rails', '4.2.3'

gem 'sass-rails', '~> 5.0'
gem 'slim-rails'
gem 'jquery-rails'
gem 'google-analytics-rails', '1.1.0'

gem 'puma'
gem 'uglifier', '>= 1.3.0'
gem 'retina_tag'

# landing page gems
gem 'bootstrap-sass'
gem 'font-awesome-sass'
gem 'animate-rails'
gem 'wow-rails'
gem 'owlcarousel-rails'

# atomic gems
gem 'pg'
gem "paperclip", "~> 4.3"
gem 'will_paginate', '~> 3.0.6'
gem 'will_paginate-bootstrap'
gem 'redcarpet'

gem "dotenv"
gem "dotenv-rails"

# omniauth gems
gem 'omniauth-github'
gem 'omniauth-google-oauth2'
gem 'cancancan'

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
  gem "rubocop", require: false
  gem "scss_lint", require: false

  # capistrano
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano3-puma'
  gem 'capistrano-rails', '~> 1.1.1'
  gem 'capistrano-rbenv', github: "capistrano/rbenv"
  gem 'capistrano-rails-console', require: false
end

group :test do
  gem "database_cleaner"
  gem "rails-controller-testing"
  gem "shoulda-matchers"
end
