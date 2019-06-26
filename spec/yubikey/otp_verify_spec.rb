require File.dirname(__FILE__) + '/../spec_helper.rb'

describe 'Yubikey::OTP::Verify' do
  
  before do
    @otp = 'ccccccbfueddkcnctfkrhdfrbtfutgtididiguttlctr'
    @id  = 8094
    @key = 'NISwCZBQ0gTbuXbRGWAf4km5xXg='
    @nonce = 'cEnCRWOnpFurshnksfcAEZvWoqdXlwbs'
    @response = "t=2012-08-01T16:09:08Z0899\n" +
      "otp=ccccccbfueddkcnctfkrhdfrbtfutgtididiguttlctr\n" +
      "nonce=cEnCRWOnpFurshnksfcAEZvWoqdXlwbs\n"
    
    @mock_http = double('http')
    @mock_http_get = double('http_get')
    allow(Net::HTTP).to receive(:new).with('api.yubico.com', 443).and_return(@mock_http)
    allow(@mock_http).to receive(:use_ssl=).with(true).and_return(nil)
    allow(@mock_http).to receive(:verify_mode=).with(OpenSSL::SSL::VERIFY_PEER).and_return(nil)
    allow(@mock_http).to receive(:cert_store=)
    allow(@mock_http).to receive(:request).with(@mock_http_get).and_return(@mock_http_get)
    
    allow(Net::HTTP::Get).to receive(:new).with(/id=#{@id}&otp=#{@otp}&nonce=[a-zA-Z0-9]{32}/).and_return(@mock_http_get)
  end
  
  it 'should verify a valid OTP' do
    ok_response = "#{@response}status=OK"
    hmac = Yubikey::OTP::Verify::generate_hmac(ok_response, @key)
    expect(@mock_http_get).to receive(:body).and_return("h=#{hmac}\n#{ok_response}")
    otp = Yubikey::OTP::Verify.new(:api_id => @id, :api_key => @key, :otp => @otp, :nonce => @nonce)
    expect(otp).to be_valid
    expect(otp).not_to be_replayed
  end
  
  it 'should verify a replayed OTP' do
    replayed_response = "#{@response}status=REPLAYED_OTP"
    hmac = Yubikey::OTP::Verify::generate_hmac(replayed_response, @key)
    expect(@mock_http_get).to receive(:body).and_return("h=#{hmac}\n#{replayed_response}")
    otp = Yubikey::OTP::Verify.new(:api_id => @id, :api_key => @key, :otp => @otp, :nonce => @nonce)
    expect(otp).not_to be_valid
    expect(otp).to be_replayed
  end
  
  it 'should raise on invalid OTP' do
    bad_response = "#{@response}status=BAD_OTP"
    hmac = Yubikey::OTP::Verify::generate_hmac(bad_response, @key)
    expect(@mock_http_get).to receive(:body).and_return("h=#{hmac}\n#{bad_response}")
    expect { otp = Yubikey::OTP::Verify.new(:api_id => @id, :api_key => @key, :otp => @otp, :nonce => @nonce) }.to raise_error(Yubikey::OTP::InvalidOTPError)
  end

  it 'should generate a correct hmac' do
    expect(Yubikey::OTP::Verify::generate_hmac(@response, @key)).to eq('sZqbbsXL5WIdqLNmr19/eq6acSM=')
  end

  it 'should raise on invalid parameters' do
    expect{ Yubikey::OTP::Verify.new({}) }.to raise_error(ArgumentError, "Must supply API ID")
    expect{ Yubikey::OTP::Verify.new({:api_id => 'foo'}) }.to raise_error(ArgumentError, "Must supply API Key")
  end

  context "with module configuration" do
    before do
      Yubikey.configure do |config|
        config.api_id  = @id
        config.api_key = @key
      end
    end

    after do
      Yubikey.reset
    end

    it "should verify a valid OTP" do
      ok_response = "#{@response}status=OK"
      hmac = Yubikey::OTP::Verify::generate_hmac(ok_response, @key)
      expect(@mock_http_get).to receive(:body).and_return("h=#{hmac}\n#{ok_response}")
      otp = Yubikey::OTP::Verify.new(:otp => @otp, :nonce => @nonce)
      expect(otp).to be_valid
      expect(otp).not_to be_replayed
    end
  end
end
