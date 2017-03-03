require 'rgl/adjacency'
require 'rgl/dijkstra'
require 'rgl/dot'

module Citymapper
  class StationsRepository
    def initialize(data)
      @data = data
    end

    def find_id_by_name(name)
      @data.find { |s| s["commonName"].include?(name) }["id"]
    end

    def find_name_by_id(id)
      @data.find { |s| s["id"] == id }["commonName"]
    end
  end

  class RglNetwork
    def self.from_data(routes_data, stations_data)
      stations_repository = StationsRepository.new(stations_data)

      rgl_graph = RGL::DirectedAdjacencyGraph.new
      routes_data.each do |line_routes_data|
        line_routes_data["orderedLineRoutes"].each do |route|
          graph_edges = route["naptanIds"].each_cons(2).to_a
          rgl_graph.add_edges(*graph_edges)
        end
      end
      rgl_graph = rgl_graph.to_undirected

      new(rgl_graph, stations_repository)
    end

    def initialize(rgl_graph, stations_repository)
      @rgl_graph = rgl_graph
      @stations_repository = stations_repository
    end

    def write_to_jpg
      @rgl_graph.write_to_graphic_file('jpg')
    end

    def find_path(from, to)
      from_id = @stations_repository.find_id_by_name(from)
      to_id = @stations_repository.find_id_by_name(to)

      path = @rgl_graph.dijkstra_shortest_path(Hash.new(1), from_id, to_id)

      path.map { |id| @stations_repository.find_name_by_id(id) }
    end
  end
end
