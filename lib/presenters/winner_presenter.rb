
class Winner

  def self.render_if_winner(dictionary)
    if !dictionary.empty? and dictionary["human_vs_ai_winner"] != "" and  dictionary["human_vs_ai_winner"] != nil
       dictionary["human_vs_ai_winner"] + " wins" 
    end
  end

end
