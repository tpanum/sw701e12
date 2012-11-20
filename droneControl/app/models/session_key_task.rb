class SessionKeyTask < ActiveRecord::Base
    attr_accessible :drone_id

    belongs_to :drone
end
