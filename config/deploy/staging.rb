require 'dotenv/load'

server ENV['SERVER_ADDR'], user: ENV['SERVER_USER'], roles: %w{web app}, port: ENV['SERVER_PORT']
set :deploy_to, "#{ENV['SERVER_BASE_LOCATION']}/#{fetch(:application)}-staging"
