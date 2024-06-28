-- replace in visual without yanking
-- make this the default behavior because it's
-- more intuitive
vim.keymap.set("v", "p", "\"_dP")
vim.keymap.set("v", "<leader>p", "\"_d\"0P")

vim.keymap.set("n", "<leader>p", "\"0p")

-- default using clipboard
vim.keymap.set("n", "p", "\"+p")
vim.keymap.set("n", "P", "\"+P")
vim.keymap.set("v", "p", "\"+p")
vim.keymap.set("v", "P", "\"+P")

vim.keymap.set("n", "y", "\"+y")
vim.keymap.set("v", "y", "\"+y")
vim.keymap.set("n", "Y", "\"+Y")

vim.keymap.set("n", "d", "\"+d")
vim.keymap.set("v", "d", "\"+d")

-- non clipboard
vim.keymap.set("n", ",p", "p")
vim.keymap.set("n", ",P", "P")
vim.keymap.set("v", ",p", "p")
vim.keymap.set("v", ",P", "P")

vim.keymap.set("n", ",y", "y")
vim.keymap.set("v", ",y", "y")
vim.keymap.set("n", ",Y", "Y")

vim.keymap.set("n", ",d", "d")
vim.keymap.set("v", ",d", "d")

-- delete without yank
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- <C-c> normally is slightly different from <Esc>
vim.keymap.set("i", "<C-c>", "<Esc>")

-- otherwise, space moves cursor
vim.keymap.set("n", "<space>", "<nop>")
vim.keymap.set("v", "<space>", "<nop>")
