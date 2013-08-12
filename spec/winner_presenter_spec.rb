require 'winner_presenter'

describe "#Winner" do

  describe "#render_if_winner" do
    it "doesn't show anything if there's no winner" do
      Winner.render_if_winner({}).should == nil
    end

    it "shows x if x is the winner" do
      Winner.render_if_winner({"winner" => "x"}).should == "x wins"
    end

    it "shows o if o is the winner" do
      Winner.render_if_winner({"winner" => "o"}).should == "o wins"
    end

    it "shows nothing if winner is empty space" do
      Winner.render_if_winner({"winner" => ""}).should == nil
    end
    
    it "shows it's a tie, if winner is nil" do
      Winner.render_if_winner({"winner" => nil}).should == nil 
    end

  end
end
