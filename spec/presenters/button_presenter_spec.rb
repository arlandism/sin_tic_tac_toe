require_relative "../../lib/presenters/button_presenter"

describe ButtonPresenter do

  describe "#render" do

    button_template = "<input type='submit', value='%s', name='player_move', id='%s'>"
    
    blanked_button_template = String.new(button_template).insert(61,", disabled") 

    three_button_layout = [ "<input type='submit', value='1', name='player_move', id='1'>",
                            "<input type='submit', value='2', name='player_move', id='2'>",
                            "<input type='submit', value='3', name='player_move', id='3'>"].join("") + "<div></div>"

    def render_returns_expected?(hash,num_buttons)
      ButtonPresenter.render(hash,num_buttons).should == @buttons.join("") + "<div></div>" 
    end

    before(:each) do
      @buttons = Array.new
    end

    context "given a blank hash with no values" do
      it "outputs 3 buttons with numeric values" do
        ButtonPresenter.render({"winner" => ""},3).should == three_button_layout 
      end
    end

    it "outputs 4 buttons with numeric values" do
      (1..4).each do |num|
        @buttons << button_template % [num,num]
        if num == 3
          @buttons << "<div></div>"
        end
      end
      ButtonPresenter.render({"winner" => ""},4).should == @buttons.join("")
    end

    context "given a hash with values present" do
      it "outputs 3 disabled buttons with values" do 
        button_filled = blanked_button_template
        ["x","o","x"].each_with_index do |token, index|
          id_num = index + 1
          @buttons << button_filled % [token, id_num]
        end
        @buttons << "<div></div>" 
        board = {"1" => "x", "2" => "o", "3" => "x"}
        ButtonPresenter.render(board,3).should == @buttons.join("")
      end
    end

    context "given number_of_buttons = 9" do
      it "outputs a div after 3 buttons" do
        (1..9).each do |num|
          @buttons << button_template % [num, num]
          if num % 3 == 0
            @buttons << "<div></div>"
          end
        end
        ButtonPresenter.render({"winner" => ""},9).should == @buttons.join("") 
      end
    end

    context "given board with empty winner" do
      it "outputs normal board" do
        ButtonPresenter.render({"winner" => ""},3).should == three_button_layout
      end
    end
    
    context "given board with non-nil winner" do
      it "outputs board with blanked-out keys" do
        buttons = Array.new
        blanked_buttons = (1..3).each do |n|
          buttons << blanked_button_template % [n,n] 
        end 
        ButtonPresenter.render({"winner" => "x"},3).should == buttons.join("") + "<div></div>" 
      end
    end
  end
end      
