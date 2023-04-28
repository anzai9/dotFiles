local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
local action_layout = require('telescope.actions.layout')
local action_state = require("telescope.actions.state")

local keymapOpts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>ff', builtin.find_files, keymapOpts)
vim.keymap.set('n', '<leader>fg', builtin.live_grep, keymapOpts)
vim.keymap.set('n', '<leader>fb', builtin.buffers, keymapOpts)
vim.keymap.set('n', '<leader>fh', builtin.help_tags, keymapOpts)
vim.keymap.set('n', '<leader>fc', builtin.commands, keymapOpts)
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, keymapOpts)
vim.keymap.set('n', '<leader>*', builtin.grep_string, keymapOpts)
vim.keymap.set('n', '<leader>:', builtin.command_history, keymapOpts)
vim.keymap.set('n', '<leader>fs', builtin.spell_suggest, keymapOpts)
vim.keymap.set('n', '<leader>fT', '<cmd>TodoTelescope<cr>', keymapOpts)
vim.keymap.set('n', '<leader>ft', '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>', keymapOpts)
vim.keymap.set('n', '<leader>fa', builtin.autocommands, keymapOpts)
vim.keymap.set('n', '<leader>fk', builtin.keymaps, keymapOpts)

local custom_actions = {}

custom_actions.project_files = function()
    local opts = {}
    local ok = pcall(builtin.git_files, opts)
    if not ok then
        builtin.find_files(opts)
    end
end

-- fallback to find_files while the git_files cannot find a .git directory
vim.keymap.set('n', '<C-p>', function()
    custom_actions.project_files()
end, { silent = true })

-- open multiple files at once
custom_actions._multiple_open = function(prompt_bufnr, open_cmd)
    local picker = action_state.get_current_picker(prompt_bufnr)
    local search_res_count = picker.manager:num_results()
    if search_res_count == 0 then
        return
    end
    local selected_count = #picker:get_multi_selection()
    if not selected_count or selected_count <= 1 then
        actions.add_selection(prompt_bufnr)
    end
    actions.send_selected_to_qflist(prompt_bufnr)
    vim.cmd("cfdo " .. open_cmd)
end

custom_actions.multi_selection_open_vsplit = function(prompt_bufnr)
    custom_actions._multiple_open(prompt_bufnr, "vsplit")
end

custom_actions.multi_selection_open_split = function(prompt_bufnr)
    custom_actions._multiple_open(prompt_bufnr, "split")
end

custom_actions.multi_selection_open_tab = function(prompt_bufnr)
    custom_actions._multiple_open(prompt_bufnr, "tabe")
end

custom_actions.multi_selection_open = function(prompt_bufnr)
    custom_actions._multiple_open(prompt_bufnr, "edit")
end

require("telescope").load_extension("node_modules")
require("telescope").load_extension("harpoon")
require("telescope").load_extension("git_worktree")
require('telescope').setup {
    defaults = {
        path_display = {
            shorten = { len = 3, exclude = { 1, -1 } }
        },
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--trim",
        },
        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<esc>"] = actions.close,
                ["<C-w>"] = action_layout.toggle_preview,
                ["<C-x>"] = false,
                ["<CR>"] = custom_actions.multi_selection_open,
                ["<C-V>"] = custom_actions.multi_selection_open_vsplit,
                ["<C-S>"] = custom_actions.multi_selection_open_split,
                ["<C-T>"] = custom_actions.multi_selection_open_tab,
            }
        }
    },
    pickers = {
        buffers = {
            previewer = false,
            mappings = {
                i = {
                    ["<C-b>"] = "delete_buffer",
                }
            }
        },
        find_files = {
            previewer = false,
            find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
        },
        oldfiles = {
            previewer = false,
        },
        git_files = {
            previewer = false,
        }
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        }
    },
}

vim.keymap.set("n", "<leader>gw", function()
    require("telescope").extensions.git_worktree.git_worktrees()
end)

vim.keymap.set("n", "<leader>gm", function()
    require("telescope").extensions.git_worktree.create_git_worktree()
end)

return custom_actions
