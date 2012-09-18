require 'simms/beacon'

module Simms
  class GlobalConfigBeacon < Simms::Beacon
    
    def version_high
      @bytes.uint16(6)
    end
    
    def version_low
      @bytes.uint16(8)
    end
    
    def firmware_version
      "#{version_high}.#{version_low}"
    end
    
    def local_devices
      @bytes.uint16(10)
    end
    
    def device_name
      name = ''
      @bytes.slice(24,16).data.collect {|b| b.hex}.each {|c| name << c if c > 0}
      name
    end
    
  end
end