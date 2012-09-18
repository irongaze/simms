# Represents the data or configuration information broadcast by a single Simms monitoring
# device.  
module Simms
  class Beacon
    
    # Attributes
    attr_accessor :uuid, :timestamp, :command_group_id, :device_command_id
    
    # Command group codes
    CG_GLOBAL =     0xFFFF
    CG_SENSOR =     0x0001
    CG_ELECTRIC =   0x0002
    CG_HVAC =       0x0004
    CG_PULSER =     0x0005
    CG_IRRIGATION = 0x0007

    # Device commands
    DC_DATA =           0x0001
    DC_GLOBAL_CONFIG =  0x000B
    DC_CONFIG =         0x0022
    
    # Find the appropriate beacon class for a given group + command tuple
    def self.class_for(group, command)
      case group
        
      when CG_GLOBAL then
        case command
        when DC_GLOBAL_CONFIG then
          return Simms::GlobalConfigBeacon
        end
        
      when CG_ELECTRIC then
        case command
        when DC_DATA then
          return Simms::ElectricityDataBeacon
        when DC_CONFIG then
          return Simms::ElectricityConfigBeacon
        end
        
      end
      
      # None found!
      nil
    end
    
    def initialize(bytes)
      @bytes = bytes
    end

    def group
      case @command_group_id
      when CG_GLOBAL then :global
      when CG_SENSOR then :sensor
      when CG_ELECTRIC then :electric
      when CG_HVAC then :hvac
      when CG_PULSER then :pulser
      when CG_IRRIGATION then :irrigation
      else
        :unknown
      end
    end
    
    def type
      case @device_command_id
      when DC_DATA then :data
      when DC_CONFIG, DC_GLOBAL_CONFIG then :config
      else
        :unknown
      end
    end
    
    def data?
      type == :data
    end
    
    def config?
      type == :config
    end

  end
end