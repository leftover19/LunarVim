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
        "zbirenbaum/copilot-cmp",
        event = "InsertEnter",
        dependencies = { "zbirenbaum/copilot.lua" },
        config = function()
            vim.defer_fn(function()
                require("copilot").setup()     -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration
                require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
                -- Below config is required to prevent copilot overriding Tab with a suggestion
                -- when you're just trying to indent!
                local has_words_before = function()
                    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
                    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                    return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") ==
                    nil
                end
                local on_tab = vim.schedule_wrap(function(fallback)
                    local cmp = require("cmp")
                    if cmp.visible() and has_words_before() then
                        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                    else
                        fallback()
                    end
                end)
                lvim.builtin.cmp.mapping["<Tab>"] = on_tab
            end, 100)
        end,

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
