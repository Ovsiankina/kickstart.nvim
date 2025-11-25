local M = {}

local langs = require 'settings.enabled-languages'

M.mason_packages = {
    -- See `:help lspconfig-all` for a list of all the pre-configured LSPs
    lsp = {
        clangd = {}, -- C/C++
        gopls = {}, -- Go
        pyright = {}, -- python
        -- rust_analyzer = {}, -- rust
        lemminx = {}, -- XML
        docker_compose_language_service = {}, -- Docker Compose
        dockerls = {}, -- Dockerfile
        hyprls = {}, -- Hyprland .conf files
        lua_ls = {
            -- cmd = { 'echo', 'hello world' },
            -- filetypes = { ... },
            settings = {
                Lua = {
                    completion = {
                        callSnippet = 'Replace',
                    },
                    -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                    diagnostics = { disable = { 'missing-fields' } },
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
        -- License key has to be placed in `~/intelephense/licence.txt`
        -- Backup licence key can be found in password manager
        qmlls = {
            cmd = {
                'qmlls',
                '-I',
                qt_qml,
                '-I',
                qs_sys,
                '-I',
                qs_user,
                -- from Qt 6.8+: consider env-provided import paths too
                '-E',
            },
            cmd_env = {
                -- also feed paths via env (qmlls will read this with -E)
                QML_IMPORT_PATH = table.concat(
                    { qt_qml, qs_sys, qs_user },
                    ':'
                ),
            },
            settings = {
                Qml = {
                    importPaths = { qs_user }, -- keep your existing setting; server honors it
                    diagnostic = {
                        missingProperty = 'ignore',
                        unqualified = 'warning',
                    },
                },
            },
        },
    },
    -- linter AND formatters
    formatters = {
        stylua = {}, -- Used to format Lua code
        markdownlint = {}, -- Markdown
        -- isort = {}, -- Python
        black = {}, -- Python
        -- prettierd = {}, -- Angular, CSS, HTML, JSON, JSX, JS, LESS, Markdown, SCSS, TS, Vue, YAML
        shfmt = {}, -- bash, sh, zsh
        ['clang-format'] = {}, -- C/C++
    },
    -- Debugger
    dap = {
        codelldb = {}, -- C/C++, Rust, Zig
    },

    linters = {
        bacon = {},
    },
}

-- NOTE: Exclude servers that are already called by other plugins
-- This prevents duplicates servers
-- https://vi.stackexchange.com/questions/46856/neovim-duplicate-lsp-clients-attached-to-the-buffer
M.excluded_packages = {
    'rust_analyzer', -- Already called by rustaceanvim
}

return M
