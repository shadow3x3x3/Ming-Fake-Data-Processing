# Record Edge
class Edge
  attr_reader :id, :src, :dst, :dist, :hops, :norm_dist_hop

  def initialize(attrs, dim_times_array = nil)
    @id   = attrs.shift.to_s
    @src  = attrs.shift.to_i
    @dst  = attrs.shift.to_i
    @dist = attrs.shift.to_i
    @hops = attrs.shift.to_i

    # @norm_dist_hop = calc_norm_dist_hop(@dist, @hops)
  end

  def attrs
    [@dist, @hops, @norm_dist_hop]
  end

  private

  def calc_norm_dist_hop(dist, hops)
    # TODO not confirm
  end

end
