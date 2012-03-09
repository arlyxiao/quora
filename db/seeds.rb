# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)


ActiveRecord::Base.connection.execute("TRUNCATE TABLE short_messages")

require 'active_support/secure_random'
20.times do |t|
  random_string = ActiveSupport::SecureRandom.hex(16)
  ShortMessage.create(:sender_id => rand(4), :receiver_id => rand(4), :content => random_string)
end

ShortMessage.update_all(:sender_hide => false)
ShortMessage.update_all(:receiver_hide => false)

