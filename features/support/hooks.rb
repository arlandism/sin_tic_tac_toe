After do
  File.open('spec/tmp/test_history.json', 'w') do |file|
    file.truncate(0) 
  end
end
