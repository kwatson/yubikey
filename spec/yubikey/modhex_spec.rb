# encoding: US-ASCII 
describe 'Yubikey::Modhex' do

  it 'decodes modhex' do
    expect(Yubikey::ModHex.decode('hknhfjbrjnlnldnhcujvddbikngjrtgh')).to eq("i\266H\034\213\253\242\266\016\217\"\027\233X\315V")
    expect(Yubikey::ModHex.decode('urtubjtnuihvntcreeeecvbregfjibtn')).to eq("\354\336\030\333\347o\275\f33\017\0345Hq\333")

    expect(Yubikey::ModHex.decode('dteffuje')).to eq("-4N\203")
    expect(Yubikey::ModHex.decode('ifhgieif')).to eq('test')
    expect(Yubikey::ModHex.decode('hhhvhvhdhbid')).to eq('foobar')
    expect(Yubikey::ModHex.decode('cc')).to eq("\000")
  end

  it 'encode modhex' do
    expect(Yubikey::ModHex.encode("i\266H\034\213\253\242\266\016\217\"\027\233X\315V")).to eq('hknhfjbrjnlnldnhcujvddbikngjrtgh')
    expect(Yubikey::ModHex.encode("\354\336\030\333\347o\275\f33\017\0345Hq\333")).to eq('urtubjtnuihvntcreeeecvbregfjibtn')
    expect(Yubikey::ModHex.encode("-4N\203")).to eq('dteffuje')
    expect(Yubikey::ModHex.encode('test')).to eq('ifhgieif')
    expect(Yubikey::ModHex.encode('foobar')).to eq('hhhvhvhdhbid')
    expect(Yubikey::ModHex.encode("\000")).to eq('cc')
  end

  it 'raise an error when modhex string length uneven' do
    expect { Yubikey::ModHex.decode('ifh') }.to raise_error(ArgumentError)
  end

end
