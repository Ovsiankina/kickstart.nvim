-- NOTE: configuration: DONE (24.11.25)

-- Detect tabstop and shiftwidth automatically
return {
    'NMAC427/guess-indent.nvim',
    config = function()
        require('guess-indent').setup {}
    end,
}
