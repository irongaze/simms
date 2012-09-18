require 'simms/beacon'

# Electricity data beacons are sent at the time interval configured in the device, and will be
# have one packet sent per phase being monitored, ie for a 3-phase system, you will receive
# 3 data beacons per reporting interval per device, with the phase field set to 0, 1, or 2.
module Simms
  class ElectricityDataBeacon < Simms::Beacon

    # Which phase this beacon represents
    def phase
      @bytes.uint8(6)
    end
    
    # TODO What does this mean?  What are the valid values?
    def error_state
      @bytes.uint8(7)
    end
    
    # May be negative, as in the case of a solar power installation.  Is a counter, ie to get
    # the real energy (Wh) for a given interval, you need to diff against past values
    def accumulated_real_energy
      @bytes.sint32(8)
    end
    
    # In Wh - see #accumulated_real_energy for counter info
    def accumulated_apparent_energy
      @bytes.sint32(12)
    end
    
    # In W
    def present_real_power
      @bytes.float(16)
    end
    
    # In W
    def present_apparent_power
      @bytes.float(20)
    end
    
    def volts_rms
      @bytes.float(24)
    end
    
    def current_rms
      @bytes.float(28)
    end
    
    # In VA
    def power_factor
      @bytes.float(32)
    end

    def max_demand
      @bytes.float(36)
    end
    
    def volts_sag
      @bytes.uint16(40)
    end
    
    def volts_peak
      @bytes.uint16(42)
    end
    
    def current_peak
      @bytes.uint16(44)
    end

  end
end