class Session < ActiveRecord::Base
  attr_accessible :session_key, :user, :drone
  belongs_to :drone
  belongs_to :user

  before_save :check_no_other_sessions_for_drone_exists

  def check_no_other_sessions_for_drone_exists
      #Check if the drone already has a session
  end
end
