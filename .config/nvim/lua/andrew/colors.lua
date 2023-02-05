-- Doesn't seem to be necessary if style matches terminal style
--[[
vim.cmd([[
    augroup remove_background
        autocmd!
        autocmd ColorScheme * highlight Normal guibg=NONE ctermbg=NONE
        autocmd ColorScheme * highlight EndOfBuffer guibg=NONE ctermbg=NONE
    augroup END
]]
--]]

vim.g.sonokai_style = 'default'
vim.g.sonokai_better_performance = 1
vim.cmd([[colorscheme sonokai]])

-- Highlight the region on yank
vim.cmd([[
    augroup highlight_yank
        autocmd!
        au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=100 }
    augroup END
]])

