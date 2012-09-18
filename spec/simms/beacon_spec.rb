
describe Simms::Beacon do

  SAMPLE_TIMESTAMP = '2012-06-27 16:16:08'
  SAMPLE_GC_BEACON = 'FB10040002000015ABA0B0220100FF00FF00FFFFFFFFFFFF0100790E937900022A00FFFF0B351A820000C8000100040002000015ABA0B022010053696D6D734F666669636550616E656C0000'
  SAMPLE_EC_BEACON = 'FB10040002000015ABA0B0250100FF00FF00FFFFFFFFFFFF0100AA72704C00020D00020022359FCA960078000300D3'
  SAMPLE_ED_BEACON = 'FB10040002000015ABA0B0220100FF00FF00FFFFFFFFFFFF01008E51CB1C00022E0002000135E58900014EF722004308280041E91144132620442D5EF542D417A740B43D693F8C8820447A007A000500'
  
  it 'should return the correct class for a given group + command combo' do
    {
      [0xFFFF, 0x0B] => Simms::GlobalConfigBeacon,
      [0x0002, 0x01] => Simms::ElectricityDataBeacon,
      [0x0002, 0x22] => Simms::ElectricityConfigBeacon
    }.each do |info, klass|
      Simms::Beacon.class_for(*info).should == klass
    end
  end
  
  context 'when a global configuration beacon' do
    before do
      @beacon = Simms::Packet.parse(SAMPLE_TIMESTAMP, SAMPLE_GC_BEACON)
    end
    
    it 'should know what kind of beacon it is' do
      @beacon.group.should == :global
      @beacon.type.should == :config
      @beacon.config?.should be_true
    end
    
    it 'should extract firmware version' do
      @beacon.firmware_version.should == '0.200'
    end
    
    it 'should extract local device count' do
      @beacon.local_devices.should == 1
    end
    
    it 'should extract device name' do
      @beacon.device_name.should == 'SimmsOfficePanel'
    end
  end

  context 'when an electricity configuration beacon' do
    before do
      @beacon = Simms::Packet.parse(SAMPLE_TIMESTAMP, SAMPLE_EC_BEACON)
    end
    
    it 'should know what kind of beacon it is' do
      @beacon.group.should == :electric
      @beacon.type.should == :config
      @beacon.config?.should be_true
    end
    
    it 'should extract CT clamp amps' do
      @beacon.ct_amps.should == 150
    end
    
    it 'should extract nominal voltage' do
      @beacon.nominal_voltage.should == 120
    end
    
    it 'should extract phase type' do
      @beacon.phase_type.should == 3
    end
    
    it 'should provide a user-readable phase type' do
      @beacon.phase_type_description.should == 'Single Phase A to Neutral, Display L-N'
    end
  end
  
  context 'when an electricity data beacon' do
    before do
      @beacon = Simms::Packet.parse(SAMPLE_TIMESTAMP, SAMPLE_ED_BEACON)
    end

    it 'should know what kind of beacon it is' do
      @beacon.group.should == :electric
      @beacon.type.should == :data
      @beacon.data?.should be_true
    end
    
    it 'should extract the phase' do
      @beacon.phase.should == 0
    end
    
    it 'should extract the error state' do
      @beacon.error_state.should == 1
    end
    
    it 'should extract the accumulated real energy (Wh)' do
      @beacon.accumulated_real_energy.should == 2291534
    end
    
    it 'should extract the accumulated apparent energy' do
      @beacon.accumulated_apparent_energy.should == 2623555
    end
    
    it 'should extract the present real power' do
      @beacon.present_real_power.round(4).should == 583.6446
    end
    
    it 'should extract the present apparent power' do
      @beacon.present_apparent_power.round(4).should == 640.5949
    end
    
    it 'should extract the volts rms' do
      @beacon.volts_rms.round(4).should == 122.6839
    end
    
    it 'should extract the current rms' do
      @beacon.current_rms.round(4).should == 5.2217
    end
    
    it 'should extract the power factor' do
      @beacon.power_factor.round(4).should == 0.9111
    end
    
    it 'should extract the max demand' do
      @beacon.max_demand.round(4).should == 642.1335
    end
    
    it 'should extract the volts sag' do
      @beacon.volts_sag.should == 122
    end

    it 'should extract the volts peak' do
      @beacon.volts_peak.should == 122
    end

    it 'should extract the current peak' do
      @beacon.current_peak.should == 5
    end

  end

end