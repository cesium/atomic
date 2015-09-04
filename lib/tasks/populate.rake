namespace :db do
  desc 'Erase database and fill a new one with fake data'
  task :populate => [:environment, :drop, :migrate, :seed] do
    require 'faker'

    MEMBER_COUNT = 50
    BUDDY_COUNT = 20

    print "Populating Members with #{MEMBER_COUNT} entries... "

    MEMBER_COUNT.times do
      Member.create!(FactoryGirl.attributes_for :member)
    end

    puts "Done!"

    print "Populating Buddies with #{BUDDY_COUNT} entries... "

    BUDDY_COUNT.times do
      Buddy.create!(FactoryGirl.attributes_for :buddy)
    end

    puts "Done!"
  end
end
