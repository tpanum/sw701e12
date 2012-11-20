class Session < ActiveRecord::Base
  attr_accessible :session_key, :user, :drone
  belongs_to :drone
  belongs_to :user
end
