class ForumThread < ActiveRecord::Base
  # add associatons!
    belongs_to :user 
    has_many :replies 

    def print_forum_thread
      table = TTY::Table.new(header: ["#{" "*5}", self.title.bold])

      if user
        userinfo = "\n#{User.return_username(self.user_id)} \n#{self.user.return_post_count}"
      else 
        userinfo = "\nDeleted User"
      end

      table << [userinfo, "#{self.created_at}\n\n#{self.body}"]
    
      replies.each { |reply|
        table << ["#{"─"*20}", "#{"─"*90}"]
        table << reply.reply_array
      }

      puts table.render(:unicode, multiline: true, padding: [1, 0], column_widths: [20, 90])

    end

    def self.print_all_threads 

      ForumThread.all.each { |ft|
        puts ft.title 
        puts User.return_username(ft.user_id)
      }

    end
      
end


