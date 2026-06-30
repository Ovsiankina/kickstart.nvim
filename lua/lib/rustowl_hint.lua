local M = {}

-- type -> { label, fallback_color, legend_meaning }
-- `type` equals the RustOwl highlight-group name (server serializes snake_case).
local LEGEND = {
    definitely_live = {
        'definitely live',
        '#00cc00',
        'variable definitely initialized / alive here',
    },
    maybe_initialized = {
        'maybe initialized',
        '#00cc00',
        'alive on some paths only (maybe moved/dropped)',
    },
    imm_borrow = { 'immutable borrow', '#0000cc', 'shared borrow `&T`' },
    mut_borrow = { 'mutable borrow', '#cc00cc', 'mutable borrow `&mut T`' },
    move = { 'move', '#cccc00', 'value moved out' },
    call = { 'function call', '#cccc00', 'move/borrow at a call site' },
    shared_mut = {
        'shared + mutable',
        '#cc0000',
        'shared AND mutable borrow conflict (ERROR)',
    },
    outlive = {
        'outlives',
        '#cc0000',
        'value required to live longer than it does (ERROR)',
    },
    lifetime = { 'lifetime', '#00cc00', "variable's lifetime region" },
}

local ORDER = {
    'definitely_live',
    'maybe_initialized',
    'imm_borrow',
    'mut_borrow',
    'move',
    'call',
    'shared_mut',
    'outlive',
}

local SWATCH = '███'

-- Effective color for a deco type: prefer the live highlight group (so
-- colorscheme/user overrides win), fall back to rustowl config, then legend.
local function color_for(type_)
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = type_, link = false })
    if ok and hl then
        local n = hl.sp or hl.fg
        if n then
            return ('#%06x'):format(n)
        end
    end
    local cok, cfg = pcall(require, 'rustowl.config')
    if cok and cfg.colors and cfg.colors[type_] then
        return cfg.colors[type_]
    end
    local l = LEGEND[type_]
    return l and l[2] or nil
end

-- A solid fg-colored group for the swatch (rustowl groups only set `sp`).
local function swatch_group(type_)
    local color = color_for(type_)
    if not color then
        return nil
    end
    local name = 'RustOwlHint_' .. type_
    vim.api.nvim_set_hl(0, name, { fg = color })
    return name
end

-- 0-based cursor (l,c) inside a deco range? end is exclusive (matches painter).
function M.contains(range, l, c)
    local s, e = range.start, range['end']
    if l < s.line or l > e.line then
        return false
    end
    if l == s.line and c < s.character then
        return false
    end
    if l == e.line and c >= e.character then
        return false
    end
    return true
end

-- Render rows ({ type, text }) through the Noice notification UI.
local function render(rows, title)
    local ok, Message = pcall(require, 'noice.message')
    local mok, Manager = pcall(require, 'noice.message.manager')
    if ok and mok then
        local msg = Message('notify', 'info')
        msg.level = 'info'
        if title then
            msg:append(title, 'NoiceCmdlinePrompt')
            msg:newline()
        end
        for i, row in ipairs(rows) do
            msg:append(SWATCH, swatch_group(row.type) or 'Normal')
            msg:append(' ' .. row.text)
            if i < #rows then
                msg:newline()
            end
        end
        Manager.add(msg)
        return
    end

    -- Fallback (still routed through Noice's vim.notify shim if present).
    local lines = {}
    for _, row in ipairs(rows) do
        table.insert(lines, '• ' .. row.text)
    end
    vim.notify(
        table.concat(lines, '\n'),
        vim.log.levels.INFO,
        { title = title or 'RustOwl' }
    )
end

function M.show_legend(title)
    local rows = {}
    for _, type_ in ipairs(ORDER) do
        local meta = LEGEND[type_]
        table.insert(
            rows,
            { type = type_, text = meta[1] .. '  —  ' .. meta[3] }
        )
    end
    render(rows, title or 'RustOwl — legend')
end

local function show_hits(hits)
    local rows = {}
    for _, deco in ipairs(hits) do
        local meta = LEGEND[deco.type] or { deco.type }
        local text = meta[1]
        local hover = deco.hover_text
        if hover and hover ~= '' and hover ~= text then
            text = text .. '  —  ' .. hover
        end
        table.insert(rows, { type = deco.type, text = text })
    end
    render(rows, 'RustOwl:')
end

local function collect(decos, l, c, allow_overlapped)
    local seen, hits = {}, {}
    for _, deco in ipairs(decos) do
        if
            (allow_overlapped or not deco.overlapped)
            and M.contains(deco.range, l, c)
        then
            if not seen[deco.type] then
                seen[deco.type] = true
                table.insert(hits, deco)
            end
        end
    end
    return hits
end

-- Entry point: explain the color under the cursor, else show the full legend.
function M.show()
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.bo[bufnr].filetype ~= 'rust' then
        return
    end

    local ok, lsp = pcall(require, 'rustowl.lsp')
    local clients = ok and lsp.get_rustowl_clients { bufnr = bufnr } or {}
    if #clients == 0 then
        return M.show_legend 'RustOwl (not attached) — legend'
    end

    local cursor = vim.api.nvim_win_get_cursor(0)
    local l, c = cursor[1] - 1, cursor[2] -- 0-based line/char for LSP

    local params = {
        position = { line = l, character = c },
        document = vim.lsp.util.make_text_document_params(),
    }

    clients[1]:request('rustowl/cursor', params, function(err, result)
        if err or not result or not result.decorations then
            return M.show_legend()
        end
        local hits = collect(result.decorations, l, c, false)
        if #hits == 0 then
            hits = collect(result.decorations, l, c, true)
        end
        if #hits == 0 then
            return M.show_legend()
        end
        show_hits(hits)
    end, bufnr)
end

return M
