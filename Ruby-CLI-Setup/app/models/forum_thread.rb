class ForumThread < ActiveRecord::Base
  # add associatons!
    belongs_to :user 
    has_many :replies 

    def print_forum_thread
      table = TTY::Table.new ["#{" "*5}",self.title],[[User.return_username(self.user_id), self.body]]
      
      puts table.render(:unicode, resize: true, multiline: true)

      Reply.where(forum_thread_id: self.id).each { |reply|
        puts reply.table_format
      }

      
      # puts self.title
      # puts User.return_username(self.user_id)
      # puts self.body 
      # Reply.where(forum_thread_id: self.id).each { |reply|
      #   puts User.return_username(reply.user_id)
      #   puts reply.body
      # }
    end

    def self.print_all_threads 
      ForumThread.all.each { |ft|
        puts ft.title 
        puts User.return_username(ft.user_id)
      }
    
    end
      
end


