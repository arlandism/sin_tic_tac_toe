After do
  reset_to_defaults 
end

def reset_to_defaults
  visit '/config'
  choose 'hard'
  choose 'human'
end
