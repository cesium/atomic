namespace :db do
  desc "Create an admin testing account"
  task :admin, %i[] => :environment do
    m = Member.create
    m.update(id: 1, member_id: 1, admin: true)
    u = User.first
    u.update(member_id: 1)
  end
end
