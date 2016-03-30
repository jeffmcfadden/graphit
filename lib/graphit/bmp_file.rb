module Graphit
  class BmpFile
    
    attr_accessor :bitmap_drawing
    
    def initialize( bitmap_drawing )
      self.bitmap_drawing = bitmap_drawing
    end
    
    def save_to_file( filename )
      File.open( filename, 'w') do |f|
  
        start = Time.now.to_f
  
        # if options[:debug]
        #   puts "Generating pixels: #{Time.now.to_f - start}"
        # end
  
        # if options[:debug]
        #   puts data_to_graph.size
        #   puts "Data points ^"
        #   puts "Max: #{@xmax}, Min: #{@xmin}"
        # end
  
  
        height = self.bitmap_drawing.height
        width  = self.bitmap_drawing.width
  
        start = Time.now.to_f

        pixel_data = ""
        self.bitmap_drawing.pixels.reverse.each_with_index do |row, i|
          row_bytes = 0
          row.each do |pixel|
            BinUtils.append_int8!(pixel_data, pixel[0]) 
            BinUtils.append_int8!(pixel_data, pixel[1]) 
            BinUtils.append_int8!(pixel_data, pixel[2]) 
      
            #pixel_data += [pixel[0,2].hex].pack( "C" )
            #pixel_data += [pixel[2,2].hex].pack( "C" )
            #pixel_data += [pixel[4,2].hex].pack( "C" )
      
            row_bytes += 3
          end
    
          # Padding
          bytes_to_pad = row_bytes % 4
    
          # puts "Row: #{i}, bytes: #{row_bytes}, padding: #{bytes_to_pad}"
    
          bytes_to_pad.times do
            BinUtils.append_int8!(pixel_data, 0x00) 
          end
        end
  
        # if options[:debug]
        #   puts "Generating pixel data string: #{Time.now.to_f - start}"
        # end
  
        file_size = 54 + pixel_data.size

        f.print [0x42].pack ("C")
        f.print [0x4D].pack( "C" )
        f.print [file_size].pack( "L" )
  
        f.print [0x00].pack( "C" ) # Unused
        f.print [0x00].pack( "C" )
        f.print [0x00].pack( "C" )
        f.print [0x00].pack( "C" )
  
        f.print [54].pack( "L" ) # Pixel Array Offset
  
        f.print [0x28, 0x00, 0x00, 0x00].pack( "L" )  #Number of bytes in the DIB header (from this point)

        f.print [width].pack( "L" ) #Width of the bitmap in pixels
        f.print [height].pack( "L" ) #Height
  
        f.print [0x01, 0x00].pack( "S" ) # Number of color planes being used
        f.print [0x18, 0x00].pack( "S" ) # Number of bits per pixel
        f.print [0x00].pack( "L" ) # BI_RGB, no pixel array compression used
        f.print [pixel_data.size].pack( "L" ) # Size of the raw bitmap data (including padding)
        f.print [0x130B].pack( "L" ) #2835 pixels/meter horizontal
        f.print [0x130B].pack( "L" ) #2835 pixels/meter vertical
        f.print [0x00].pack( "L" ) # Number of colors in the palette
        f.print [0x00].pack( "L" ) #0 means all colors are important
  
        f.print pixel_data
      end
    end
    
  end
end