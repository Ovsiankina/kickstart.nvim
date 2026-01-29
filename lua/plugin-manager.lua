local M = {}

M.install = function()
  -- [[ Install `lazy.nvim` plugin manager ]]
  --    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
  local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
  ---@diagnostic disable-next-line: undefined-field
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system {
      'git',
      'clone',
      '--filter=blob:none',
      '--branch=stable',
      lazyrepo,
      lazypath,
    }
    if vim.v.shell_error ~= 0 then
      error('Error cloning lazy.nvim:\n' .. out)
    end
  end

  ---@type vim.Option
  local rtp = vim.opt.rtp
  rtp:prepend(lazypath)
end

M.plugins = function()
  -- [[ Configure and install plugins ]]
  require('lazy').setup(M.imports, {
    ui = {
      -- If you are using a Nerd Font: set icons to an empty table which will use the
      -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
      icons = vim.g.have_nerd_font and {} or M.icons,
    },
    checker = {
      enabled = true,
      notify = false, -- We handle notifications in M.updater() with /tmp flag
      frequency = 86400,
    },
  })
end

M.updater = function()
  local flag_file = '/tmp/nvim-lazy-mason-updater-flag'

  ---------------------------------------------------------------------------
  -- Lazy
  ---------------------------------------------------------------------------
  local function lazy_check()
    require('lazy.manage.checker').check()
  end

  local function lazy_get_updates()
    local updates = {}
    for _, plugin in ipairs(require('lazy.manage.checker').updated) do
      table.insert(updates, plugin.name)
    end
    return updates
  end

  local function lazy_update()
    vim.cmd 'Lazy update'
  end

  ---------------------------------------------------------------------------
  -- Mason
  ---------------------------------------------------------------------------
  local function mason_update()
    vim.cmd 'MasonToolsUpdate'
  end

  ---------------------------------------------------------------------------
  -- Combined
  ---------------------------------------------------------------------------
  local function update_all()
    local lazy_updates = lazy_get_updates()
    local msg = ''

    if #lazy_updates > 0 then
      msg = 'Lazy plugins to update:\n'
      for _, name in ipairs(lazy_updates) do
        msg = msg .. '  - ' .. name .. '\n'
      end
    else
      msg = 'Lazy plugins: all up to date'
    end
    msg = msg .. '\n\nMason tools will also be checked.\n\nProceed with update?'

    vim.ui.select({ 'Yes', 'No' }, { prompt = msg }, function(choice)
      if choice == 'Yes' then
        lazy_update()
        mason_update()
      end
    end)
  end

  -- TODO: Bug - LazyCheck event not firing or checker.updated empty.
  -- Intent: check for Lazy+Mason updates once per session using /tmp flag,
  -- notify user if updates available. Currently notification never shows.
  local function check_once_per_session()
    if vim.uv.fs_stat(flag_file) then
      return
    end

    local fd = vim.uv.fs_open(flag_file, 'w', 438)
    if fd then
      vim.uv.fs_close(fd)
    end

    -- Listen for LazyCheck event (fires when checker completes)
    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyCheck',
      once = true,
      callback = function()
        local lazy_updates = lazy_get_updates()
        if #lazy_updates > 0 then
          vim.notify(
            #lazy_updates .. ' plugin update(s) available. Use <leader>Syu to update.',
            vim.log.levels.INFO
          )
        end
      end,
    })

    -- Trigger check after startup
    vim.defer_fn(lazy_check, 1000)
  end

  ---------------------------------------------------------------------------
  -- Entrypoint: register commands, keymaps, and run session check
  ---------------------------------------------------------------------------
  vim.api.nvim_create_user_command('UpdateAll', update_all, { desc = 'Update Lazy plugins and Mason tools' })
  vim.keymap.set('n', '<leader>Syu', update_all, { desc = '[S]ync [y]our [u]pdates (Lazy + Mason)' })

  check_once_per_session()
end

local p = 'plugins.'
local work = p .. '.workflow.'
local edit = p .. '.text-editing.'
local lang = p .. '.languages.'
local ide = p .. '.ide.'
local ui = p .. '.ui.'
local ui_comp = ui .. '.components.'
local spe = p .. '.special.'
M.imports = {
  -- [[ Grouped plugins ]]

  -- [[ Text-editing ]]
  -- Plugins that makes the writting part of coding much more pleasant ! Think blink, mini, indentation, autopairs, etc.
  { import = edit .. 'hints' },
  { import = edit .. 'navigation' },
  { import = edit .. 'snippets' },
  { import = edit .. 'tools' },

  -- [[ General workflow ]]
  -- Plugins that helps your workflow.
  -- Think file navigation with Telescope !
  { import = work .. 'workspace-navigation' },
  { import = work .. 'state' },
  { import = work .. 'project-managment' },
  { import = work .. 'splits' },

  -- [[ UI plugins ]]
  -- UI plugins regroup everything that adds styling to new modules in the editor environment.
  -- Think oil.nvim or git-signs.
  { import = ui },
  { import = ui .. 'styling' },
  { import = ui .. 'rendering' },
  -- Special folder for ChadNV "stolen" plugins
  -- I like the design but I don't want the bloat nor be constrained by
  -- opinonated design :)
  { import = ui .. 'NvUI' },
  --
  -- [[ Components (UI sub-group) ]]
  -- Plugins that add or modify specific components part of the UI. Examples
  -- include adding a bufferline and modifying the existing signcolumn.
  { import = ui_comp .. 'statusline' },
  { import = ui_comp .. 'signcolumn' },
  { import = ui_comp .. 'left-panel' },
  { import = ui_comp .. 'top-bar' },   -- not a very good name but whatever

  -- [[ IDE tooling ]]
  -- Plugins all arond powerful IDE tooling such as LSPs, DAPs, linters and formatters
  --
  -- 'IDE-tooling' is named after how `mason.nvim` describes what it handles i.e: external editor tooling such as LSP servers, DAP servers, linters, and formatters
  { import = ide .. 'mason' },
  { import = ide .. 'lsp' },
  { import = ide .. 'dap' },
  { import = ide .. 'lint' },
  { import = ide .. 'fmt' },
  { import = ide .. 'parser' },

  { import = lang .. 'rust' },
  { import = lang .. 'lua' },
  { import = lang .. 'markdown' },
  { import = lang .. 'latex' },

  { import = spe },
}

--  [[ Language specific plugins ]]
--  Plugins that aims a specific language or set of languages.
local langs = require 'settings.enabled-languages'
if langs.lua then
  table.insert(M.imports, { import = 'plugins.languages.lua' })
end

if langs.rust then
  table.insert(M.imports, { import = 'plugins.languages.rust' })
end

M.icons = {
  cmd = '⌘',
  config = '🛠',
  event = '📅',
  ft = '📂',
  init = '⚙',
  keys = '🗝',
  plugin = '🔌',
  runtime = '💻',
  require = '🌙',
  source = '📄',
  start = '🚀',
  task = '📌',
  lazy = '💤 ',
}

return M
-- vim: ts=2 sts=2 sw=2 et
