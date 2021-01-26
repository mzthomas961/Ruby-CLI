class Interface
    attr_reader :prompt

    def initialize
        @prompt = TTY::Prompt.new
    end

    def welcome
        prompt.select("Welcome to the Forum! Choose an action -") do |menu|
            menu.choice "Login", -> {login}
            menu.choice "Create Account", -> {account_creation}
            #menu.choice "Guest Access"
        end
    end

    def account_creation
        username = prompt.ask("Choose a username!")
        while User.find_by(username: username) || username == ""
            puts "Invalid username - please try another"
            username = prompt.ask("Choose a username!")
        end
        password = prompt.mask("Choose a password over 5 characters")
        while password.length < 5
            puts "Password too short - must be over 5 characters long"
            password = prompt.mask("Choose a password over 5 characters")
        end
        User.create_user(username: username, password: password)
        puts "You may now log in! Returning to login page."
        welcome
    end

    def login
        username = prompt.ask("Enter your username:")
        while !User.find_by(username: username)
            puts "Username not found - please try again."
            username = prompt.ask("Enter your username:")
        end
        password = prompt.mask("Enter your password")
        while User.find_by(username: username).password != password
            puts "Invalid password - please try again."
            password = prompt.mask("Enter your password")
        end
        puts "Successfully logged in! Welcome!"
        show_threads
    end

    def show_threads
        all_threads = ForumThread.all
        chosen_thread = prompt.select("Choose a thread") do |menu|
            all_threads.each{ |ft| menu.choice "#{ft.title}", -> {puts "thread id #{ft.id}"}}
        end
    end

end