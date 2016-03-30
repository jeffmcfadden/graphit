module Graphit
  class BitmapDrawing
  
    attr_accessor :pixels
    
    def initialize( height, width, background_color = [0x00,0x00,0x00] )
      background_color = background_color.to_hex_array if background_color.class == Color
      
      self.pixels = []
      (1..height).each do |y|
        row = []
        (1..width).each do |x|
          row.push( background_color )
        end
        self.pixels.push(row)
      end
    end
    
    def height
      self.pixels.size rescue 0
    end
    
    def width
      self.pixels[0].size rescue 0
    end
    
    def draw_text( text, point, color = [0x00,0x00,0x00] )
      @characters = Graphit.pixel_font
      color = color.to_hex_array if color.class == Color
      
      px = point.x
      
      text.each_char do |c|
        if @characters[c].nil?
          # skip
        else
          @characters[c].each_with_index do |row, y|
            row.each_with_index do |col, x|
              if col == 0
                # Do nothing
              else
                thisY = px + x
                thisX = point.y + y
            
                self.pixels[thisX][thisY] = color unless pixels[thisX][thisY].nil?
              end
            end
          end
      
          px += @characters[c].size + 1
        end
      end
  
      return self.pixels
    end

    def draw_line( start_point, end_point, color )
      color = color.to_hex_array if color.class == Color
      
      len = Math.sqrt( (end_point.x-start_point.x)**2 + (end_point.y - start_point.y)**2 )
  
      d = 0.0
  
      while d < 1
        if end_point.x == start_point.x
          x = start_point.x
        else
          x = start_point.x + (end_point.x-start_point.x) * d
        end
    
        y = start_point.y + (end_point.y-start_point.y) * d
    
        self.pixels[y.to_i][x.to_i] = color unless self.pixels[y.to_i][x.to_i].nil?
    
        d += 1.0 / ( len * 2.0 )
      end
  
      return self.pixels
    end
  
  end
end