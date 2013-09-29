require_relative '../../lib/history_accessor'

describe HistoryAccessor do

  let(:id)   { 2 }
  let(:path) { "bar" }

  context "with FileHistory" do

    before(:each) do
      FileIO.stub(:read)
      File.write("spec/tmp/fake_config.yml", 
                 YAML.dump({"development" => {"history_accessor" => "FileHistory"}}))
    end


    it "delegates to FileHistory.retrieve_or_create" do
      FileHistory.should_receive(:retrieve_or_create).with("bar")
      HistoryAccessor.retrieve_or_create(path, "spec/tmp/fake_config.yml")
    end

    it "delegates to FileHistory.write_move" do
      FileHistory.should_receive(:write_move).with(2, 3, "x", path)
      HistoryAccessor.write_move(2, 3, "x", path, "spec/tmp/fake_config.yml")
    end

    it "delegates to FileHistory.write_winner" do
      FileHistory.should_receive(:write_winner).with(2,"x",path)
      HistoryAccessor.write_winner(2, "x", path, "spec/tmp/fake_config.yml")
    end

    it "delegates to FileHistory.next_id" do
      FileHistory.should_receive(:next_id)
      HistoryAccessor.next_id(path, "spec/tmp/fake_config.yml")
    end

    it "delegates to FileHistory.game_by_id" do
      FileHistory.should_receive(:game_by_id).with(path, 2)
      HistoryAccessor.game_by_id(path, 2, "spec/tmp/fake_config.yml")
    end
  end

  context "with DBHistory" do

    before(:each) do
      DatabaseIO.stub(:read)
      File.write("spec/tmp/fake_config.yml", 
                 YAML.dump({"development" => {"history_accessor" => "DBHistory"}}))
    end

    it "delegates to the history accessor in the given config file" do
      DBHistory.should_receive(:retrieve_or_create).with(path)
      HistoryAccessor.retrieve_or_create(path, "spec/tmp/fake_config.yml")
    end

    it "delegates to the history accessor in the given config file" do
      DBHistory.should_receive(:write_move).with(2, 3, "x", path)
      HistoryAccessor.write_move(2, 3, "x", path, "spec/tmp/fake_config.yml")
    end

    it "delegates to DBHistory.write_winner" do
      DBHistory.should_receive(:write_winner).with(2, "x", path)
      HistoryAccessor.write_winner(2, "x", path, "spec/tmp/fake_config.yml")
    end
    
    it "delegates to DBHistory.next_id" do
      DBHistory.should_receive(:next_id).with(path)
      HistoryAccessor.next_id(path, "spec/tmp/fake_config.yml")
    end
    
    it "delegates to DBHistory.game_by_id" do
      DBHistory.should_receive(:game_by_id).with(path, 2)
      HistoryAccessor.game_by_id(path, 2, "spec/tmp/fake_config.yml")
    end
  end

end
