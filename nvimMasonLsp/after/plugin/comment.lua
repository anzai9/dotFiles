require('Comment').setup({
    --[[ pre_hook = function(ctx)
        if vim.bo.filetype == 'typescriptreact' then
            local utils = require('Comment.utils')

            local type = ctx.type == utils.ctype.linewise and '__default' or '__multiline'

            local location = nil
            if ctx.type == utils.ctype.blockwise then
                location = require('ts_context_commentstring.utils').get_cursor_location()
            elseif ctx.cmotion == utils.cmotion.v or ctx.cmotion == utils.comtion.V then
                location = require('ts_context_commentstring.utils').get_visual_start_location()
            end

            print('type: ' .. type .. ' location: ' .. location)
            return require('ts_context_commentstring.internal').calculate_commentstring({
                key = type,
                location = location,
            })
        end
   end, ]]
    pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
})
