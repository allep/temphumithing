# temphumithing
A temperature and humidity thing developed for NodeMCU boards compatible with Mozilla Web Thing API specifications.

# Source code description
Currently the source code is very simple and it is composed of the following files:
1) init.lua: this is the starting point of the NodeMCU LUA firmware
2) config.lua: this file is actually a container for all configuration options.
3) setup.lua: this file setups NodeMCU board (i.e., it connects the board to the network, starts the servers, etc)
4) application.lua: implements the http server logic.
5) rest_model.lua: implements the actual RESTful logic, to cover both temperature and humidity readings.
