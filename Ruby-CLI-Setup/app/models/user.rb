class User < ActiveRecord::Base
# add associatons!
    has_many :replies
    has_many :forum_threads 

    def show_all_replies
        Reply.all.select { |reply|
            (reply.user_id == self.id)
    }
    end

    def delete_reply(id)
        post = Reply.find_by(id: id, user_id: self.id)
        if post == nil 
          puts "No post found" 
        else
          post.destroy
          puts "Post deleted."
        end
    end

    # Removes user id from their replies/posts and deletes user
    def delete_account
        Reply.where(user_id: self.id).each { |reply|
            reply.update(user_id: nil)
        }
        ForumThread.where(user_id: self.id).each { |thread|
            thread.update(user_id: nil)
        }
        self.destroy

        puts "Account and all posts associations removed."
    end

    def create_reply(id)
        Reply.create(body: "...", user_id: self.id, forum_thread_id: id)
    end

    # Edit reply method
    def edit_reply 
    end

    def self.return_username(id)
        if id == nil
            "Deleted User"
        else 
            self.find(id).username
        end
    end

    def self.create_user(username, password)
        User.create(username: username, password: password)
    end

end
