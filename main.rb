require_relative 'src/structure/graph'

NODES_PATH = "data/fake_nodes.txt"
EDGES_PATH = "data/fake_edges.txt"

NODE_DATA = File.read(NODES_PATH)
EDGE_DATA = File.read(EDGES_PATH)

g = Graph.new(raw_nodes: NODE_DATA, raw_edges: EDGE_DATA)

# puts g.edges.size
# puts g.nodes.size
#
g.combination_shorest_path.each {|edge| p edge} 
