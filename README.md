Tic Tac Toe implemented in Python, singin' with Sinatra via sockets


To play:

Download the Python and Ruby code:
```bash
git clone https://github.com/arlandism/tic_tac_toe
git clone https://github.com/arlandism/ttt_duet
```

Enter root of project directory and make the bash script executable.
```bash
cd ttt_duet
chmod a+x run_server.sh
```

Then run the script:

```bash
./run_server.sh
```

You should be prompted for the absolute or direct path to the Python start_server script
located in tic_tac_toe/network_io/start_server.py (include the .py extension on the filename)
Assuming you installed both projects in the same directory, you would input:

```../tic_tac_toe/network_io/start_server.py```

The server should open a port at localhost://4567
