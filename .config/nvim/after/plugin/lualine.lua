local custom_sonokai = require'lualine.themes.sonokai'

custom_sonokai.normal = custom_sonokai.insert
custom_sonokai.insert = custom_sonokai.replace
custom_sonokai.replace = custom_sonokai.visual
-- deep copy where?
custom_sonokai.visual = {
    a = {bg = "#31b681", fg = custom_sonokai.visual.a.fg, gui = 'bold'},
    b = {bg = custom_sonokai.visual.b.bg, fg = custom_sonokai.visual.b.fg},
    c = {bg = custom_sonokai.visual.c.bg, fg = custom_sonokai.visual.c.fg}
  }

require'lualine'.setup {
          options = {
            theme = custom_sonokai
          }
        }
