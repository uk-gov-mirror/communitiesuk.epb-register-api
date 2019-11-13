require 'net/http'

require 'pry'

$process = 0

describe 'starts server outside of ruby'  do
  describe 'the server running live' do
    before(:all) do
      process = IO.popen("rackup")
      $process = process.pid
      sleep 1
    end

    after(:all) do
      `kill -9 #{$process}`
    end 

    let(:request) { Net::HTTP.new("localhost", 9292) }
 
    context "it is running" do
      it "returns status 200" do
        req = Net::HTTP::Get.new("/healthcheck")
        response = request.request(req)
        expect(response.code).to eq("200")
      end

      it "returns status 404" do
        req = Net::HTTP::Get.new("/error-message")
        response = request.request(req)
        expect(response.code).to eq("404")
      end
    end
  end 
end 