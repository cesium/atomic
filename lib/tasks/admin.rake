namespace :db do
  desc "Create an admin testing account"
  task :admin, %i[] => :environment do |t, args|
    m = Member.create
    m.update(id: 1, member_id: 1, activity_admin: true)
    u = User.first
    u.update(member_id: 1)
  end
end
