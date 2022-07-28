local neogit = require("neogit")

neogit.setup {
  integrations = {
    diffview = true,
  }
}

vim.cmd([[
augroup DefaultRefreshEvents
  au!
  au BufWritePost,BufEnter,FocusGained,ShellCmdPost,VimResume * call <SID>neogit#refresh_manually(expand('<afile>'))
augroup END
]])
