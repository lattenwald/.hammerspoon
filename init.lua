-- tools
-- http://lua-users.org/wiki/StringRecipes
function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function string.ends(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end

-- modules

-- https://github.com/asmagill/hs._asm.undocumented.spaces
spaces = require("hs._asm.undocumented.spaces")

-- aliases to save some typing
a  = require("hs.alert")
w  = require("hs.window")
hk = require("hs.hotkey")
et = require("hs.eventtap")
i  = require("hs.inspect")
c  = require("hs.console")

-- constants
modifiers = {'cmd', 'alt', 'ctrl', 'shift'}

-- settings
local chord = {'cmd', 'alt', 'ctrl'}
local hangouts_space = 6

function withFocusedWindow(func)
  local win = w.focusedWindow()
  if win then
    func(win)
  else
    a.show("No focused window")
  end
end

hk.bind({"cmd"}, "f10", function()
    withFocusedWindow(function(win) win:maximize() end)
end)

-- BetterTouchTool replacement


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

local et_kdown = {}
for app_name, remap in pairs(keyboard_remap) do
  c.printStyledtext("creating etkdn for " .. app_name)
  local etkdn = et.new({et.event.types.keyDown}, function(e)
      local f = e:getFlags()
      local code = e:getKeyCode()
      for key, fire in pairs(remap) do
        if check_flags(f, key[1]) and code == key[2] then
          a.show(fire[3] or i(fire), 0.3)
          return true, {et.keyStroke(fire[1], fire[2])}
        end
      end
  end)
  et_kdown[app_name] = etkdn
end

local win_watcher = hs.application.watcher.new(
  function(app_name, event_type, app)
    local etkdn = et_kdown[app_name]
    if not(etkdn) then return end
    if event_type == hs.application.watcher.activated then
      c.printStyledtext("Starting et_kdown for " .. app_name)
      etkdn:start()
    else
      c.printStyledtext("Stopping et_kdown for " .. app_name)
      etkdn:stop()
    end
  end
)
win_watcher:start()

-- imgur screenshoter
hk.bind({'cmd', 'shift'}, '2', function()
    local screenshot = hs.task.new('/usr/local/bin/imgur-screenshot.sh',
                                   function(code, stdOut, stdErr)
                                     if code == 0 then
                                       a.show('Screenshot taken, URL in pasteboard')
                                     else
                                       a.show('Something went wrong')
                                     end
                                   end,
                                   function() return true end,
                                   {"-o", "false"}
    )
    screenshot:start()
end)

-- utils

local show_all_enabled = false
local show_all_eventtap = et.new({et.event.types.keyDown}, function(e)
    local f = e:getFlags()
    local code = e:getKeyCode()
    local char = e:getCharacters(true)
    a.show("flags: " .. i(f) ..
                    "\ncode: " .. i(code) ..
                    ", char: " .. i(char))
end)

hk.bind(chord, 's', function()
    if show_all_enabled then
      a.show('not showing events')
      show_all_eventtap:stop()
    else
      a.show('showing events')
      show_all_eventtap:start()
    end
    show_all_enabled = not show_all_enabled
end)

hk.bind(chord, "W",
  function()
    a.show("Hello World from Hammerspoon!")
    hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
  end
)

hk.bind(chord, "i", function()
    withFocusedWindow(function(win)
        a.show("win " .. i(win:title()) ..
                        "\napp " .. i(win:application():title()) ..
                        "\nrole " .. i(win:role()) ..
                        "\nsubrole " .. i(win:subrole())
        )
    end)
end)

-- from https://github.com/BrianGilbert/.hammerspoon/blob/master/init.lua
--
-- Monitor and reload config when required
--
-- function reload_config(files)
--   hs.reload()
-- end
-- hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config):start()
-- a.show("Config loaded")

hk.bind(chord, "r", function()
                 hs.reload()
                 a.show("Hammerspoon config reloading")
end)


-- from http://larryhynes.net/2015/04/a-minor-update-to-my-hammerspoon-config.html
-----------------------------------------------
-- Hyper i to show window hints
-----------------------------------------------

hk.bind(chord, 'h', function()
    hs.hints.windowHints()
end)

-- move hangouts to 4th space --
-- local hangouts_watcher = hs.application.watcher.new(function(app_name, event_type, app)
--     if (app_name == "Google Chrome"
--         and event_type == hs.application.watcher.activated) then
--       local win = w.focusedWindow()
--       local win_title = win:title()
--       if (string.starts(win_title, "Hangouts ")
--             and string.ends(win_title, "@gmail.com")
--             and spaces.activeSpace() ~= hangouts_space
--       ) then
--         a.show("Hangouts moved to space " .. i(hangouts_space))
--         spaces.moveWindowToSpace(win:id(), hangouts_space)
--       end
--     end
-- end)
-- hangouts_watcher:start()

-- window filters
-- wf = require("hs.window.filter")
-- wf_topscreen = wf.new{override={visible=true,fullscreen=false,allowScreens='0,-1',currentSpace=true}}
-- wf_curscreen = wf.new{override={visible=true,fullscreen=false,allowScreens='0,0',currentSpace=true}}

-- caffeinate
hk.bind(chord, ']', function()
          local sleepType = "system"
          local sleepPrevented = hs.caffeinate.toggle(sleepType)

          if sleepPrevented == nil then
            a.show("invalid sleep type: " .. sleepType)
            return
          elseif sleepPrevented then
            a.show("[" .. sleepType .. "] prevented")
          else
            a.show("[" .. sleepType .. "] allowed")
          end
end)

hk.bind(chord, "l", function()
          hs.caffeinate.startScreensaver()
end)
