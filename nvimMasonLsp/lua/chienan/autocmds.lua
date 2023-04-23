local cmd = vim.cmd

-- Do not use smart case in command line mode, extracted from https://vi.stackexchange.com/a/16511/15292.
cmd([[
  augroup dynamic_smartcase
    autocmd!
    autocmd CmdLineEnter : set nosmartcase
    autocmd CmdLineLeave : set smartcase
  augroup END
]])

-- Return to last cursor position when opening a file
cmd([[
  augroup resume_cursor_position
    autocmd!
    autocmd BufReadPost * call v:lua.resume_cursor_position()
  augroup END
]])

-- Only resume last cursor position when there is no go-to-line command
function resume_cursor_position()
  if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") and vim.bo.filetype ~= "commit" then
    local args = vim.v.argv -- command line arguments
    for _, cur_arg in ipairs(args) do
      -- Check if a go-to-line command is given.
      local idx = string.find(cur_arg, '^%+%d+$')
      if idx ~= nil then
        return
      end
    end

    vim.api.nvim_command('normal! g`"zvzz')
  end
end
