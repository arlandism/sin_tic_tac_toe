
class Winner

  def self.render_if_winner(dictionary)
    if !dictionary.empty? and dictionary["winner"] != "" and  dictionary["winner"] != nil
       dictionary["winner"] + " wins" 
    end
  end

end
