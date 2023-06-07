
class PawesomeParks::API
    def get_parks
            # request to postman mock server to mimic error
            # uri = URI.parse("https://2c64e826-c4ff-400d-b87c-edb154f6e8f6.mock.pstmn.io/mockdogparks")

            uri = URI.parse("https://services1.arcgis.com/cNVyNtjGVZybOQWZ/arcgis/rest/services/Dog_off_leash_parks/FeatureServer/0/query?outFields=*&where=1%3D1&f=geojson")
            response = Net::HTTP.get_response(uri)
            if response.code == "200"
                response.body
            else
                "error"
            end
    end


    def make_parks
        parks = JSON.parse(self.get_parks)
        parks["features"].each do |park|
            name = park["properties"]["ParkName"]
            off_leash_description = park["properties"]["OffLeashDescription"]
            off_leash_time = park["properties"]["OffLeashTime"]
            street_address = park["properties"]["Street"]
            suburb = park["properties"]["Suburb"]
            postcode = park["properties"]["Postcode"]
            PawesomeParks::Park.new name, off_leash_description, off_leash_time, street_address, suburb, postcode
        end
    end


end

