class SessionKey < ActiveRecord::Base
  attr_accessible :session_key
  belongs_to :drone

  before_save :remove_previous_sessions

  def remove_previous_sessions
    # REMOVE THE SESSIONS WITH OLDER TIMESTAMPS
    # TODO
  end
end
