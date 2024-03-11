vim.opt.relativenumber = true;
lvim.format_on_save = false -- Disable this line
lvim.keys.normal_mode["|"] = ":vsplit<CR>"
lvim.keys.normal_mode["-"] = ":split<CR>"
vim.g.loaded_matchparen = true
-- lvim.builtin.treesitter.rainbow.enable = true
lvim.plugins = {
    {
        "ggandor/lightspeed.nvim",
        event = "BufRead",
    },
    {
        "mrjones2014/nvim-ts-rainbow",
    },
    {
        "windwp/nvim-ts-autotag",
        config = function()
            require("nvim-ts-autotag").setup()
        end,
    },
    {
        "Pocco81/auto-save.nvim",
        config = function()
            require("auto-save").setup()
        end,
    },
    {
        table.insert(lvim.plugins, {
            "zbirenbaum/copilot-cmp",
            event = "InsertEnter",
            dependencies = { "zbirenbaum/copilot.lua" },
            config = function()
                vim.defer_fn(function()
                    require("copilot").setup()     -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration
                    require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
                end, 100)
            end,
        })
    },
    {
        "karb94/neoscroll.nvim",
        event = "WinScrolled",
        config = function()
            require('neoscroll').setup({
                -- All these keys will be mapped to their corresponding default scrolling animation
                mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>',
                    '<C-y>', '<C-e>' },
                hide_cursor = false,         -- Hide cursor while scrolling
                stop_eof = false,            -- Stop at <EOF> when scrolling downwards
                use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
                respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
                cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
                easing_function = nil,       -- Default easing function
                pre_hook = nil,              -- Function to run before the scrolling animation starts
                post_hook = nil,             -- Function to run after the scrolling animation ends
            })
        end
    },
    {
        "ray-x/lsp_signature.nvim",
        event = "BufRead",
        config = function() require "lsp_signature".on_attach() end,
    },
    -- {
    --     "turbio/bracey.vim",
    --     cmd = {"Bracey", "BracyStop", "BraceyReload", "BraceyEval"},
    --     build = "npm install --prefix server",
    -- },
}
