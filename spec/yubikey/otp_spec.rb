describe 'Yubikey::OTP' do

  describe "should parse an OTP" do

    before :all do
      @token = Yubikey::OTP.new('enrlucvketdlfeknvrdggingjvrggeffenhevendbvgd', '4013a2c719c4e9734bbc63048b00e16b')
    end

    it "has the expected public_id" do
      expect(@token.public_id).to eq('enrlucvketdl')
    end

    it "has the expected secret_id" do
      expect(@token.secret_id).to eq('912a644bbc7b')
    end

    it "has the expected insert_counter" do
      expect(@token.insert_counter).to eq(1)
    end

    it "has the expected session_counter" do
      expect(@token.session_counter).to eq(0)
    end

    it "has the expected timestamp" do
      expect(@token.timestamp).to eq(688051)
    end

    it "has the expected random_number" do
      expect(@token.random_number).to eq(55936)
    end

  end

  it 'should raise if key or otp invalid' do
    otp = 'hknhfjbrjnlnldnhcujvddbikngjrtgh'
    key = 'ecde18dbe76fbd0c33330f1c354871db'

    expect { Yubikey::OTP.new(key, key) }.to raise_error(Yubikey::OTP::InvalidOTPError)
    expect { Yubikey::OTP.new(otp, otp) }.to raise_error(Yubikey::OTP::InvalidKeyError)

    expect { Yubikey::OTP.new(otp[0,31], key) }.to raise_error(Yubikey::OTP::InvalidOTPError)
    expect { Yubikey::OTP.new(otp, key[0,31]) }.to raise_error(Yubikey::OTP::InvalidKeyError)

    expect { Yubikey::OTP.new(otp[1,31]+'d', key) }.to raise_error(Yubikey::OTP::BadCRCError)
  end

end
