require_relative "../../lib/default_strategy"

describe DefaultStrategy do

  describe "#attribute" do
    it "returns the attribute if it's found in the body" do
      to_search = {"search_me" => "found"}
      DefaultStrategy.new("search_me",nil,to_search).attribute.should == "found"
    end

    it "returns a specified default if it can't find the attr" do
      to_search = {}
      DefaultStrategy.new("search_me","not found!", to_search).attribute.should == "not found!"
    end

    it "returns a specified default if found is empty string" do
      to_search = {"search_me" => ""}
      DefaultStrategy.new("search_me","not found!", to_search).attribute.should == "not found!"
    end
  end

end
