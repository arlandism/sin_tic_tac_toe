module SpecUtils

  def self.should_arrive_at_expected_path(last_request, expected_path)
    default_url = "http://example.org"
    last_request.url.should == default_url + expected_path
  end

  def self.verify_cookie_value(cookie_jar,key,val)
    cookie_key = key.to_s
    cookie_jar[cookie_key].should == val
  end

end
