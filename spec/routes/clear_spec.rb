require_relative 'route_spec_helper'

describe 'TTTDuet' do
  include Rack::Test::Methods

  def should_arrive_at_expected_path(expected_path)
    default_url = "http://example.org"
    last_request.url.should == default_url + expected_path
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
