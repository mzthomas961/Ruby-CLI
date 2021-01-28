class User < ActiveRecord::Base

    has_many :replies
    has_many :forum_threads 

    #Return user's total post count by user ID
    def return_post_count
            "Post count: #{replies.count}"
    end

    #Delete a post, verify against user id - currently unused
    # def delete_reply(id)
    #     post = Reply.find_by(id: id, user_id: self.id)
    #     if post == nil 
    #       puts "No post found" 
    #     else
    #       post.destroy
    #       puts "Post deleted."
    #     end
    # end

    # Removes user id from their replies/posts and deletes user
    def delete_account

        self.replies.each { |reply|
            reply.update(user_id: nil)
        }

        forum_threads.each { |thread|
            thread.update(user_id: nil)
        }

        self.destroy

        puts "Account and all posts associations removed."
        
    end

    #Create a new reply with a user id and body supplied in Interface methods
    def create_reply(id, body)

        Reply.create(body: body, user_id: self.id, forum_thread_id: id)

    end

    #Returns username based on user id
    def self.return_username(id)

        if id == nil
            "Deleted User"
        else 
            self.find(id).username
        end

    end

    #Updates a user's password, password supplied from Interface methods
    def change_password(password)

        self.update(password: password)
        puts "Password changed!"

    end

end
