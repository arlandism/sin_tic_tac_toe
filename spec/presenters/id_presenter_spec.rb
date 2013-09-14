require_relative '../../lib/presenters/id_presenter'

describe IdPresenter do

  it "shows the id if it's present" do
    IdPresenter.show_id("id" => 3).should == "Your game i.d. is 3"
  end

  it "shows an appropriate message if i.d. isn't presenter" do
    IdPresenter.show_id({}).should == "Your game i.d. will be generated after a move is made"
  end

end
