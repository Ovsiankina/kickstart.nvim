-- File name: tooling.lua
-- Author: ovsiankina
-- Date created: 2025-11-29 19:27:17
-- Date modified: 2025-12-09 13:55:02
-- ----------------------------------
-- Copyright (c) 2025 Ovsiankina <ovsiankina@proton.me>
--
-- All rights reserved.

local M = {}

-- local langs = require 'settings.enabled-languages'

M.mason_packages = {
    -- See `:help lspconfig-all` for a list of all the pre-configured LSPs
    lsp = {
        clangd = {
            cmd = {
                'clangd',
                '--clang-tidy',
                '--background-index',
                '--header-insertion=never',
            },
        }, -- C/C++
        -- Arduino: wraps clangd for .ino sketches. Needs system `arduino-cli`
        -- (+ ~/.arduino15/arduino-cli.yaml) and a per-project `sketch.yaml`
        -- with `default_fqbn` (e.g. arduino:avr:uno). Neovim maps *.ino ->
        -- filetype `arduino` out of the box.
        arduino_language_server = {}, -- Arduino (.ino), clangd-backed
        asm_lsp = {}, -- ASM
        rust_analyzer = {}, -- rust
        gopls = {}, -- Go
        pyright = {}, -- python
        lemminx = {}, -- XML
        docker_compose_language_service = {}, -- Docker Compose
        dockerls = {}, -- Dockerfile
        hyprls = {}, -- Hyprland .conf files
        html = {},
        vtsls = {
            enableMoveToFileCodeAction = true,
            expose_as_code_action = 'all',
            autoUseWorkspaceTsdk = true, -- uses YOUR project's TS version
            experimental = {
                maxInlayHintLength = 30,
                completion = {
                    enableServerSideFuzzyMatch = true,
                },
            },
            -- Strudel: pin .str/.std buffers AND the strudel-types typedef to one
            -- fixed project root so the ambient globals resolve. Normal JS/TS
            -- projects keep their usual root detection. See strudel-types.nvim.
            root_dir = function(bufnr, on_dir)
                local ok, st = pcall(require, 'strudel-types')
                if ok and st.is_strudel_root(bufnr) then
                    on_dir(st.types_dir())
                    return
                end
                local found = vim.fs.root(bufnr, {
                    'tsconfig.json',
                    'jsconfig.json',
                    'package.json',
                    '.git',
                })
                if found then
                    on_dir(found)
                else
                    local name = vim.api.nvim_buf_get_name(bufnr)
                    on_dir(name ~= '' and vim.fs.dirname(name) or nil)
                end
            end,
        },
        -- ts_ls = {
        --     single_file_support = true,
        --     -- init_options = {
        --     --     preferences = {
        --     --         includeCompletionsForModuleExports = true,
        --     --     },
        --     -- },
        --     -- settings = {
        --     --     javascript = {
        --     --         inlayHints = { enabled = true },
        --     --     },
        --     --     implicitProjectConfiguration = {
        --     --         target = 'ES2022',
        --     --         -- This is the key setting for standalone files:
        --     --         checkJs = false,
        --     --     },
        --     -- },
        -- },
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

        -- intelephense = {},
        -- License key has to be placed in `~/.config/intelephense/licence.txt`
        -- laravel_ls = {},
        eslint = {},
        ast_grep = {},
        -- NOTE: ltex_extra.nvim provides code actions
        -- but we start the server via mason-lspconfig
        ltex = {
            filetypes = { 'markdown', 'tex' },
            cmd = {
                'sh',
                '-c',
                'JAVA_OPTS="-Djdk.xml.totalEntitySizeLimit=0" exec ltex-ls',
            },
            settings = {
                ltex = {
                    language = 'auto',
                    diagnosticSeverity = 'information',
                    sentenceCacheSize = 2000,
                    additionalRules = {
                        enablePickyRules = true,
                        motherTongue = 'fr',
                    },
                },
            },
        },
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
        stylua = {},
        markdownlint = {}, -- Markdown
        -- isort = {}, -- Python
        black = {}, -- Python
        -- prettierd = {}, -- Angular, CSS, HTML, JSON, JSX, JS, LESS, Markdown, SCSS, TS, Vue, YAML
        shfmt = {}, -- bash, sh, zsh
        ['clang-format'] = {}, -- C/C++
    },

    dap = {
        codelldb = {}, -- C/C++, Rust, Zig
    },

    linters = {
        bacon = {},
        -- luacheck = {},
        markdownlint = {},
        -- cppcheck removed from mason registry; use system binary (pacman: cppcheck)
    },
}

-- LSP servers NOT managed by mason (installed externally via system package manager / cargo / etc.)
-- These are still registered + auto-enabled via vim.lsp.config/enable in mason.lua
M.manual_lsp = {
    ron_lsp = {
        cmd = { 'ron-lsp' },
        filetypes = { 'ron' },
        root_dir = function(bufnr, on_dir)
            local util = require 'lspconfig.util'
            local fname = vim.api.nvim_buf_get_name(bufnr)
            local root = util.root_pattern('Cargo.toml', '.git')(fname)
                or vim.fn.getcwd()
            on_dir(root)
        end,
        settings = {},
    },
}

-- NOTE: Exclude servers that are already called by other plugins
-- This prevents duplicates servers
-- https://vi.stackexchange.com/questions/46856/neovim-duplicate-lsp-clients-attached-to-the-buffer
M.excluded_packages = {
    'rust_analyzer', -- Already called by rustaceanvim
    'ts_ls', -- Use vtsls only; mason auto-enables the installed ts_ls otherwise -> duplicate clients
}

M.linters_by_ft = function(lint)
    -- Disable default linters that require tools we don't have installed
    lint.linters_by_ft['text'] = nil -- Disables vale for .txt files
    lint.linters_by_ft['rst'] = nil -- Disables vale for .rst files

    -- Use markdownlint instead of default vale for markdown
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
    'javascript',
    'typescript',
    'lua',
    'luadoc',
    'markdown',
    'markdown_inline',
    'query',
    'vim',
    'vimdoc',
    'regex',
    'ron',
}

return M
