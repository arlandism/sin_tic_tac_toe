
class ButtonPresenter

  def self.render(move_hash,number_of_buttons)
    buttons = Array.new
    button_template = "<input type='submit', value='%s', name='player_move'>"
    filled_button_template = "<input type='submit', value='%s', name='player_move', disabled>"

    (1..number_of_buttons).each do |num|
      button = move_hash[num.to_s] ? filled_button_template % move_hash[num.to_s]: button_template % num
      buttons << button
      if num % 3 == 0
        buttons << "<div></div>" 
      end
    end

    buttons.join("") 
  end
end
