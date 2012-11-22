class Session < ActiveRecord::Base
  attr_accessible :session_key, :user, :drone
  belongs_to :drone
  belongs_to :user

  before_save :check_no_other_sessions_for_drone_exists

  def check_no_other_sessions_for_drone_exists
      raise "Session for Drone already exists" unless Session.where(:drone => self.drone).nil?
  end
end
