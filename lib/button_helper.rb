
class ButtonHelper

  def self.render(hash,number_of_buttons)
    buttons = Array.new
    button_template = "<input type='submit', value='%s', name='player_move'>"
    (1..number_of_buttons).each do |num|
      button = hash[num] ? button_template % hash[num]: button_template % num
      buttons << button
      if num % 3 == 0
        buttons << "<div></div>" 
      end
    end
    buttons.join("") 
  end
end
