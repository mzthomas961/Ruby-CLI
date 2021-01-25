class Reply < ActiveRecord::Base
  # add associatons!
    belongs_to :forum_thread 
    belongs_to :user
end
