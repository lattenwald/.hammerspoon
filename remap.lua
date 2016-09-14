keyboard_remap = {}

local emacs_remap = {}
emacs_remap[{{'cmd'}, hs.keycodes.map['c']}] = {{'ctrl'}, 'c', 'copy'}
emacs_remap[{{'cmd'}, hs.keycodes.map['v']}] = {{'ctrl'}, 'v', 'paste'}
keyboard_remap['Emacs'] = emacs_remap

local chrome_remap = {}
chrome_remap[{{'cmd'}, hs.keycodes.map['q']}] = {{'cmd'}, 'w', 'close tab'}
chrome_remap[{{}, hs.keycodes.map['f3']}] = {{'cmd'}, 'g', 'find next'}
chrome_remap[{{}, hs.keycodes.map['f5']}] = {{'cmd'}, 'r', 'refresh'}
chrome_remap[{{}, hs.keycodes.map['f6']}] = {{'cmd'}, 'l', 'url bar'}
chrome_remap[{{}, hs.keycodes.map['f11']}] = {{'cmd', 'ctrl'}, 'f', 'fullscreen'}
chrome_remap[{{}, hs.keycodes.map['f12']}] = {{'cmd', 'alt'}, 'i', 'devtools'}
chrome_remap[{{'ctrl'}, hs.keycodes.map['u']}] = {{'cmd', 'alt'}, 'u', 'view source'}
chrome_remap[{{'ctrl', 'shift'}, hs.keycodes.map['t']}] = {{'cmd', 'shift'}, 't' ,'restore tab'}
chrome_remap[{{'ctrl'}, hs.keycodes.map['j']}] = {{'cmd', 'shift'}, 'j', 'downloads'}
chrome_remap[{{'ctrl'}, hs.keycodes.map['h']}] = {{'cmd'}, 'y', 'history'}
keyboard_remap['Google Chrome'] = chrome_remap

local rstudio_remap = {}
rstudio_remap[{{'ctrl'}, hs.keycodes.map['pageup']}] = {{'ctrl'}, 'f11', 'prev tab'}
rstudio_remap[{{'ctrl'}, hs.keycodes.map['pagedown']}] = {{'ctrl'}, 'f12', 'next tab'}
rstudio_remap[{{'cmd'}, hs.keycodes.map['up']}] = {{'ctrl'}, '1', 'upper frame'}
rstudio_remap[{{'cmd'}, hs.keycodes.map['down']}] = {{'ctrl'}, '2', 'lower frame'}
keyboard_remap['RStudio'] = rstudio_remap

hs.console.printStyledtext("loaded remap.lua")
