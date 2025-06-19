-- Set space as leader key
vim.g.mapleader = " "

-- Open netrw
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

-- Move lines
vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv")

