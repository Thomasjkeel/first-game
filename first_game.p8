pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

-- globals --

-- variables --
local player_x
local player_y

function _init()
end

function _update()
end

function _draw()
 cls()
 rect(10,10, 100, 60, 8)
 circ(40, 40, 10, 14)
 pset(10, 100, 14)
 rectfill(80, 10, 90, 20, 11)
end
