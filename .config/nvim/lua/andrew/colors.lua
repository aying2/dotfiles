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

vim.g.sonokai_style = 'shusia'
vim.g.sonokai_better_performance = 1
vim.g.sonokai_transparent_background = 2
vim.g.sonokai_colors_override = {bg0 = {'#222222', '235'}}
vim.cmd([[colorscheme sonokai]])

-- Highlight the region on yank
vim.cmd([[
    augroup highlight_yank
        autocmd!
        au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=100 }
    augroup END
]])

vim.cmd([[highlight LspSignatureActiveParameter gui=bold guibg=#595F6F]])
vim.cmd([[highlight MatchParen gui=bold guibg=#595F6F]])
