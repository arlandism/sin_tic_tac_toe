
class ButtonPresenter

  def self.render(board_state,number_of_buttons)
    buttons = Array.new
    button_template = "<input type='submit', value='%s', name='player_move'>"
    filled_button_template = "<input type='submit', value='%s', name='player_move', disabled>"

      (1..number_of_buttons).each do |num|
        if board_state["winner"] == "" or board_state["winner"].nil?
          button = board_state[num.to_s] ? filled_button_template % board_state[num.to_s]: button_template % num
        else
          button = board_state[num.to_s] ? filled_button_template % board_state[num.to_s]: filled_button_template % num
        end
        buttons << button

        if num % 3 == 0
          buttons << "<div></div>" 
        end
      end
    buttons.join("") 
  end
end
