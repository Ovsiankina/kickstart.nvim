-- NOTE: configuration: DONE (27.11.25)

-- TODO: find more keymaps to config

local map = function(keys, func, desc, mode, event)
    event = event or {}
    mode = mode or 'n'
    vim.keymap.set(
        mode,
        keys,
        func,
        { buffer = event.buf, desc = 'LSP: ' .. desc }
    )
end

local keymaps = function()
    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    map('K', function()
        require('noice.lsp').hover()
    end, 'Definitions')

    -- NOTE: Replaced by inc-rename.nvim
    -- map('gR', vim.lsp.buf.rename, '[R]e[n]ame')

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map('gca', vim.lsp.buf.code_action, 'Goto [c]ode [a]ction', { 'n', 'x' })

    -- Find references for the word under your cursor.
    map('gr', require('telescope.builtin').lsp_references, 'Goto [r]eferences')

    -- Jump to the implementation of the word under your cursor.
    --  Useful when your language has ways of declaring types without an actual implementation.
    map(
        'gi',
        require('telescope.builtin').lsp_implementations,
        'Goto [i]mplementation'
    )

    -- Jump to the definition of the word under your cursor.
    --  This is where a variable was first declared, or where a function is defined, etc.
    --  To jump back, press <C-t>.
    map('gd', require('telescope.builtin').lsp_definitions, 'Goto [d]efinition')

    -- WARN: This is not Goto Definition, this is Goto Declaration.
    --  For example, in C this would take you to the header.
    map('gh', vim.lsp.buf.declaration, 'Goto Declaration ([h]eader)')

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    map(
        'gO',
        require('telescope.builtin').lsp_document_symbols,
        '[O]pen Document Symbols'
    )

    -- Fuzzy find all the symbols in your current workspace.
    --  Similar to document symbols, except searches over your entire project.
    map(
        'gW',
        require('telescope.builtin').lsp_dynamic_workspace_symbols,
        'Open [W]orkspace Symbols'
    )

    -- Jump to the type of the word under your cursor.
    --  Useful when you're not sure what type a variable is and you want to see
    --  the definition of its *type*, not where it was *defined*.
    map(
        'gt',
        require('telescope.builtin').lsp_type_definitions,
        'Goto [t]ype Definition'
    )
end

local optional_keymaps = function(event)
    map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {
            bufnr = event.buf,
        })
    end, 'Toggle Inlay [h]ints')
end

local function client_supports_method(client, method, bufnr)
    if vim.fn.has 'nvim-0.11' == 1 then
        return client:supports_method(method, bufnr)
    else
        ---@diagnostic disable-next-line: param-type-mismatch
        return client.supports_method(method, { bufnr = bufnr })
    end
end

local function highlight_on_cursor_hold(event, client)
    --- Resolve supports_method API difference between 0.11 and 0.10

    -- Highlight references on CursorHold if supported
    if
        client
        and client_supports_method(
            client,
            vim.lsp.protocol.Methods.textDocument_documentHighlight,
            event.buf
        )
    then
        local highlight_augroup = vim.api.nvim_create_augroup(
            'kickstart-lsp-highlight',
            { clear = false }
        )
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
        })
        vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup(
                'kickstart-lsp-detach',
                { clear = true }
            ),
            callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds {
                    group = 'kickstart-lsp-highlight',
                    buffer = event2.buf,
                }
            end,
        })
    end
end

local function on_lsp_attach()
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup(
            'kickstart-lsp-attach',
            { clear = true }
        ),
        callback = function(event)
            -- Keymaps.lsp.keys(event)

            local client = vim.lsp.get_client_by_id(event.data.client_id)

            highlight_on_cursor_hold(event, client)

            -- TODO: uncomment the block below when keymap locally set
            -- (previous global Keymaps var not available anymore)
            --
            -- Optional inlay hints toggle if supported
            if
                client
                and client_supports_method(
                    client,
                    vim.lsp.protocol.Methods.textDocument_inlayHint,
                    event.buf
                )
            then
                optional_keymaps(event)
            end
        end,
    })
end

local text_icons = {
    [vim.diagnostic.severity.ERROR] = '󰅚 ',
    [vim.diagnostic.severity.WARN] = '󰀪 ',
    [vim.diagnostic.severity.INFO] = '󰋽 ',
    [vim.diagnostic.severity.HINT] = '󰌶 ',
}

return {
    'neovim/nvim-lspconfig',
    dependencies = {
        { 'j-hui/fidget.nvim', opts = {} },
        { 'mason-org/mason.nvim', opts = {} },
        'mason-org/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        'saghen/blink.cmp',
    },
    config = function()
        keymaps()
        ---------------------------------------------------------------------------
        -- LSP attach events, diagnostics, etc.
        ---------------------------------------------------------------------------
        on_lsp_attach()

        vim.diagnostic.config {
            severity_sort = true,
            float = { border = 'rounded', source = 'if_many' },
            underline = true,
            signs = vim.g.have_nerd_font and {
                text = text_icons,
            } or {},
            -- virtual_text = {
            --     source = 'if_many',
            --     spacing = 2,
            --     format = function(diagnostic)
            --         return diagnostic.message
            --     end,
            -- },
            virtual_text = false, -- Replaced by 'tiny-inline-diagnostic.nvim'
        }
    end,
}
