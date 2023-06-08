
class PawesomeParks::CLI
    def call
    puts "\n\n
    ██████╗  █████╗ ██╗    ██╗███████╗███████╗ ██████╗ ███╗   ███╗███████╗    ██████╗  █████╗ ██████╗ ██╗  ██╗███████╗
    ██╔══██╗██╔══██╗██║    ██║██╔════╝██╔════╝██╔═══██╗████╗ ████║██╔════╝    ██╔══██╗██╔══██╗██╔══██╗██║ ██╔╝██╔════╝
    ██████╔╝███████║██║ █╗ ██║█████╗  ███████╗██║   ██║██╔████╔██║█████╗      ██████╔╝███████║██████╔╝█████╔╝ ███████╗
    ██╔═══╝ ██╔══██║██║███╗██║██╔══╝  ╚════██║██║   ██║██║╚██╔╝██║██╔══╝      ██╔═══╝ ██╔══██║██╔══██╗██╔═██╗ ╚════██║
    ██║     ██║  ██║╚███╔███╔╝███████╗███████║╚██████╔╝██║ ╚═╝ ██║███████╗    ██║     ██║  ██║██║  ██║██║  ██╗███████║
    ╚═╝     ╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝    ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
    \n".green
    puts "\nWelcome to Pawesome Parks!\n\n"
    puts "There are currently 51 dog-friendly parks within the City of Sydney council region in NSW, Australia. With a range of off-leash hours and other restrictions, this app will let you explore the most suitable park to take your furry friend!"
    retrieve_dog_parks
    end

    def retrieve_dog_parks
        num_of_retries = 0
        until num_of_retries == 3 do 
            parks = PawesomeParks::API.new
            if parks.get_parks == "error"
                puts "\nSorry, there has been an error accessing City of Sydney's dog park information. Reattempting for you now... (reattempt #{num_of_retries + 1} / 3)".red
            else
                parks.make_parks
                menu_selection
            end
            num_of_retries += 1
        end
        puts "\nUnfortunately we have been unable to access the information needed for this program to run and it will now be terminated.\n\n".red
        exit
    end

    def menu_selection
        loop do
            choice = display_options
            if choice == "1"
                list_dog_parks
            elsif choice == "2"
                search_for_park
            elsif choice == "3"
                off_leash_hours
            elsif choice.downcase == "/exit"
                exit_app
            elsif choice.downcase == "/help"
                help
            else
                puts "\nSorry, that is an invalid selection, please enter another option:".green
            end
        end
    end

    def display_options
        puts "\nMenu:"
        puts "1 - List all dog parks"
        puts "2 - Search for dog parks by suburb or postcode"
        puts "3 - View parks with unrestricted off-leash hours"
        puts "/help - Provides a list of available commands\n"
        puts "\nPlease select an option from the menu above by entering '1', '2', or '3' below. You can also enter '/exit' to leave the application or '/menu' to return to this menu at any time:".green
        gets.strip.downcase
    end

    def list_dog_parks
        puts "\nAll Dog Parks:\n"
        PawesomeParks::Park.park_names.each { |park| puts park }
        puts "\nEnter one of the above park names to see more details, or enter '/menu' to return to the main menu:".green
        get_park_details_by_name
    end

    def get_park_details_by_name
        loop do 
            choice = gets.strip.downcase
            if PawesomeParks::Park.park_names.find { |name| name.downcase == choice }
                puts ""
                chosen_park_instance = PawesomeParks::Park.find_by_name choice
                print_park chosen_park_instance
                puts "\nPlease enter another park name for more details or enter '/menu' to return to the main menu:".green
            elsif choice == "/exit"
                exit_app
            elsif choice == "/menu"
                menu_selection
            elsif choice == "/help"
                help
            else
                puts "\nInvalid park name. Please enter a park name included in the list above or enter '/menu to return to the main menu".green
            end
        end
    end

    def search_for_park 
        puts "\nPlease enter a suburb name or postcode within the City of Sydney. Enter '/print' to see a list of possible suburbs and postcodes to choose from:".green
        loop do 
            location = gets.strip.downcase
            if location.to_i != 0
                search_by_postcode location
                puts "\nPlease enter another postcode or suburb name for park details, enter '/menu' to return to the main menu:".green
            elsif location == "/print"
                print_locations
            elsif location == "/exit"
                exit_app
            elsif location == "/menu"
                menu_selection
            elsif location == "/help"
                help
            else
                search_by_suburb location
                puts "\nPlease enter another suburb name or postcode for park details, enter '/menu' to return to the main menu:".green
            end
        end
    end

    def search_by_postcode location 
        if PawesomeParks::Park.postcodes.include? location.to_i
            parks = PawesomeParks::Park.find_by_postcode location.to_i
            puts "\nDog parks at postcode #{location} include:\n\n"
            parks.each { |park| print_park park }
        else
            puts "\nUnable to locate a dog park at that postcode. Postcodes with a dog park include:\n".green
            puts PawesomeParks::Park.postcodes.each { |postcode| postcode }
            puts ""
        end
    end

    def search_by_suburb location 
        if PawesomeParks::Park.suburbs.include? location
            parks = PawesomeParks::Park.find_by_suburb location
            puts "\nDog parks in #{location.capitalize} include:\n\n"
            parks.each { |park| print_park park }
        else
            puts "\nUnable to locate a dog park at that suburb name. Suburbs with a dog park include:\n".green
            PawesomeParks::Park.suburbs.each { |suburb| puts suburb.capitalize }
            puts ""
        end
    end
    
    def off_leash_hours 
        puts "\nParks with unrestricted off-leash hours include:\n\n"
        parks = PawesomeParks::Park.unrestricted_off_leash_hours
        parks.each { |park| puts park.name }
        puts "\nEnter one of the above parks name's to see more details or enter '/menu' to return to the main menu:".green
        get_park_details_by_name
    end

    def help
        puts "\nAvailable Commands:"
        puts "/menu - Return to the main menu (use at any time)".yellow
        puts "/help - Brings up this list of available commands (use at any time)".yellow
        puts "/print - Use when prompted to list information".yellow
        puts "/exit - Terminates the program (use at any time)".yellow
        menu_selection
    end

    def print_locations
        puts "\nSuburbs with dog parks include:"
        PawesomeParks::Park.suburbs.each { |suburb| puts suburb.capitalize }
        puts "\nPostcodes with dog parks include:"
        PawesomeParks::Park.postcodes.each { |postcode| puts postcode }
        search_for_park
    end

    def print_park park
        puts "#{park.name}:
        #{park.off_leash_description}
        Address: #{park.street_address}, #{park.suburb}, #{park.postcode}\n\n"
    end

    def exit_app
        puts "\nThank you for using Sydney's Pawesome Parks! Goodbye!\n\n"
        exit
    end


end