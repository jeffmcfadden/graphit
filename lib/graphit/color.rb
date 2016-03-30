module Graphit
  class Color
    
    # 0 - 255
    attr_accessor :red
    attr_accessor :green
    attr_accessor :blue
    
    def initialize( red, green, blue )
      self.red   = red
      self.green = green
      self.blue  = blue
    end
    
    def to_hex_array
      [blue,green,red]
    end
    
    def self.light_light_gray_color
      Graphit::Color.new( 225, 225, 225 )
    end
    
    def self.light_gray_color
      Graphit::Color.new( 204, 204, 204 )
    end
    
    def self.medium_gray_color
      Graphit::Color.new( 170, 170, 170 )
    end
    
    def self.white_color
      Graphit::Color.new( 255, 255, 255 )
    end
    
    def self.black_color
      Graphit::Color.new( 0, 0, 0 )
    end
    
    def self.red_color
      Graphit::Color.new( 255, 0, 0 )
    end
    
    def self.blue_color
      Graphit::Color.new( 0, 0, 255 )
    end
    
    def self.green_color
      Graphit::Color.new( 0, 255, 0 )
    end
    
  end
end