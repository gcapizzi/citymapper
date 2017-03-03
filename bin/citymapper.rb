require 'json'

require_relative '../lib/citymapper/rgl_network'
require_relative '../lib/citymapper/stations_repository'

routes_data = JSON.parse(File.read('data/northern_routes.json'))
stations_data = JSON.parse(File.read('data/northern_stations.json'))

network = RglNetwork.from_data(routes_data, stations_data)

path = network.find_path("Old Street", "Camden Town")

path.each do |station|
  puts station
end
