local M = require("chienan.utils")
local map = M.map
local nnoremap = M.nnoremap
local vnoremap = M.vnoremap

local silent = { silent = true }

vim.g.mapleader = " "

vnoremap("J", ":m '>+1<CR>gv=gv")
vnoremap("K", ":m '<-2<CR>gv=gv")

nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")

nnoremap("<leader>pv", vim.cmd.Ex)

-- Shortcut for faster save and quit
nnoremap("<leader>w", ":<C-U>update<CR>", silent)
-- Close a buffer and switching to another buffer, do not close the
-- window, see https://stackoverflow.com/q/4465095/6064933
nnoremap("<leader>x", ":<C-U>bprevious <bar> bdelete #<CR>", silent)
-- Move among buffers with mapleader"
map("<leader>.", ":bnext<CR>", silent)
map("<leader>,", ":bprev<CR>", silent)
-- Split
nnoremap("<leader>h", ":<C-U>split<CR>", silent)
nnoremap("<leader>v", ":<C-U>vsplit<CR>", silent)
-- Undo Panel
nnoremap("<leader>u", ":UndotreeToggle<CR>")
