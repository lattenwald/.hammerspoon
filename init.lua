hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W",
  function()
    hs.alert.show("Hello World from Hammerspoon!")
    hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
  end
)

function withFocusedWindow(func)
  local win = hs.window.focusedWindow()
  if win then
    func(win)
  else
    hs.alert.show("No focused window")
  end
end

hs.hotkey.bind({"cmd"}, "f10", function()
    withFocusedWindow(function(win) win:maximize() end)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "i", function()
    withFocusedWindow(function(win)
        hs.alert.show("win " .. hs.inspect(win:title()) ..
                        "\napp " .. hs.inspect(win:application():title()) ..
                        "\nrole " .. hs.inspect(win:role()) ..
                        "\nsubrole " .. hs.inspect(win:subrole())
        )
    end)
end)

-- BetterTouchTool replacement

modifiers = {'cmd', 'alt', 'ctrl', 'shift'}

require 'remap'

function contains(list, elem)
  for i = 1, #list do
    if list[i] == elem then return true end
  end
  return false
end

function check_flags(flags, check)
  for i = 1, #modifiers do
    local mod = modifiers[i]
    if contains(check, mod) then
      if not flags[mod] then return false end
    else
      if flags[mod] then return false end
    end
  end
  return true
end

local et = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(e)
    local win = hs.window.focusedWindow()
    if win then
      local app = win:application():title()
      if app and keyboard_remap[app] then
        local remap = keyboard_remap[app]
        local f = e:getFlags()
        local code = e:getKeyCode()
        for key, fire in pairs(remap) do
          if check_flags(f, key[1]) and code == key[2] then
            hs.alert.show(fire[3] or hs.inspect(fire), 0.3)
            return true, {hs.eventtap.keyStroke(fire[1], fire[2])}
          end
        end
      end
    end
end)

-- dev utils

et:start()

local show_all_enabled = false
local show_all_eventtap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(e)
    local f = e:getFlags()
    local code = e:getKeyCode()
    local char = e:getCharacters(true)
    hs.alert.show("flags: " .. hs.inspect(f) ..
                    "\ncode: " .. hs.inspect(code) ..
                    ", char: " .. hs.inspect(char))
end)

hs.hotkey.bind({'cmd', 'alt', 'ctrl'}, 's', function()
    if show_all_enabled then
      hs.alert.show('not showing events')
      show_all_eventtap:stop()
    else
      hs.alert.show('showing events')
      show_all_eventtap:start()
    end
    show_all_enabled = not show_all_enabled
end)
