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
