module Simms
  class Packet
    
    # Action type constants
    ACTION_BEACON = 0x35
    
    # Parses an incoming packet, extracts its enclosed beacon data, instantiates
    # the correct beacon class, and returns it.  Raises exceptions on malformed data.
    # If beacon type is unknown, raises an exception if raise_on_unknown is set to true.  Otherwise,
    # unknown beacons are returned as nil.
    def self.parse(timestamp, data_packet, raise_on_unknown = false)
      # Parse the string into hex pair bytes for the mesh packet
      mesh_data = Bytes.new(data_packet)
      
      # Extract the bytes for the embedded beacon data
      beacon_data = mesh_data[34..-1]
      
      # Verify data
      if mesh_data.empty? || beacon_data.empty?
        raise "Malformed packet - missing segments"
      end
      unless mesh_data.uint16(32) == beacon_data.count
        raise "Malformed packet - length field (#{mesh_data.uint16(32)}) does not match data length (#{beacon_data.count})"
      end
      
      # Parse timestamp - always UTC time
      timestamp = Time.utc(*(timestamp.split(/[\- \:]/)))
      
      # Get key variables from packet
      uuid = mesh_data.slice(6,6).data.join('-')
      group = beacon_data.uint16(0)
      command = beacon_data.uint8(2)
      action = beacon_data.uint8(3)
      
      # Instantiate beacon instance (assuming it's a beacon action!)
      klass = Simms::Beacon.class_for(group, command) if action == ACTION_BEACON
      if klass
        # Create the beacon, then set all the meta-info we have about it
        beacon = klass.new(beacon_data)
        beacon.command_group_id = group
        beacon.device_command_id = command
        beacon.timestamp = timestamp
        beacon.uuid = uuid
        beacon
        
      else        
        raise "Unable to find beacon class for group #{group} and command #{command}" if raise_on_unknown
        nil
      end
    end
    
  end
end