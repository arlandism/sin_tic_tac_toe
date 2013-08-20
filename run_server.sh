#!/bin/bash

python service/network_io/start_server.py &>log.txt &
ruby main.rb
