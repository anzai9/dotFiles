local fn = vim.fn
local M = {}

function M.may_create_dir()
  local fpath = fn.expand('<afile>')
  local parent_dir = fn.fnamemodify(fpath, ":p:h")
  local res = fn.isdirectory(parent_dir)

  if res == 0 then
    fn.mkdir(parent_dir, 'p')
  end
end

local function bind(op, outer_opts)
  outer_opts = outer_opts or { noremap = true }
  return function(lhs, rhs, opts)
    opts = vim.tbl_extend("force",
      outer_opts,
      opts or {}
    )
    vim.keymap.set(op, lhs, rhs, opts)
  end
end

M.map = bind("", { noremap = false })
M.nmap = bind("n", { noremap = false })
M.nnoremap = bind("n")
M.inoremap = bind("i")
M.vnoremap = bind("v")
M.xnoremap = bind("x")

return M
