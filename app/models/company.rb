class Company < ActiveRecord::Base
  validates_uniqueness_of(:owner_email_id)
end
