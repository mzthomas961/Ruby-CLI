class Reply < ActiveRecord::Base
 
    belongs_to :forum_thread 
    belongs_to :user

    #Create array of reply info for table output
    def reply_array

      if user
        userinfo = "\n#{User.return_username(self.user_id)} \n#{self.user.return_post_count}"
      else 
        userinfo = "\nDeleted User"
      end
      
      [userinfo, "#{self.created_at}\n\n#{self.body}"]
    end

end
