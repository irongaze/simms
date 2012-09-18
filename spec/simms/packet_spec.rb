describe Simms::Packet do
  
  SAMPLE_TIMESTAMP = '2012-06-27 16:16:08'
  SAMPLE_PACKET = 'FB10040002000015ABA0B0220100FF00FF00FFFFFFFFFFFF0100790E937900022A00FFFF0B351A820000C8000100040002000015ABA0B022010053696D6D734F666669636550616E656C0000'

  before(:all) do
    @beacon = Simms::Packet.parse(SAMPLE_TIMESTAMP, SAMPLE_PACKET)
  end

  it 'should parse valid packets' do
    Simms::Packet.parse(SAMPLE_TIMESTAMP, SAMPLE_PACKET).should_not be_nil
  end

  it 'should return the correct beacon type' do
    @beacon.should be_a(Simms::GlobalConfigBeacon)
  end

  it 'should correctly set the beacon\'s device UUID' do
    @beacon.uuid.should == '00-15-AB-A0-B0-22'
  end

  it 'should correctly set the beacon\'s timestamp' do
    @beacon.timestamp.should == Time.utc(2012,6,27,16,16,8)
  end
  
  it 'should return raise on invalid packet data' do
    lambda{Simms::Packet.parse(SAMPLE_TIMESTAMP, '1234')}.should raise_error
  end

end