local g = vim.g
local o = vim.o
local opt = vim.opt

o.termguicolors = true

-- Decrease update time
o.timeoutlen = 500
o.updatetime = 250

o.scrolloff = 8

o.number = true
o.numberwidth = 2
o.relativenumber = true
o.signcolumn = "yes"
--o.cursorline = true

o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smartindent = true
o.cindent = true
o.autoindent = true
o.wrap = true

-- Undo more with wundo
--opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
o.ignorecase = true
o.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Remember 50 items in commandline history
o.history = 50

-- Better buffer splitting
o.splitright = true
o.splitbelow = true

-- Click to position
o.mouse = "a"

-- Map <leader> to space
g.mapleader = " "
g.maplocalleader = " "

vim.filetype.add({
    extension = {
        qml = "qmljs"
    }
})
