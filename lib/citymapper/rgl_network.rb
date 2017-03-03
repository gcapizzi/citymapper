require 'rgl/adjacency'
require 'rgl/dijkstra'
require 'rgl/dot'

class RglNetwork
  def self.from_data(routes_data, stations_data)
    stations_repository = StationsRepository.new(stations_data)

    routes = routes_data["orderedLineRoutes"].map { |route| route["naptanIds"] }
    graph_edges = routes.map { |r| r.each_cons(2).to_a }.flatten
    rgl_graph = RGL::DirectedAdjacencyGraph[*graph_edges]

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
