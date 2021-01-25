class User < ActiveRecord::Base
# add associatons!
    has_many :replies
    has_many :forum_threads 
end
