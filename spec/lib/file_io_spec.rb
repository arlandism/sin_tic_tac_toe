require 'file_io'
require 'json'

describe FileIO do

  after(:each) do
    File.open('/tmp/file', 'w') {|file| file.truncate(0)}
  end
  
  let(:path) { "spec/tmp/test_history.json" }

  it "reads the json data structures from file at the given path" do
    File.write(path, JSON.dump(["hello"]))
    FileIO.read(path).should == ["hello"]
  end

  it "writes json data data structures to file at given path" do
    FileIO.write(path, ["hello back at ya"])
    JSON.parse(File.read(path)).should == ["hello back at ya"]
  end

  it "throws a no content exception with nothing in the file" do
    path = "spec/tmp/other.json"
    File.write(path, "")
    expect {FileIO.read(path)}.to raise_error NoContentError
  end
end
