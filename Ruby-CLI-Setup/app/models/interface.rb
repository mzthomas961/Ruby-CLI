class Interface
    attr_reader :prompt
    attr_accessor :user_id
    
    #Initialize interface - allow for Esc capablity to return to Welcome, load forum logo
    def initialize

        @prompt = TTY::Prompt.new
        escape_to_welcome
        LoadAssets.load_logo

    end

    #Start app - open login/create acct menu, or login as Guest
    def welcome
        self.user_id = nil
        prompt.select("\nWelcome to the Forum! Choose an action - \n (Press Esc at any time to return to this menu!") do |menu|
            menu.choice "Login", -> {login}
            menu.choice "Create Account", -> {account_creation}
            menu.choice "Browse as a Guest", -> {
                user_id = nil
                show_threads
            }
            menu.choice "Exit", -> {exit}
        end
        
    end

    #Create account - check if username is unused and not blank, check password > 5 characters, return to Welcome
    def account_creation

        username = prompt.ask("Choose a username!\n")
        while User.find_by(username: username) || username == ""
            puts "Taken/blank username - please try another\n"
            username = prompt.ask("Choose a username!\n")
        end

        password = prompt.mask("Choose a password over 5 characters.")
        while password.length < 5
            puts "Password too short - must be over 5 characters long"
            password = prompt.mask("Choose a password over 5 characters.")
        end

        User.create(username: username, password: password)
        puts "You may now log in! Returning to login page.\n"

        welcome

    end

    #Login to the forum, set user_id to allow creation of threads/replies to threads
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

    #Show all threads in forum in selectable menu and option for settings menu
    def show_threads

        all_threads = ForumThread.all

        chosen_thread = prompt.select("Choose a thread!") do |menu|
            all_threads.each{ |ft| menu.choice "#{ft.title}", -> {
                ft.print_forum_thread
                thread_menu(ft.id)
                }
            }

            #Ensure guests cannot change settings or create threads
            if user_id
                menu.choice "Create new thread\n".bold, ->  { thread_starter }
                menu.choice "Settings".bold, -> {user_settings}
            end

        end

    end

    #Create a new thread based on logged in user, then open new thread
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

    #Show menu inside of thread - reply or return to thread list, navigate to other threads
    def thread_menu (thread_id)

        prompt.select ("What would you like to do?") do |menu|
            #Ensure guests cannot reply to threads
            if user_id
                menu.choice "Reply to thread", -> {
                    prompt.select("How would you like to reply?") do |menu|
                        menu.choice "Random cat fact!", -> {
                            User.find(user_id).create_reply(thread_id, APICalls.catfact)
                        }
                        menu.choice "Random advice!", -> {
                            User.find(user_id).create_reply(thread_id, APICalls.advice)
                        }
                        menu.choice "Write a reply", -> {
                            body = prompt.ask ("Enter your reply\n")
                            User.find(user_id).create_reply(thread_id,body)
                        }
                    end
                    ForumThread.find(thread_id).print_forum_thread
                    thread_menu(thread_id)
                }
            end

            #Ensure there is a previous thread to go to
            if thread_id > 1
                menu.choice "Previous Thread", -> {
                    ForumThread.find(thread_id-1).print_forum_thread
                    thread_menu(thread_id-1)
                }
            end

            #Ensure there is a next thread to go to
            if thread_id < ForumThread.last.id
                menu.choice "Next Thread", -> {
                    ForumThread.find(thread_id+1).print_forum_thread
                    thread_menu(thread_id+1)
                }
            end

            menu.choice "Go back to threads", -> {show_threads}
        end

    end

    #Show user settings menu - delete account, update password
    def user_settings

        prompt.select ("Choose an option") do |menu|
            menu.choice "Delete account", -> {
                answer = prompt.yes? ("Are you sure?")
                if answer 
                    User.find(user_id).delete_account 
                    user_id = nil 
                    welcome
                else
                    puts "Glad you're staying" 
                    user_settings
                end
            }

            menu.choice "Change Password\n", -> {

                password = prompt.mask("Enter your current password:")
                while User.find(user_id).password != password
                    puts "Invalid password - please try again."
                    password = prompt.mask("Enter your current password:")
                end

                password = prompt.mask("Choose a new password over 5 characters.")
                while password.length < 5
                    puts "Password too short - must be over 5 characters long"
                    password = prompt.mask("Choose a new password over 5 characters.")
                end

                User.find(user_id).change_password(password)
                user_settings
            }

            menu.choice "Return to threads", -> {show_threads}
        end 

    end

    private 

    #Allow for pressing Esc to return to Welcome menu
    def escape_to_welcome

        prompt.on(:keypress) do |event|
            if event.key.name == :escape
                welcome
            end  
        end

    end

end