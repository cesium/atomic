namespace :db do
  desc "Create an admin testing account"
  task :admin, %i[] => :environment do
    User.first.update(activity_admin: true)
  end
end
