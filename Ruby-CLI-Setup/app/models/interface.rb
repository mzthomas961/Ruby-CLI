class Interface
    attr_reader :prompt
    attr_accessor :user_id

    def initialize
        @prompt = TTY::Prompt.new
    end

    def welcome
        prompt.select("\nWelcome to the Forum! Choose an action -") do |menu|
            menu.choice "Login", -> {login}
            menu.choice "Create Account", -> {account_creation}
            # menu.choice "Guest Access"
        end
        
    end

    def account_creation
        escape_to_previous (__method__)

        username = prompt.ask("Choose a username! Or press escape to go back.\n")
        while User.find_by(username: username) || username == ""
            puts "Invalid username - please try another\n"
            username = prompt.ask("Choose a username!\n")
        end
        password = prompt.mask("Choose a password over 5 characters. Or press escape to go back.")
        while password.length < 5
            puts "Password too short - must be over 5 characters long"
            password = prompt.mask("Choose a password over 5 characters")
        end
        User.create(username: username, password: password)
        puts "You may now log in! Returning to login page.\n"
        welcome

    end

    def login
        escape_to_previous (__method__)

        username = prompt.ask("Enter your username:\n")
        while !User.find_by(username: username)
            puts "Username not found - please try again.\n"
            username = prompt.ask("Enter your username:\n")
        end
        password = prompt.mask("Enter your password:")
        while User.find_by(username: username).password != password
            puts "Invalid password - please try again."
            password = prompt.mask("Enter your password:")
        end
        puts "Successfully logged in! Welcome!\n"

        self.user_id = User.find_by(username: username).id
        show_threads
    end

    def show_threads
        all_threads = ForumThread.all
        chosen_thread = prompt.select("Choose a thread") do |menu|
            all_threads.each{ |ft| menu.choice "#{ft.title}", -> {ForumThread.find(ft.id).print_forum_thread
                thread_menu(ft.id)}}
            menu.choice "Create new thread", ->  { thread_starter }

        end
    end


    def thread_starter
        escape_to_previous (__method__)
        title = prompt.ask("What is your thread title?\n")
        while title == ""
            puts "No title entered.\n"
            title = prompt.ask("What is your thread title?\n")
        end
        body = prompt.ask("Enter your thread content here.\n")
        new_thread = ForumThread.create(title: title, body: body, user_id: user_id)
        new_thread.print_forum_thread
    thread_menu(new_thread.id)
    end

def thread_menu (thread_id)
    prompt.select ("What would you like to do") do |menu|
        menu.choice "Reply to thread", -> {
            body = prompt.ask ("Enter your reply\n")
            User.find(user_id).create_reply(thread_id,body)
            ForumThread.find(thread_id).print_forum_thread
            thread_menu(thread_id)}
        menu.choice "Go back to threads", -> {show_threads}
    end
end


    

    private 
    def escape_to_previous (current_method)
        prompt.on(:keypress) do |event|
            if event.key.name == :escape
                puts current_method
                # binding.pry
                if current_method == :account_creation || current_method == :login
                    welcome
                elsif  current_method == :thread_starter 
                    show_threads
                end
            end  
        end
    end

    # def escape_to_threads
    #     prompt.on(:keypress) do |event|
    #         if event.key.name == :escape
    #             puts "Escaping to threads"
    #             show_threads
    #         end  
    #     end
    # end


end