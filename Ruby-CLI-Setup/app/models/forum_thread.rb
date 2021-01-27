class ForumThread < ActiveRecord::Base
  # add associatons!
    belongs_to :user 
    has_many :replies 

    def print_forum_thread
      table = TTY::Table.new(header: ["#{" "*5}", self.title.bold])

      table << ["\n#{User.return_username(self.user_id)} \n#{User.return_post_count(user_id)}", "#{self.created_at}\n\n#{self.body}"]
    
      Reply.where(forum_thread_id: self.id).each { |reply|
        table << ["#{"─"*20}", "#{"─"*50}"]
        table << reply.reply_array
      }

      puts table.render(:unicode, multiline: true, padding: [1, 0])

    end

    def self.print_all_threads 

      ForumThread.all.each { |ft|
        puts ft.title 
        puts User.return_username(ft.user_id)
      }

    end
      
end


