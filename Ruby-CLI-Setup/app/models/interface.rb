class Interface
    attr_reader :prompt
    attr_accessor :user_id

    def initialize
        @prompt = TTY::Prompt.new
        escape_to_welcome
        LoadAssets.load_logo
    end

    def welcome
       
        prompt.select("\nWelcome to the Forum! Choose an action -") do |menu|
            menu.choice "Login", -> {login}
            menu.choice "Create Account", -> {account_creation}
            # menu.choice "Guest Access"
        end
        
    end

    def account_creation

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
        
        self.user_id = User.find_by(username: username).id
        puts "Successfully logged in! Welcome #{User.return_username(user_id)}!\n"

        show_threads
    end

    def show_threads
        all_threads = ForumThread.all
        chosen_thread = prompt.select("Choose a thread") do |menu|
            all_threads.each{ |ft| menu.choice "#{ft.title}", -> {ForumThread.find(ft.id).print_forum_thread
                thread_menu(ft.id)}}
            menu.choice "Create new thread", ->  { thread_starter }
            menu.choice "Settings", -> {user_settings}

        end
    end


    def thread_starter
        
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

    def user_settings
        prompt.select ("Choose an option") do |menu|
            menu.choice "Delete account", -> {answer = prompt.yes? ("Are you sure?")
            if answer 
                User.find(user_id).delete_account 
                    user_id = nil 
                    welcome
            else
            puts "Glad you're staying" 
                user_settings
                end
            }
            menu.choice "Return to threads", -> {show_threads}
        end            
    end



    

    private 
    def escape_to_welcome
        prompt.on(:keypress) do |event|
            if event.key.name == :escape
                welcome
            end  
        end
    end


end