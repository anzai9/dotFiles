local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard") 
local if_nil = vim.F.if_nil

local leader = "SPC"
local function button(sc, txt, keybind, keybind_opts)
    local sc_ = sc:gsub("%s", ""):gsub(leader, "<leader>")

    local opts = {
        position = "center",
        shortcut = sc,
        cursor = 5,
        width = 50,
        align_shortcut = "right",
        hl_shortcut = "Keyword",
    }
    if keybind then
        keybind_opts = if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
        opts.keymap = { "n", sc_, keybind, keybind_opts }
    end

    local function on_press()
        local key = vim.api.nvim_replace_termcodes(sc_ .. "<Ignore>", true, false, true)
        vim.api.nvim_feedkeys(key, "t", false)
    end

    return {
        type = "button",
        val = txt,
        on_press = on_press,
        opts = opts,
    }
end

-- header
dashboard.section.header.val = {
    [[     __        ___        ___             ( )    _   __   ]],
    [[  //   ) )  //___) )  //   ) ) ||  / /   / /   // ) )  ) )]],
    [[ //   / /  //        //   / /  || / /   / /   // / /  / / ]],
    [[//   / /  ((____    ((___/ /   ||/ /   / /   // / /  / /  ]],
  }
dashboard.section.header.opts.hl = "Number"

-- menu
dashboard.section.buttons.val = {
  button( "a", "  > New file" , ":ene <BAR> startinsert <CR>"),
  button( "SPC ff", "  > Find file", ":Telescope find_files<CR>"),
  button( "SPC fo", "  > Recent"   , ":Telescope oldfiles<CR>"),
  button( "SPC fg", "  > Find word"   , ":Telescope live_grep<CR>"),
  button( "q", "  > Quit NVIM", ":qa!<CR>"),
}

-- footer
local function set_footer()
  local v = vim.version()
  return string.format("NVIM: v%d.%d.%d", v.major, v.minor, v.patch)
end
dashboard.section.footer.val = set_footer()
dashboard.section.footer.opts.hl = dashboard.section.header.opts.hl

-- quote
table.insert(dashboard.config.layout, { type = "padding", val = 1})
table.insert(dashboard.config.layout, {
  type = "text",
  val = require("alpha.fortune")(),
  opts = {
    position = "center",
    hl = "AlphaQuote",
  },
})

-- setup
alpha.setup(dashboard.config)

-- diable folding on alpha buffer
vim.cmd([[
  autocmd FileType alpha setlocal nofoldenable
]])

