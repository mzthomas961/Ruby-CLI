class Reply < ActiveRecord::Base
 
    belongs_to :forum_thread 
    belongs_to :user

    #Create array of reply info for table output
    def reply_array
      ["\n#{User.return_username(self.user_id)} \n#{User.return_post_count(user_id)}", "#{self.created_at}\n\n#{self.body}"]
    end

end
