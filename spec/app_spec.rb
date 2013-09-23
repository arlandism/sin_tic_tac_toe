require 'rack/test'

require_relative '../app'

describe 'TTTDuet' do
  include Rack::Test::Methods

  before(:each) do 
    History.stub(:write_move)
    History.stub(:write_winner)
  end

  def app
    TTTDuet.new
  end

  def verify_cookie_value(key,val)
    cookie_key = key.to_s
    rack_mock_session.cookie_jar[cookie_key].should == val
  end

  def should_arrive_at_expected_path(expected_path)
    default_url = "http://example.org"
    last_request.url.should == default_url + expected_path
  end

  describe "GET '/'" do

    before(:each) do
      @ai = double(:ai)
      AI.stub(:new).and_return(@ai)
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

  describe "GET '/clear' " do

    it "redirects to index" do
      get '/clear'
      follow_redirect!
      should_arrive_at_expected_path("/")
    end

    it "clears state cookies but not config" do
      cookies_to_be_deleted = ["1","2","3","winner"]
      persistent_cookies = ["first_player", "second_player", "depth"]
      set_all_the_cookies(persistent_cookies,cookies_to_be_deleted)
      get '/clear'

      assert_config_cookies_live(persistent_cookies)
      assert_non_config_cookies_dead(cookies_to_be_deleted)
    end

    def assert_config_cookies_live(config_cookies) 
      config_cookies.each {|val| rack_mock_session.cookie_jar[val].should_not == "" }
    end

    def assert_non_config_cookies_dead(cookies_that_should_be_dead)
      cookies_that_should_be_dead.each {|val| rack_mock_session.cookie_jar[val].should == "" }
    end

    def set_all_the_cookies(cookie_group_one, cookie_group_two)
      all_cookies =  cookie_group_one + cookie_group_two
      all_cookies.each {|val| rack_mock_session.cookie_jar[val] = "x"}
    end
  end
end
