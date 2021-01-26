class Reply < ActiveRecord::Base
  # add associatons!
    belongs_to :forum_thread 
    belongs_to :user

    def table_format
      reply_table = TTY::Table[["     ", self.created_at], ["#{User.return_username(self.user_id)} \nPost Count: #{User.return_post_count(user_id)}", "#{self.body}"]]
      reply_table.render(:unicode, resize: true, multiline: true)
      # puts reply_table.render(:unicode, resize: true, multiline: true)
    end
end
