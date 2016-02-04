hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W",
  function()
    hs.alert.show("Hello World!")
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

local cmd_c_to_ctrl_c = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(e)
    if hs.inspect(e:getFlags()) == hs.inspect({['cmd'] = true}) then
      if e:getCharacters() == 'c' then
        return true, {hs.eventtap.keyStroke({'ctrl'}, 'c')}
      elseif e:getCharacters() == 'v' then
        return true, {hs.eventtap.keyStroke({'ctrl'}, 'v')}
      end
    end
end)

local chrome_eventtap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(e)
    local f = e:getFlags()
    local code = e:getKeyCode()
    local char = e:getCharacters(true)
    if f['cmd'] and not f['shift'] and not f['ctrl'] and not f['alt'] and not f['fn'] then
      if char == 'q' then
        return true, {hs.eventtap.keyStroke({'cmd'}, 'w')}
      end
    elseif not f['cmd'] and not f['shift'] and not f['ctrl'] and not f['alt'] and f['fn'] then
      if code == hs.keycodes.map['f5'] then
        return false, {hs.eventtap.keyStroke({'cmd'}, 'r')}
      elseif code == hs.keycodes.map['f11'] then
        return false, {hs.eventtap.keyStroke({'cmd', 'shift'}, 'f')}
      elseif code == hs.keycodes.map['f6'] then
        return false, {hs.eventtap.keyStroke({'cmd'}, 'l')}
      elseif code == hs.keycodes.map['f3'] then
        return false, {hs.eventtap.keyStroke({'cmd'}, 'g')}
      elseif code == hs.keycodes.map['f12'] then
        return false, {hs.eventtap.keyStroke({'cmd', 'alt'}, 'i')}
      end
    elseif not f['cmd'] and not f['shift'] and f['ctrl'] and not f['alt'] and not f['fn'] then
      if char == 'o' then
        return true, {hs.eventtap.keyStroke({'cmd', 'shift'}, 'o')}
      elseif char == 'u' then
        return true, {hs.eventtap.keyStroke({'cmd', 'alt'}, 'u')}
      end
    elseif not f['cmd'] and f['shift'] and f['ctrl'] and not f['alt'] and not f['fn'] then
      if char == 'T' then
        return true, {hs.eventtap.keyStroke({'cmd', 'shift'}, 't')}
      end
    end
end)

local rstudio_eventtap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(e)
    local f = e:getFlags()
    local code = e:getKeyCode()
    local char = e:getCharacters(true)
    if not f['cmd'] and not f['shift'] and f['ctrl'] and not f['alt'] and f['fn'] then
      if code == hs.keycodes.map['pageup'] then
        return true, {hs.eventtap.keyStroke({'ctrl'}, 'f11')}
      elseif code == hs.keycodes.map['pagedown'] then
        return true, {hs.eventtap.keyStroke({'ctrl'}, 'f12')}
      end
    elseif f['cmd'] and not f['shift'] and not f['ctrl'] and not f['alt'] and f['fn'] then
      if code == hs.keycodes.map['up'] then
        return true, {hs.eventtap.keyStroke({'ctrl'}, '1')}
      elseif code == hs.keycodes.map['down'] then
        return true, {hs.eventtap.keyStroke({'ctrl'}, '2')}
      end
    -- elseif not f['cmd'] and not f['shift'] and f['ctrl'] and not f['alt'] and f['fn'] then
    --   if code == hs.keycodes.map['left'] then
    --     return true, {hs.eventtap.keyStroke({'alt'}, 'left')}
    --   elseif code == hs.keycodes.map['right'] then
    --     return true, {hs.eventtap.keyStroke({'alt'}, 'right')}
    --   end
    end
    -- hs.alert.show(hs.inspect(f))
    -- hs.alert.show(hs.inspect(code))
end)

local emacsWatcher = hs.application.watcher.new(function(app_name, event_type, app)
    if app_name ~= "Emacs" then return end
    if event_type == hs.application.watcher.activated then
      cmd_c_to_ctrl_c:start()
    elseif event_type == hs.application.watcher.deactivated then
      cmd_c_to_ctrl_c:stop()
    end
end)

local chromeWatcher = hs.application.watcher.new(function(app_name, event_type, app)
    if app_name ~= "Google Chrome" then return end
    if event_type == hs.application.watcher.activated then
      chrome_eventtap:start()
    elseif event_type == hs.application.watcher.deactivated then
      chrome_eventtap:stop()
    end
end)

local rstudioWatcher = hs.application.watcher.new(function(app_name, event_type, app)
    if app_name ~= "RStudio" then return end
    if event_type == hs.application.watcher.activated then
      rstudio_eventtap:start()
    elseif event_type == hs.application.watcher.deactivated then
      rstudio_eventtap:stop()
    end
end)

emacsWatcher:start()
chromeWatcher:start()
rstudioWatcher:start()
