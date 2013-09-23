require_relative 'route_spec_helper'

describe TTTDuet do
  include Rack::Test::Methods

  describe "GET '/'" do

    def verify_cookie_value(key,val)
      cookie_key = key.to_s
      rack_mock_session.cookie_jar[cookie_key].should == val
    end

    before(:each) do
      @ai = double(:ai)
      AI.stub(:new).and_return(@ai)
      History.stub(:write_move)
    end

    it 'renders index' do
      get '/'
      last_response.status.should be 200
    end

    it "calls service and stores move cookie if first_player is computer" do
      CpuMove.stub(:should_place).and_return(true)
      NextPlayer.should_receive(:move).and_return("fake_move")

      get '/'

      verify_cookie_value("fake_move","x")
    end

    it "does not place a move if cpumove says not to" do
      CpuMove.should_receive(:should_place).and_return(false)

      @ai.should_not_receive(:next_move)

      get '/'
    end

    it "places a move if cpu says to" do
      CpuMove.should_receive(:should_place).and_return(true)

      @ai.should_receive(:next_move)

      get '/'
    end

    it "asks right question of cpumove" do
      History.stub(:next_id).and_return(3)
      game_description = {"the" => "stuff",
                          "id" => "3"}

      rack_mock_session.cookie_jar["the"] = "stuff"

      CpuMove.should_receive(:should_place).with(game_description)

      get '/'
     end

    it "assigns the i.d. before AI moves" do
      get '/'
      rack_mock_session.cookie_jar["id"].should_not be nil
    end
  end
end
