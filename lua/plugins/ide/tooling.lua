-- File name: tooling.lua
-- Author: ovsiankina
-- Date created: 2025-11-29 19:27:17
-- Date modified: 2025-11-30 19:30:39
-- ----------------------------------
-- Copyright (c) 2025 Ovsiankina <ovsiankina@proton.me>
--
-- All rights reserved.

local M = {}

-- local langs = require 'settings.enabled-languages'

M.mason_packages = {
    -- See `:help lspconfig-all` for a list of all the pre-configured LSPs
    lsp = {
        clangd = {},                          -- C/C++
        rust_analyzer = {},                   -- rust
        gopls = {},                           -- Go
        pyright = {},                         -- python
        lemminx = {},                         -- XML
        docker_compose_language_service = {}, -- Docker Compose
        dockerls = {},                        -- Dockerfile
        hyprls = {},                          -- Hyprland .conf files
        lua_ls = {
            -- cmd = { 'echo', 'hello world' },
            -- filetypes = { ... },
            settings = {
                Lua = {
                    completion = {
                        callSnippet = 'Replace',
                    },
                    -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                    diagnostics = {
                        disable = {
                            'missing-fields',
                        },
                        globals = { 'vim' },
                    },
                    workspace = {
                        checkThirdParty = false,
                        library = vim.api.nvim_get_runtime_file('', true),
                    },
                },
            },
        },
        marksman = {},
        -- todo: make sure bashls is enabled in .zsh files
        bashls = {
            filetypes = { 'sh', 'bash', 'zsh' }, -- if you also write zsh; optional
            -- root_dir = { '.git',},
            settings = {
                bashIde = {
                    -- Index more than just *.sh so workspace symbols pick up your libs
                    globPattern = '**/*@(.sh|.bash|.zsh|.inc|.command|.env|.rc|scriptdata/**/*.sh)',
                    -- Let bashls call shellcheck with source-following
                    shellcheckArguments = { '-x' }, -- follow external sources
                    -- optional: quieten severity if too chatty
                    -- shellcheckArguments = { "-x", "--severity=warning" },
                },
            },
        },
        shellcheck = {},

        intelephense = {},
        laravel_ls = {},
        -- License key has to be placed in `~/intelephense/licence.txt`
        -- Backup licence key can be found in password manager
        -- qmlls = {
        --     cmd = {
        --         'qmlls',
        --         '-I',
        --         qt_qml,
        --         '-I',
        --         qs_sys,
        --         '-I',
        --         qs_user,
        --         -- from Qt 6.8+: consider env-provided import paths too
        --         '-E',
        --     },
        --     cmd_env = {
        --         -- also feed paths via env (qmlls will read this with -E)
        --         QML_IMPORT_PATH = table.concat(
        --             { qt_qml, qs_sys, qs_user },
        --             ':'
        --         ),
        --     },
        --     settings = {
        --         Qml = {
        --             importPaths = { qs_user }, -- keep your existing setting; server honors it
        --             diagnostic = {
        --                 missingProperty = 'ignore',
        --                 unqualified = 'warning',
        --             },
        --         },
        --     },
        -- },
    },

    formatters = {
        stylua = {
            command = 'stylua',
            args = { '--column-width', '80' },
            stdin = true,
        },
        markdownlint = {}, -- Markdown
        -- isort = {}, -- Python
        black = {},            -- Python
        -- prettierd = {}, -- Angular, CSS, HTML, JSON, JSX, JS, LESS, Markdown, SCSS, TS, Vue, YAML
        shfmt = {},            -- bash, sh, zsh
        ['clang-format'] = {}, -- C/C++
    },

    dap = {
        codelldb = {}, -- C/C++, Rust, Zig
    },

    linters = {
        -- bacon = {},
        -- luacheck = {},
        markdownlint = {},
    },
}

-- NOTE: Exclude servers that are already called by other plugins
-- This prevents duplicates servers
-- https://vi.stackexchange.com/questions/46856/neovim-duplicate-lsp-clients-attached-to-the-buffer
M.excluded_packages = {
    'rust_analyzer', -- Already called by rustaceanvim
}

M.linters_by_ft = function(lint)
    lint.linters_by_ft['markdown'] = { 'markdownlint' }

    -- if langs.rust then
    -- lint.linters_by_ft['rust'] = { 'bacon' }
    -- end
    --
    -- lint.linters_by_ft['lua'] = { 'luacheck' }
end

-- Required by Treesitter
M.parsers = {
    'bash',
    'c',
    'cpp',
    'rust',
    'diff',
    'html',
    'lua',
    'luadoc',
    'markdown',
    'markdown_inline',
    'query',
    'vim',
    'vimdoc',
    'regex',
}

return M
