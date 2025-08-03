-- https://wezterm.org/config/lua/general.html

-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.default_domain = 'WSL:Ubuntu-22.04'

-- For example, changing the color scheme:
config.color_scheme = 'Dracula'
config.font = wezterm.font 'CaskaydiaCove Nerd Font'
config.font_size = 8.0
config.line_height = 1.0

config.keys = {
  {
    key = '_',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = '+',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 't',
    mods = 'CTRL|ALT',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'LeftArrow',
    mods = 'CTRL|ALT',
    action = wezterm.action.ActivateTabRelativeNoWrap(-1),
  },
  {
    key = 'RightArrow',
    mods = 'CTRL|ALT',
    action = wezterm.action.ActivateTabRelativeNoWrap(1),
  },
  {
    key = 'LeftArrow',
    mods = 'CTRL|ALT|SHIFT',
    action = wezterm.action.MoveTabRelative(-1),
  },
  {
    key = 'RightArrow',
    mods = 'CTRL|ALT|SHIFT',
    action = wezterm.action.MoveTabRelative(1),
  },
  {
    key = 'R',
    mods = 'CTRL|ALT|SHIFT',
    action = wezterm.action.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
}

-- and finally, return the configuration to wezterm
return config
