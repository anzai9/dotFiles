local neogit = require("neogit")

neogit.setup {
  disable_commit_confirmation = true,
  integrations = {
    diffview = true,
  }
}

-- nnoremap("<leader>gs", function()
  -- neogit.open({ })
-- end);
--
-- nnoremap("<leader>gr", function()
  -- neogit.refresh_manually("<afile>")
-- end);

