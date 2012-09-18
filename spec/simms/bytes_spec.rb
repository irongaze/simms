describe Simms::Bytes do
  
  it 'should manage a set of byte strings' do
    bytes = bytes('010200ABCD')
    bytes.count.should == 5
    bytes.data.last.should == 'CD'
  end
  
  it 'should extract unsigned 8 bit ints' do
    bytes('01').uint8(0).should == 1
    bytes('AC').uint8(0).should == 172
    bytes('FF').uint8(0).should == 255
  end
  
  it 'should extract unsigned 16 bit ints' do
    bytes('0400').uint16(0).should == 4
    bytes('0000').uint16(0).should == 0
    bytes('FFFF').uint16(0).should == 65535
  end
  
  it 'should extract unsigned 32 bit ints' do
    bytes('4EF72200').uint32(0).should == 2291534
    bytes('FFFFFFFF').uint32(0).should == 4294967295
  end
  
  it 'should extract signed 32 bit ints' do
    bytes('4EF72200').sint32(0).should == 2291534
    bytes('FFFFFFFF').sint32(0).should == -1
  end
  
  it 'should extract floats' do
    bytes('8C882044').float(0).round(4).should == 642.1335
    bytes('B43D693F').float(0).round(4).should == 0.9111
  end
  
  it 'should enable subset extraction' do
    @bytes = bytes('1234567890')
    @bytes[0].data.should == ['12']
    @bytes[1,2].to_s.should == '3456'
  end
  
  # Helper to construct a new Bytes object from a given string
  def bytes(str)
    Simms::Bytes.new(str)
  end
  
end