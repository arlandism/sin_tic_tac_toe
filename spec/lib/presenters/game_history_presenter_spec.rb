require_relative "../../../lib/presenters/game_history_presenter.rb"

describe GameHistoryPresenter do

  game_header = "<div class='game' id='%d'>Game %d"
  game_footer = "-" * 20 + "</div>"
  id = 1700

  it "creates headers with game ids" do
    id_two = 1800
    GameRecorder.stub(:compute_file_contents).and_return({"games" => {id => {}, id_two => {}}})
    GameHistoryPresenter.show_games.should == game_header % [id,id] + game_footer + game_header % [id_two, id_two] + game_footer
  end

  it "lists the moves for each game in order" do
    pre_conversion = {"games" => {id => {"moves" => [{"position" => 3, "token" => "x"}]}}}
    GameRecorder.stub(:compute_file_contents).and_return(pre_conversion)
    GameHistoryPresenter.show_games.should == game_header % [id,id] +  "<ol><li>x moved to 3</li></ol>" + game_footer
  end

  it "lists the winner for each game" do
    pre_conversion = {"games" => {id => {"winner" => "x"}}}
    GameRecorder.stub(:compute_file_contents).and_return(pre_conversion)
    GameHistoryPresenter.show_games.should == game_header % [id,id] + "X won<br /><br />" + game_footer
  end

end

