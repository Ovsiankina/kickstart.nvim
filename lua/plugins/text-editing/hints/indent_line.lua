local function extract_rgb(hl)
    if not hl or not hl.fg then
        return 200, 200, 200 -- safe fallback
    end
    if type(hl.fg) == 'number' then
        local c = hl.fg
        local r = math.floor(c / (256 ^ 2))
        local g = math.floor(c / 256) % 256
        local b = c % 256
        return r, g, b
    elseif type(hl.fg) == 'table' then
        return hl.fg[1], hl.fg[2], hl.fg[3]
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
    local default_hl = vim.api.nvim_get_hl(0, { name = 'IblIndent' })
    local base_r, base_g, base_b = extract_rgb(default_hl)

    local error_hl = vim.api.nvim_get_hl(0, { name = 'Error' })
    local err_r, err_g, err_b = extract_rgb(error_hl)

    -- shallow indent scales (default color)
    local shallow_factors = { 1.0, 0.75, 0.55 }
    local shallow_names = {
        'IndentLevel1',
        'IndentLevel2',
        'IndentLevel3',
    }

    for i, k in ipairs(shallow_factors) do
        local r, g, b = scale_rgb(base_r, base_g, base_b, k)
        vim.api.nvim_set_hl(0, shallow_names[i], {
            fg = hl_hex(r, g, b),
        })
    end

    -- deep indent scales (Error color)
    local deep_factors = { 0.35, 0.65, 1.0 }
    local deep_names = {
        'IndentTooDeep4',
        'IndentTooDeep5',
        'IndentTooDeep6',
    }

    for i, k in ipairs(deep_factors) do
        local r, g, b = scale_rgb(err_r, err_g, err_b, k)
        vim.api.nvim_set_hl(0, deep_names[i], {
            fg = hl_hex(r, g, b),
        })
    end

    -- build ibl highlight list
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
        -- NOTE: cannot use `opts = {}` here because we require the plugin
        -- itself as well as a function call
        require('ibl').setup {
            indent = { highlight = h },
        }
    end,
}
