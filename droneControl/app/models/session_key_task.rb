class SessionKeyTask < ActiveRecord::Base
    attr_accessible :drone

    belongs_to :drone
end
