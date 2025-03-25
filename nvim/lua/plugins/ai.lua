local hostname = vim.uv.os_gethostname()
local isHome = string.match(hostname, "local")

local copilotChatConfig = { -- copilot-chat
	"CopilotC-Nvim/CopilotChat.nvim",
	event = "VeryLazy",
	dependencies = {
		{ "zbirenbaum/copilot.lua" },
		{ "nvim-lua/plenary.nvim", branch = "master" },
	},
	build = "make tiktoken",
	keys = {
		{
			"<leader>aq",
			function()
				local input = vim.fn.input("Quick Chat: ")
				local select = require("CopilotChat.select")

				if input ~= "" then
					require("CopilotChat").ask(
						input,
						{ selection = select.visual or select.buffer }
					)
				end
			end,
			desc = "CopilotChat - [Q]uick chat",
			mode = { "n", "v" },
		},
		{
			"<leader>ap",
			function()
				local select = require("CopilotChat.select")

				require("CopilotChat").select_prompt({
					selection = select.visual or select.buffer,
				})
			end,
			desc = "CopilotChat - [P]rompt actions",
			mode = { "n", "v" },
		},
		{
			"<leader>as",
			function()
				local input = vim.fn.input("Perplexity: ")
				if input ~= "" then
					require("CopilotChat").ask(input, {
						agent = "perplexityai",
						selection = false,
					})
				end
			end,
			desc = "CopilotChat - Perplexity [S]earch",
			mode = { "n", "v" },
		},
		{
			"<leader>ao",
			function()
				require("CopilotChat").open()
			end,
			desc = "CopilotChat - [O]pen",
			mode = { "n" },
		},
		{
			"<leader>am",
			function()
				require("CopilotChat").select_model()
			end,
			desc = "CopilotChat - [M]odel",
			mode = { "n" },
		},
		{
			"<leader>ax",
			function()
				require("CopilotChat").reset()
			end,
			desc = "CopilotChat - Reset",
			mode = { "n" },
		},
		{
			"<leader>ae",
			"<cmd>CopilotChatExplain<cr>",
			desc = "CopilotChat - [E]xplain code",
			mode = { "n", "v" },
		},
		{
			"<leader>ar",
			"<cmd>CopilotChatReview<cr>",
			desc = "CopilotChat - [R]eview code",
			mode = { "n", "v" },
		},
		{
			"<leader>az",
			"<cmd>CopilotChatOptimize<cr>",
			desc = "CopilotChat - Optimi[Z]e code",
			mode = { "n", "v" },
		},
		{
			"<leader>at",
			"<cmd>CopilotChatTests<cr>",
			desc = "CopilotChat - [G]enerate tests",
			mode = { "n", "v" },
		},
		{
			"<leader>ad",
			"<cmd>CopilotChatDocs<cr>",
			desc = "CopilotChat - Add [D]ocuments",
			mode = { "n", "v" },
		},
		{
			"<leader>aed",
			"<cmd>CopilotChatExplainDetail<cr>",
			desc = "CopilotChat - [E]xplain code [D]etail",
			mode = { "n", "v" },
		},
	},
	opts = {
		model = isHome and "claude-3.7-sonnet" or "claude-3.5-sonnet",
		auto_follow_cursor = false, -- Don't follow the cursor after getting response
		highlight_headers = false,
		separator = "---",
		error_header = "> [!ERROR] Error",

		window = {
			width = 0.4, -- fractional width of parent
		},

		mappings = {
			complete = {
				detail = "Use @<Tab> or /<Tab> for options.",
				insert = "<Tab>",
			},
			reset = {
				normal = "<C-x>",
				insert = "<C-x>",
			},
			submit_prompt = {
				normal = "<CR>",
				insert = "<C-s>",
			},
			show_help = {
				normal = "g?",
			},
		},

		prompts = {
			ExplainDetail = {
				prompt = "> /COPILOT_EXPLAIN\n\nExplain the code line by line, focusing on its purpose, the detailed behavior of each part, and the interactions between functions.",
			},
			Optimize = {
				prompt = "> /COPILOT_GENERATE\n\nOptimize the selected code to improve performance and readability. And explain the changes made.",
			},
		},
	},
}

return {
	{ -- copilot
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			panel = {
				enabled = false,
			},
			suggestion = {
				enabled = false,
			},
		},
		dependencies = {
			"zbirenbaum/copilot-cmp",
		},
	},
	{ -- copilot-cmp
		"zbirenbaum/copilot-cmp",
		config = function()
			require("copilot_cmp").setup()
		end,
	},
	(isHome and copilotChatConfig or nil),
}
