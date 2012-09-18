require 'simms/beacon'

module Simms
  class ElectricityConfigBeacon < Simms::Beacon

    def ct_amps
      @bytes.uint16(6)
    end
    
    def nominal_voltage
      @bytes.uint16(8)
    end
    
    def phase_type
      @bytes.uint8(10)
    end
    
    # Human-readable description of the phase type
    def phase_type_description
      case phase_type
      when 0 then
        '3 Phase With Neutral, Display L-N'
      when 1 then
        '3 Phase With Neutral, Display L-L'
      when 2 then
        'Single Split Phase A+B with Neutral, Display L-N'
      when 3 then 
        'Single Phase A to Neutral, Display L-N'
      else
        'Unknown phase type!'
      end
    end
  end
end