class Reply < ActiveRecord::Base
  # add associatons!
    belongs_to :forum_thread 
    belongs_to :user

    def reply_array
      ["#{User.return_username(self.user_id)} \n #{User.return_post_count(user_id)}", "#{self.created_at}
      #{self.body}"]
    end
end
