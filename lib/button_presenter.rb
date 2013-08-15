
class ButtonPresenter

  def self.render(board_state,number_of_buttons)
    buttons = Array.new
    base_button = "<input type='submit', value='%s', name='player_move', id='%s'>"
    after_id_tag = 61
    filled_base_button = String.new(base_button).insert(after_id_tag, ", disabled") 
      (1..number_of_buttons).each do |num|
        if board_state["winner"] == "" or board_state["winner"].nil?
          button = board_state[num.to_s] ? filled_base_button % [board_state[num.to_s],num]: base_button % [num,num]
        else
          button = board_state[num.to_s] ? filled_base_button % [board_state[num.to_s],num]: filled_base_button % [num,num]
        end
        buttons << button

        if num % 3 == 0
          buttons << "<div></div>" 
        end
      end
    buttons.join("") 
  end
end
