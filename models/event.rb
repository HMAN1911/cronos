class Event < ActiveRecord::Base
  belongs_to :user
end

# apparently the right way to do single line class definition...
# Event = Class.new(ActiveRecord::Base)