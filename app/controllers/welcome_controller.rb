require 'json'

class WelcomeController < ApplicationController
  def index
  end

  def news
  end

  def about
  end

  def team
    @team = JSON.parse(File.read('public/team.json'))
  end

  # in future, replace this method by a controller
  def log
  end

  def contact
  end
end
