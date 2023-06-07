# frozen_string_literal: true

require_relative "lib/pawesome_parks/version"

Gem::Specification.new do |spec|
  spec.name = "pawesome_parks"
  spec.version = PawesomeParks::VERSION
  spec.authors = ["Lauren Giordano"]
  spec.email = ["laurengiordano94@gmail.com"]
  spec.summary = "Provides information about dog parks within the City of Sydney council area in Sydney, Australia."
  spec.description = "Users can use Pawesome Parks to access information about dog-friendly parks within the City of Sydney council region in Sydney, Australia. They can view all parks and then select a park to access detailed park information such as location, off-leash hours, and any other off-leash resitrctions. Users can also search for parks by either postcode or suburb, and can access a list of dog parks that are off-leash friendly 24 hours a day."
  # spec.homepage = "TODO: Put your gem's website or public repo URL here."
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"
  spec.files = ["lib/pawesome_parks.rb", "lib/pawesome_parks/cli.rb", "lib/pawesome_parks/api.rb", "lib/pawesome_parks/park.rb", "config/environment.rb"]
  spec.executables << 'pawesome_parks'


  spec.add_development_dependency "colorize", "~> 0.8.1"
  spec.add_development_dependency "pry", ">= 0"


end
