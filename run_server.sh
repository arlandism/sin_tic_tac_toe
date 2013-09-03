#!/bin/bash

echo "Please input the absolute path of the start_server script including the .py extension"
read script_location
python $script_location &>log.txt &
ruby main.rb
