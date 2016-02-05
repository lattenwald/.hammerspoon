keyboard_remap = {}

local emacs_remap = {}
emacs_remap[{{'cmd'}, hs.keycodes.map['c']}] = {{'ctrl'}, 'c'}
emacs_remap[{{'cmd'}, hs.keycodes.map['v']}] = {{'ctrl'}, 'v'}
keyboard_remap['Emacs'] = emacs_remap

local chrome_remap = {}
chrome_remap[{{'cmd'}, hs.keycodes.map['q']}] = {{'cmd'}, 'w'}
chrome_remap[{{}, hs.keycodes.map['f3']}] = {{'cmd'}, 'g'}
chrome_remap[{{}, hs.keycodes.map['f5']}] = {{'cmd'}, 'r'}
chrome_remap[{{}, hs.keycodes.map['f6']}] = {{'cmd'}, 'l'}
chrome_remap[{{}, hs.keycodes.map['f11']}] = {{'cmd', 'shift'}, 'f'}
chrome_remap[{{}, hs.keycodes.map['f12']}] = {{'cmd', 'alt'}, 'i'}
-- chrome_remap[{{'ctrl'}, hs.keycodes.map['o']}] = {{'cmd', 'shift'}, 'o'}
chrome_remap[{{'ctrl'}, hs.keycodes.map['u']}] = {{'cmd', 'alt'}, 'u'}
chrome_remap[{{'ctrl', 'shift'}, hs.keycodes.map['t']}] = {{'cmd', 'shift'}, 't'}
keyboard_remap['Google Chrome'] = chrome_remap

local rstudio_remap = {}
rstudio_remap[{{'ctrl'}, hs.keycodes.map['pageup']}] = {{'ctrl'}, 'f11'}
rstudio_remap[{{'ctrl'}, hs.keycodes.map['pagedown']}] = {{'ctrl'}, 'f12'}
rstudio_remap[{{'cmd'}, hs.keycodes.map['up']}] = {{'ctrl'}, '1'}
rstudio_remap[{{'cmd'}, hs.keycodes.map['down']}] = {{'ctrl'}, '2'}
keyboard_remap['RStudio'] = rstudio_remap
