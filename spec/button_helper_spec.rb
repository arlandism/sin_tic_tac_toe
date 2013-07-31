require './lib/button_helper'

describe ButtonHelper do

  describe "#render" do

    button_template = "<input type='submit', value='%s', name='player_move'>"

    def render_returns_expected?(hash,num_buttons)
      ButtonHelper.render(hash,num_buttons).should == @buttons.join("") + "<div></div>" 
    end

    before(:each) do
      @buttons = Array.new
    end

    context "given a blank hash with no values"
    it "outputs 3 buttons with numeric values" do
      (1..3).each do |num|
        @buttons << button_template % num 
      end
      render_returns_expected?({},3)
    end

    it "outputs 4 buttons with numeric values" do
      (1..4).each do |num|
        @buttons << button_template % num
        if num == 3
          @buttons << "<div></div>"
        end
      end
      ButtonHelper.render({},4).should == @buttons.join("")
    end

    context "given a hash with values present"
    it "outputs 3 buttons with values" do 
      ["x","o","x"].each do |token|
        @buttons << button_template % token
      end
      board = {1 => "x", 2 => "o", 3 => "x"}
      render_returns_expected?(board,3)
    end

    context "given number_of_buttons = 9"
    it "outputs a div after 3 buttons" do
      (1..9).each do |num|
        @buttons << button_template % num
        if num % 3 == 0
          @buttons << "<div></div>"
        end
      end
      ButtonHelper.render({},9).should == @buttons.join("") 
    end
  end
end      
