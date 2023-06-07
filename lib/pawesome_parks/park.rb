
class PawesomeParks::Park
    attr_reader :name, :off_leash_description, :off_leash_time, :street_address, :suburb, :postcode

    @@all = []

    def initialize name="Information unavailable", off_leash_description="Information unavailable", off_leash_time="Information unavailable", street_address="Information unavailable", suburb="Information unavailable", postcode="Information unavailable"
        @name=name
        @off_leash_description = off_leash_description
        @off_leash_time = off_leash_time
        @street_address = street_address
        @suburb = suburb
        @postcode = postcode
        @@all << self
    end

    def self.all
        @@all
    end

    def self.find_by_suburb suburb
        self.all.select { |park| park.suburb.downcase == suburb }
    end

    def self.find_by_postcode postcode
        self.all.select { |park| park.postcode == postcode }
    end

    def self.find_by_name name
        self.all.find { |park| park.name.downcase == name }
    end

    def self.unrestricted_off_leash_hours 
        self.all.select { |park| park.off_leash_time == "At all times"}
    end

    def self.suburbs
        suburbs = self.all.map { |park| park.suburb.downcase }
        suburbs.uniq
    end

    def self.postcodes
        postcodes = self.all.map { |park| park.postcode }
        postcodes.uniq
    end

    def self.park_names
        park_names = self.all.map { |park| park.name }
    end

end
