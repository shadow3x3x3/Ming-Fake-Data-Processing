require_relative '../../lib/dijkstra'

require_relative '../util/read_util'
require_relative '../util/output_util'
require_relative 'edge'

# Normal Graph class
class Graph
  include ReadUtil, Dijkstra

  attr_reader :edges, :nodes

  def initialize(params = {})
    raw_nodes = params[:raw_nodes]
    raw_edges = params[:raw_edges]
    @nodes = []
    @edges = []
    initialize_nodes(raw_nodes) unless raw_nodes.nil?
    initialize_edges(raw_edges) unless raw_edges.nil?

    @neighbors_hash = set_neighbors
    @edges_hash     = set_edges_hash
  end

  def add_node(node)
    @nodes << node unless @nodes.include?(node)
  end

  def add_edge(edge)
    new_edge = edge.class == Edge ? edge : Edge.new(edge)
    @edges << new_edge unless duplicate_edge?(new_edge)
  end

  def find_neighbors_at(node)
    @neighbors_hash[node]
  end

  def combination_shorest_path
    find_combination_by_nodes(@nodes).each do |c|
      dist_path = path_2_edges(shorest_path_query(c[0], c[1], 0))
      hops_path = path_2_edges(shorest_path_query(c[0], c[1], 1))
      puts "#{c[0]} -> #{c[1]}: dist: #{edges_to_start_codes(dist_path)}"
      puts "#{c[0]} -> #{c[1]}: hops: #{edges_to_start_codes(hops_path)}"
    end
    output_csv(@edges)
  end

  def output_csv(edges)
    dists = edges.map { |e| e.dist }
    OutputUtil.output_setting_csv("./output/fake_dist.csv", dists)
    hops = edges.map { |e| e.hops }
    OutputUtil.output_setting_csv("./output/fake_hops.csv", hops)
  end

  private

  def duplicate_edge?(new_edge)
    @edges.each do |edge|
      return true if same_edge?(edge, new_edge)
    end
    false
  end

  def same_edge?(edge1, edge2)
    edge1_src_id = edge1.src
    edge1_dst_id = edge1.dst
    edge2_src_id = edge2.src
    edge2_dst_id = edge2.dst
    return true if edge1_src_id == edge2_src_id && edge1_dst_id == edge2_dst_id
    return true if edge1_dst_id == edge2_src_id && edge1_src_id == edge2_dst_id
    false
  end

  def set_neighbors
    n_hash = {}
    nodes.each do |node|
      n_hash[node] = find_neighbors(node)
    end
    n_hash
  end

  def find_neighbors(node)
    neighbors = []
    @edges.each do |edge|
      neighbors << check_neighbor(node, edge)
    end
    neighbors.compact!
  end

  def check_neighbor(node, edge)
    case node
    when edge.src
      return edge.dst
    when edge.dst
      return edge.src
    end
  end

  def set_edges_hash
    e_hash = {}
    @edges.each do |edge|
      e_hash[[edge.src, edge.dst]] = edge
      e_hash[[edge.dst, edge.src]] = edge
    end
    e_hash
  end

  def path_2_edges(path)
    edges = []
    partition(path).each do |nodes|
      edges << find_edge_id(nodes[0], nodes[1])
    end
    edges
  end

  def find_edge(src, dst)
    @edges.each do |edge|
      return edge if edge.src == src && edge.dst == dst
      return edge if edge.src == dst && edge.dst == src
    end
    raise ArgumentError, "not connect between #{src} and #{dst}"
  end

  def find_edge_id(src, dst)
    @edges.each do |edge|
      return edge.id if edge.src == src && edge.dst == dst
      return edge.id if edge.src == dst && edge.dst == src
    end
    raise ArgumentError, "not connect between #{src} and #{dst}"
  end

  def partition(path)
    result = []
    0.upto(path.size - 2) do |i|
      result << [path[i], path[i + 1]]
    end
    result
  end

  def find_combination_by_nodes(nodes)
    combs = nodes.repeated_combination(2).to_a.delete_if { |c| c[0] == c[1] }

    temp_array = [] # for delete duplicates edges
    result = []
    combs.each do |c|
      next if temp_array.include?([c[1], c[0]])
      next if temp_array.include?([c[0], c[1]])
      temp_array << [c[0], c[1]]
      result << c
    end
    result
  end

  def edges_to_start_codes(edges)
    coding = "00000000000000000000"
    edges.each { |chr| coding[chr.to_i] = "1" }
    coding.split("")
  end
end
