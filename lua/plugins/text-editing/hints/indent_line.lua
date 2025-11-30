local function safe_get_hl(name)
    -- Try reading the highlight; return fallback on failure
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
    if not ok or not hl then
        return { fg = { 200, 200, 200 } } -- fallback RGB
    end
    return hl
end

local function safe_set_hl(name, spec)
    -- Prevent crashes when colorscheme wipes groups
    pcall(vim.api.nvim_set_hl, 0, name, spec)
end

local function extract_rgb(hl)
    if not hl or not hl.fg then
        return 200, 200, 200
    end
    if type(hl.fg) == 'number' then
        local c = hl.fg
        local r = math.floor(c / (256 ^ 2))
        local g = math.floor(c / 256) % 256
        local b = c % 256
        return r, g, b
    elseif type(hl.fg) == 'table' then
        return hl.fg[1] or 200, hl.fg[2] or 200, hl.fg[3] or 200
    end
    return 200, 200, 200
end

local function scale_rgb(r, g, b, k)
    return math.floor(r * k), math.floor(g * k), math.floor(b * k)
end

local function hl_hex(r, g, b)
    return string.format('#%02x%02x%02x', r, g, b)
end

local function define_indent_highlight_groups()
    local default_hl = safe_get_hl 'IblIndent'
    local base_r, base_g, base_b = extract_rgb(default_hl)

    local error_hl = safe_get_hl 'Error'
    local err_r, err_g, err_b = extract_rgb(error_hl)

    local shallow_factors = { 1.0, 0.75, 0.55 }
    local shallow_names = {
        'IndentLevel1',
        'IndentLevel2',
        'IndentLevel3',
    }

    for i, k in ipairs(shallow_factors) do
        local r, g, b = scale_rgb(base_r, base_g, base_b, k)
        safe_set_hl(shallow_names[i], { fg = hl_hex(r, g, b) })
    end

    local deep_factors = { 0.35, 0.65, 1.0 }
    local deep_names = {
        'IndentTooDeep4',
        'IndentTooDeep5',
        'IndentTooDeep6',
    }

    for i, k in ipairs(deep_factors) do
        local r, g, b = scale_rgb(err_r, err_g, err_b, k)
        safe_set_hl(deep_names[i], { fg = hl_hex(r, g, b) })
    end

    local h = {
        'IndentLevel1',
        'IndentLevel2',
        'IndentLevel3',
        'IndentTooDeep4',
        'IndentTooDeep5',
        'IndentTooDeep6',
    }

    for _ = 1, 20 do
        table.insert(h, 'IndentTooDeep6')
    end

    return h
end

return {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
        local h = define_indent_highlight_groups()
        require('ibl').setup {
            indent = { highlight = h },
        }
    end,
}
