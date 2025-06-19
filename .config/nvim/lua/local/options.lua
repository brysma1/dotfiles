-- Sets cursor to be a block, no blink, no line, just block, eternal block
vim.opt.guicursor = ""

-- Disables mouse so normies get confused
vim.opt.mouse = ""

-- Enables line numbers and relative numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Sets tab width to 4, and replaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- high (room temp in celcius) iq vim indenting
vim.opt.smartindent = true

-- No line wrapping, so line lenght always is average
vim.opt.wrap = false

-- No swapfile for buffers
vim.opt.swapfile = false

-- No backup, i'm chronically adicted to saving files
vim.opt.backup = false

-- Undo dir and file, so undos persist after closing
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Disables after search highligting
vim.opt.hlsearch = false

-- Enables encremental search
vim.opt.incsearch = true

-- 24bit rgb shenanigans that i don't understand
vim.opt.termguicolors = true

-- Line padding from top and bottom
vim.opt.scrolloff = 8

-- Extra column at the left for symbols and stuff
vim.opt.signcolumn = "yes"

-- blazing fast file update time
vim.opt.updatetime = 50

-- .h files as c files instead of cpp
vim.g.c_syntax_for_h = 1
