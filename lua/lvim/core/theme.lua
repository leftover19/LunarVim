local Log = require "lvim.core.log"

local M = {}
require('rose-pine').setup({
    --- @usage 'auto'|'main'|'moon'|'dawn'
    variant = 'moon',
    --- @usage 'main'|'moon'|'dawn'
    dark_variant = 'moon',
    bold_vert_split = false,
    dim_nc_background = false,
    disable_background = false,
    disable_float_background = false,
    disable_italics = false,
    --- @usage string hex value or named color from rosepinetheme.com/palette
    groups = {
        background = 'base',
        background_nc = '_experimental_nc',
        panel = 'surface',
        panel_nc = 'base',
        border = 'highlight_med',
        comment = 'muted',
        link = 'iris',
        punctuation = 'subtle',

        error = 'love',
        hint = 'iris',
        info = 'foam',
        warn = 'gold',

        headings = {
            h1 = 'iris',
            h2 = 'foam',
            h3 = 'rose',
            h4 = 'gold',
            h5 = 'pine',
            h6 = 'foam',
        }
        -- or set all headings at once
        -- headings = 'subtle'
    },

    -- Change specific vim highlight groups
    -- https://github.com/rose-pine/neovim/wiki/Recipes
    highlight_groups = {
        ColorColumn = { bg = 'rose' },

        -- Blend colours against the "base" background
        CursorLine = { bg = 'foam', blend = 10 },
        StatusLine = { fg = 'love', bg = 'love', blend = 10 },

        -- By default each group adds to the existing config.
        -- If you only want to set what is written in this config exactly,
        -- you can set the inherit option:
        Search = { bg = 'love', inherit = true },
    }
});

-- Set colorscheme after options
M.config = function()
    lvim.builtin.theme = {
        name = "lunar",
        lunar = {
            options = { -- currently unused
            },
        },
        tokyonight = {
            options = {
                on_highlights = function(hl, c)
                    hl.IndentBlanklineContextChar = {
                        fg = c.dark5,
                    }
                    hl.TSConstructor = {
                        fg = c.blue1,
                    }
                    hl.TSTagDelimiter = {
                        fg = c.dark5,
                    }
                end,
                style = "night",                       -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
                transparent = lvim.transparent_window, -- Enable this to disable setting the background color
                terminal_colors = true,                -- Configure the colors used when opening a `:terminal` in Neovim
                styles = {
                    -- Style to be applied to different syntax groups
                    -- Value is any valid attr-list value for `:help nvim_set_hl`
                    comments = { italic = true },
                    keywords = { italic = true },
                    functions = {},
                    variables = {},
                    -- Background styles. Can be "dark", "transparent" or "normal"
                    sidebars = "dark", -- style for sidebars, see below
                    floats = "dark",   -- style for floating windows
                },
                -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
                sidebars = {
                    "qf",
                    "vista_kind",
                    "terminal",
                    "packer",
                    "spectre_panel",
                    "NeogitStatus",
                    "help",
                },
                day_brightness = 0.3,             -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
                hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
                dim_inactive = false,             -- dims inactive windows
                lualine_bold = false,             -- When `true`, section headers in the lualine theme will be bold
                use_background = true,            -- can be light/dark/auto. When auto, background will be set to vim.o.background
            },
        },
    }
end

M.setup = function()
    -- avoid running in headless mode since it's harder to detect failures
    if #vim.api.nvim_list_uis() == 0 then
        Log:debug "headless mode detected, skipping running setup for lualine"
        return
    end

    local selected_theme = lvim.builtin.theme.name

    if vim.startswith(lvim.colorscheme, selected_theme) then
        local status_ok, plugin = pcall(require, selected_theme)
        if not status_ok then
            return
        end
        pcall(function()
            plugin.setup(lvim.builtin.theme[selected_theme].options)
        end)
    end

    -- ref: https://github.com/neovim/neovim/issues/18201#issuecomment-1104754564
    local colors = vim.api.nvim_get_runtime_file(("colors/%s.*"):format(lvim.colorscheme), false)
    if #colors == 0 then
        Log:debug(string.format("Could not find '%s' colorscheme", lvim.colorscheme))
        return
    end

    vim.g.colors_name = lvim.colorscheme
    vim.cmd("colorscheme " .. lvim.colorscheme)

    if package.loaded.lualine then
        require("lvim.core.lualine").setup()
    end
    if package.loaded.lir then
        require("lvim.core.lir").icon_setup()
    end
end

return M
