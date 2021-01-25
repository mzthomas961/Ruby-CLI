class ForumThread < ActiveRecord::Base
  # add associatons!
    belongs_to :user 
    has_many :replies 
end
