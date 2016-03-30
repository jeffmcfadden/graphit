module Graphit
  class Graph
    
    attr_accessor :bitmap_drawing
    
    attr_accessor :graph_data
    
    attr_accessor :height, :width
    attr_accessor :xmin, :xmax, :xticsmod
    attr_accessor :ymin, :ymax, :yticsmod
    attr_accessor :background_color 
    attr_accessor :verbose
    attr_accessor :debug
    attr_accessor :left_padding, :right_padding, :top_padding, :bottom_padding
    attr_accessor :x_pixels_per_unit, :y_pixels_per_unit
    attr_accessor :data_color
    
    def initialize( options, data )
      
      options.each do |k,v|
        if self.respond_to?("#{k}=".to_sym)
          self.send( "#{k}=".to_sym, v )
        end
      end
      
      self.graph_data = data
      
      recalculate_xmin if xmin.to_s == "auto"
      recalculate_xmax if xmax.to_s == "auto"
      recalculate_ymin if ymin.to_s == "auto"
      recalculate_ymax if ymax.to_s == "auto"
      
      # Ensure floats
      self.xmin = self.xmin.to_f
      self.xmax = self.xmax.to_f
      self.ymin = self.ymin.to_f
      self.ymax = self.ymax.to_f
      
      recalculate_pixels_per_unit      
            
      puts "BGColor: #{options[:background_color]}"
            
      self.bitmap_drawing = BitmapDrawing.new( options[:height], options[:width], options[:background_color] )
    
      draw_horizontal_gridlines
      draw_vertical_gridlines
      draw_graph_outline
      draw_xaxis_labels
    
      draw_graph( data )
    end
    
    def to_s
      s = super
      s += "\n"
      s += "  Height: #{height}, Width: #{width}\n"
      s += "  Xmin: #{xmin}, Xmax: #{xmax}, Xticsmod: #{xticsmod}\n"
      s += "  Ymin: #{ymin}, Ymax: #{ymax}, Yticsmod: #{yticsmod}\n"
      s
    end
    
    def recalculate_xmin
      puts "recalculate_xmin" if self.debug
      
      self.xmin = self.graph_data.min_by{ |p| p.x.to_f }.x
      
      puts "  xmin: #{self.xmin}" if self.debug
      
      self.xmin
    end
    
    def recalculate_xmax
      puts "recalculate_xmax" if self.debug
      
      self.xmax = self.graph_data.max_by{ |p| p.x.to_f }.x
      
      puts "  xmax: #{self.xmax}" if self.debug
      
      self.xmax
    end
    
    def recalculate_ymin
      puts "recalculate_ymin" if self.debug
      
      self.ymin = self.graph_data.min_by{ |p| p.y.to_f }.y
    end
    
    def recalculate_ymax
      puts "recalculate_ymax" if self.debug
      
      self.ymax = self.graph_data.max_by{ |p| p.y.to_f }.y
    end
    
    def graph_width
      width - left_padding - right_padding
    end
    
    def graph_height
      height - bottom_padding - top_padding
    end
    
    def recalculate_pixels_per_unit
      self.x_pixels_per_unit = graph_width / (xmax.to_f - xmin.to_f)
      self.y_pixels_per_unit = graph_height / (ymax.to_f - ymin.to_f)
  
      if xmax - xmin < (86400 * 3.5)
        self.xticsmod = 3600
      elsif xmax - xmin < (86400 * 7.5)
        self.xticsmod = (86400 * 24)
      elsif xmax - xmin < (86400 * 50)
        self.xticsmod = (86400 * 24 * 7)
      elsif xmax - xmin < (86400 * 800)
        self.xticsmod = (86400 * 24 * 30)
      else
        self.xticsmod = 3600
      end
  
      # if options[:debug]
      #   puts "@x_pixels_per_unit: #{@x_pixels_per_unit}"
      #   puts "@y_pixels_per_unit: #{@y_pixels_per_unit}"
      # end
    end
    
    def draw_graph( data )
      self.graph_data = data
      
      recalculate_pixels_per_unit
      
      data.each_with_index do |p, i|
        data[i] = translate_data_point_to_graph_point( p )
      end
  
      data.each_with_index do |point, i|
        if i < data.size - 1
          x1 = point.x
          y1 = point.y
    
          x2 = data[i+1].x
          y2 = data[i+1].y
      
          self.bitmap_drawing.draw_line( Point.new( x1, y1 ), Point.new( x2, y2), self.data_color )
        end
      end
    end
    
    def draw_horizontal_gridlines
      (self.ymin.to_i..self.ymax.to_i).each do |y|
        if y % self.yticsmod == 0
          p1 = translate_data_point_to_graph_point( Point.new( self.xmin, y ) )
          p2 = translate_data_point_to_graph_point( Point.new( self.xmax, y ) )
            
          self.bitmap_drawing.draw_line( Point.new( p1.x, p1.y ), Point.new( p2.x, p2.y ), [0xAA,0xAA,0xAA] )
      
          self.bitmap_drawing.draw_text( "#{y}", Point.new( p1.x - (10 * y.to_s.size), p1.y ), [0x00,0x00,0x00] )
        end
      end
    end
    
    def draw_vertical_gridlines
      (self.xmin.to_i..self.xmax.to_i).each do |x|
        if x % self.xticsmod == 0
          p1 = translate_data_point_to_graph_point( Point.new( x, self.ymin ) )
          p2 = translate_data_point_to_graph_point( Point.new( x, self.ymax ) )
      
          #Manual offset for GMT-7
          if (x + (3600*-7)) % 86400 == 0
            lcolor = [0x00,0x00,0xFF]
          else
            lcolor = [0xAA,0xAA,0xAA]
          end
      
      
          self.bitmap_drawing.draw_line( Point.new( p1.x, p1.y ), Point.new( p2.x, p2.y ), lcolor )
        end
      end
    end
    
    def draw_graph_outline
      p1 = translate_data_point_to_graph_point( Point.new( self.xmin, self.ymin ) )
      p2 = translate_data_point_to_graph_point( Point.new( self.xmax, self.ymin ) )
      self.bitmap_drawing.draw_line( Point.new( p1.x, p1.y ), Point.new( p2.x, p2.y ), [0x22,0x22,0x22] )
      
      p1 = translate_data_point_to_graph_point( Point.new( self.xmax, self.ymin ) )
      p2 = translate_data_point_to_graph_point( Point.new( self.xmax, self.ymax ) )
      self.bitmap_drawing.draw_line( Point.new( p1.x, p1.y ), Point.new( p2.x, p2.y ), [0x22,0x22,0x22] )
      
      p1 = translate_data_point_to_graph_point( Point.new( self.xmax, self.ymax ) )
      p2 = translate_data_point_to_graph_point( Point.new( self.xmin, self.ymax ) )
      self.bitmap_drawing.draw_line( Point.new( p1.x, p1.y ), Point.new( p2.x, p2.y ), [0x22,0x22,0x22] )
      
      p1 = translate_data_point_to_graph_point( Point.new( self.xmin, self.ymax ) )
      p2 = translate_data_point_to_graph_point( Point.new( self.xmin, self.ymin ) )
      self.bitmap_drawing.draw_line( Point.new( p1.x, p1.y ), Point.new( p2.x, p2.y ), [0x22,0x22,0x22] )
    end
    
    def draw_xaxis_labels
      (self.xmin.to_i..self.xmax.to_i).each do |x|
  
        if x % 3600 == 0
          x_offset = translate_data_point_to_graph_point( Point.new( x, 10 ) ).x.to_i
    
          h = Time.at(x).hour
    
          if h % 2 == 0
            if self.debug
              puts "h: #{h.to_s}, x: #{x_offset}"
            end
            self.bitmap_drawing.draw_text( h.to_s, Point.new( x_offset, self.height - 15 ), [0x00,0x00,0x00] )
          end
        end
      end
    end
    
    def draw_yaxis_labels
      # Currently happening in the y gridlines method
    end
    
    def translate_data_point_to_graph_point( point )
    
      if point.x < self.xmin
        point.x = self.xmin
      elsif point.x > self.xmax
        point.x = self.xmax
      end
  
      if point.y < self.ymin
        point.y = self.ymin
      elsif point.y > self.ymax
        point.y = self.ymax
      end
  
      #puts "Mid x: #{point.x}, y: #{point.y}"
  
      x = self.left_padding + (point.x - self.xmin) * self.x_pixels_per_unit
      y = self.height - self.bottom_padding - ((point.y - self.ymin) * self.y_pixels_per_unit)
  
      #puts "Out x: #{x}, y: #{y}"
  
      return Point.new( x, y )
    end
    
  end
end