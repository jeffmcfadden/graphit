module Graphit
  class Point
    attr_accessor :x
    attr_accessor :y
    
    def initialize( x, y )
      self.x = x.to_f
      self.y = y.to_f
    end
  end
end