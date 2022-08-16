local nnoremap = require("chienan.utils").nnoremap

nnoremap("<leader>gw", function()
  require("telescope").extensions.git_worktree.git_worktrees()
end)

nnoremap("<leader>gm", function()
  require("telescope").extensions.git_worktree.create_git_worktree()
end)
