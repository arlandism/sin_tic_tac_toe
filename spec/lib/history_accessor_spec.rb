require_relative '../../lib/history_accessor'

describe HistoryAccessor do

  context "with FileHistory" do

    before(:each) do
      FileIO.stub(:read)
      File.write("fake_config.yml", "history_accessor: FileHistory")
    end

    it "delegates to the history accessor in the given config file" do
      FileHistory.should_receive(:retrieve_or_create).with("bar")
      HistoryAccessor.retrieve_or_create("bar", "fake_config.yml")
    end

    it "delegates to the history accessor in the given config file" do
      FileHistory.should_receive(:write_move).with(2, 3, "x", "bar")
      HistoryAccessor.write_move(2, 3, "x", "bar", "fake_config.yml")
    end
  end

  context "with DBHistory" do

    before(:each) do
      DatabaseIO.stub(:read)
      File.write("fake_config.yml", "history_accessor: DBHistory")
    end

    it "delegates to the history accessor in the given config file" do
      DBHistory.should_receive(:retrieve_or_create).with("bar")
      HistoryAccessor.retrieve_or_create("bar", "fake_config.yml")
    end

    it "delegates to the history accessor in the given config file" do
      DBHistory.should_receive(:write_move).with(2, 3, "x", "bar")
      HistoryAccessor.write_move(2, 3, "x", "bar", "fake_config.yml")
    end
  end

end
