# Manages a set of byte codes in hex string format (eg 'AF', '0C', etc) and
# provides methods for extracting floats, ints, etc from that stream by
# position.
#
# Responsible for low-level translation of incoming data into types usable
# in Ruby.
module Simms
  class Bytes

    attr_accessor :data
   
    def initialize(byte_array)
      @data = byte_array
      @data = @data.to_s.scan(/../) unless @data.is_a?(Array)
    end
    
    def count
      @data.count
    end
    
    def empty?
      count == 0
    end
    
    def uint8(pos)
      @data[pos].hex
    end
    
    def uint16(pos)
      @data[pos...pos+2].reverse.join('').hex
    end
    
    def sint16(pos)
      [@data[pos...pos+2].join].pack('H*').unpack('s').first
    end
    
    def uint32(pos)
      @data[pos...pos+4].reverse.join('').hex
    end
    
    def sint32(pos)
      [@data[pos...pos+4].join].pack('H*').unpack('l').first
    end
    
    def bool(pos)
      @data[pos].hex == 1
    end
    
    def float(pos)
      v = uint32(pos)
      x = (v & ((1 << 23) - 1)) + (1 << 23) * (v >> 31 | 1)
	    exp = (v >> 23 & 0xFF) - 127
	    return x.to_f * (2 ** (exp - 23))
    end
    
    def slice(*args)
      Bytes.new(@data.slice(*args))
    end
    
    def [](*args)
      Bytes.new(@data[*args])
    end
    
    def calc_checksum
      @data.inject(0) {|sum, byte| sum + byte.hex} % 0xFF
    end
    
    def to_s
      @data.join('')
    end
    
  end
end