class IdPresenter

  def self.show_id(game_information)
    if game_information["id"]
      "Your game i.d. is #{game_information["id"]}"
    else
      "Your game i.d. will be generated after a move is made"
    end
  end

end
