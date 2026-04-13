-- Zellij-aware pane navigation (replaces vim-tmux-navigator for zellij)
-- WASM side configured in ~/.config/zellij/config.kdl (Ctrl+h/j/k/l bindings)
-- This nvim side uses the same zellij action CLI to cross pane boundaries

local function zellij_or_nvim(zellij_dir, nvim_cmd)
    return function()
        if vim.env.ZELLIJ then
            vim.fn.jobstart({ "zellij", "action", "focus-" .. zellij_dir .. "-pane" })
        else
            vim.cmd(nvim_cmd)
        end
    end
end

return {
    -- no external plugin needed — zellij CLI handles cross-boundary navigation
    dir = vim.fn.stdpath("config"), -- dummy so lazy doesn't fetch anything
    name = "vim-zellij-navigator",
    lazy = false,
    config = function()
        vim.keymap.set("n", "<C-h>", zellij_or_nvim("left",  "wincmd h"), { desc = "Focus left pane/split" })
        vim.keymap.set("n", "<C-j>", zellij_or_nvim("down",  "wincmd j"), { desc = "Focus down pane/split" })
        vim.keymap.set("n", "<C-k>", zellij_or_nvim("up",    "wincmd k"), { desc = "Focus up pane/split" })
        vim.keymap.set("n", "<C-l>", zellij_or_nvim("right", "wincmd l"), { desc = "Focus right pane/split" })
    end,
}
