local hostname = vim.uv.os_gethostname()
local isHome = string.match(hostname, "local")

local M = {}

if isHome then
	table.insert(M, {
		"vhyrro/luarocks.nvim",
		priority = 1000,
		config = true,
		opts = {
			rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" },
		},
	})
	table.insert(M, {
		"rest-nvim/rest.nvim",
		ft = "http",
		dependencies = { "luarocks.nvim" },
	})
end

return M
