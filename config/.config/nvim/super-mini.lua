require("opts")
require("keymaps")
require("wsl")
require("utils")
-- [MODULE] mini.lua
-- [DEPENDENCIES]
vim.pack.add({
    -- mini.nvim dependencies
    "https://github.com/JoosepAlviste/nvim-ts-context-commentstring",
    -- real mini
    "https://github.com/nvim-mini/mini.nvim",
})

local StatusLineOpts = {
    use_icons = vim.g.have_nerd_font,
    content = {
        active = function()
            local check_macro_recording = function()
                if vim.fn.reg_recording() ~= "" then
                    return "Reg @" .. vim.fn.reg_recording()
                else
                    return ""
                end
            end

            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 200 })

            local filename = MiniStatusline.section_filename({ trunc_width = 140 })
            local location = MiniStatusline.section_location({ trunc_width = 400 })
            local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
            local macro = check_macro_recording()
            -- local git = MiniStatusline.section_git({ trunc_width = 40 })
            -- local diff = MiniStatusline.section_diff({ trunc_width = 75 })
            -- local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
            -- local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
            -- local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })

            return MiniStatusline.combine_groups({
                { hl = mode_hl,                  strings = { mode } },
                -- { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics } },
                "%<", -- Mark general truncate point
                { hl = "MiniStatuslineFilename", strings = { filename } },
                "%=", -- End left alignment
                { hl = "MiniStatuslineFilename", strings = { macro } },
                -- { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
                { hl = mode_hl,                  strings = { search, location } },
            })
        end,
    },
}

require("mini.ai").setup()
require("mini.statusline").setup(StatusLineOpts)
require("mini.surround").setup()
require("mini.move").setup()
require("mini.extra").setup()
require("mini.pairs").setup()
require("mini.cursorword").setup()
require("mini.indentscope").setup()

-- require("mini.tabline").setup()
require("mini.starter").setup()

-- NOTE: check later if u use it or not
require("mini.surround").setup()
require("mini.comment").setup({
    options = {
        custom_commentstring = function()
            return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
        end,
    },
})

local hipatterns = require("mini.hipatterns")
hipatterns.setup({
    highlighters = {
        todo = { pattern = "%f[%w]()TODO:.*", group = "MiniHipatternsTodo" },
        fixme = { pattern = "%f[%w]()FIXME:.*", group = "MiniHipatternsFixme" },
        test = { pattern = "%f[%w]()TEST:.*", group = "MiniHipatternsHack" },
        note = { pattern = "%f[%w]()NOTE:.*", group = "MiniHipatternsNote" },
        info = { pattern = "%f[%w]()INFO:.*", group = "MiniHipatternsNote" },
        source = { pattern = "%f[%w]()SOURCE:", group = "MiniHipatternsNote" },
        small_source = { pattern = "%f[%w]()source:", group = "MiniHipatternsNote" },
        -- note = hi_words({ "NOTE", "INFO" }, "MiniHipatternsNote"),
        -- source = hi_words({ "SOURCE", "source" }, "MiniHipatternsNote"),

        hex_color = hipatterns.gen_highlighter.hex_color(),
    },
})

local function pasty()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-r>+", true, true, true), "n", true)
end

local pick = require("mini.pick")
pick.setup({
    mappings = {
        to_quickfix = {
            char = "<C-q>",
            func = function()
                pick.default_choose_marked(pick.get_picker_matches()["shown"])
            end,
        },
        sys_paste2 = {
            char = "<C-S-v>",
            func = pasty,
        },
        sys_paste = {
            char = "<C-v>",
            func = pasty,
        },
    },
})

vim.keymap.set("n", "<leader>z", function()
    require("mini.misc").zoom()
end, { noremap = true, silent = true, desc = "MINI: Zoom in/out buffer" })

vim.keymap.set("n", "<leader>ff", "<CMD>Pick files<CR>", { desc = "[F]ind [F]iles" })
-- Replace Telescope live_grep with mini.pick live_grep
vim.keymap.set("n", "<leader>fg", "<CMD>Pick grep_live<CR>", { desc = "[F]ind [G]rep" })
vim.keymap.set("n", "<leader>fk", "<CMD>Pick keymaps<CR>", { desc = "[F]ind [K]eymaps" })
vim.keymap.set("n", "<leader>fc", "<CMD>Pick commands<CR>", { desc = "[F]ind [C]ommands" })
vim.keymap.set("n", "<leader>fh", "<CMD>Pick help<CR>", { desc = "[F]ind [H]elp" })
vim.keymap.set("n", "<leader><leader>", "<CMD>Pick buffers<CR>", { desc = "[F]ind [B]uffers" })
vim.keymap.set("n", "<leader>fp", ":Pick hipatterns<CR>", {
    desc = "Find search hipatterns",
})

vim.keymap.set(
    "n",
    "<leader>fd",
    "<CMD>Pick diagnostic scope='current' sort_by='severity'<CR>",
    { desc = "[F]ind [D]iagnostic in current buffer" }
)

vim.keymap.set(
    "n",
    "<leader>fD",
    "<CMD>Pick diagnostic scope='all' sort_by='severity'<CR>",
    { desc = "[F]ind [D]iagnostic in all buffers" }
)

-- [MODULE] theme.lua
vim.pack.add({
    "http://github.com/xiyaowong/transparent.nvim",
    "http://github.com/catppuccin/nvim",
})
-- transparent.nvim config
require("transparent").setup({
    -- table: additional groups that should be cleared
    extra_groups = {
        "NormalFloat", -- plugins which have float panel such as Lazy, Mason, LspInfo
    },
})

require("transparent").clear_prefix("Oil")
require("transparent").clear_prefix("Fyler")
require("transparent").clear_group({ "MiniStatusline" })
-- require("transparent").clear_prefix("Avante")
require("transparent").clear_prefix("Float")
-- maybe should be on the after dir
-- vim.cmd("TransparentEnable")
-- catppuccin config
vim.cmd.colorscheme("catppuccin-mocha")

local accent = "#cba6f7"
vim.diagnostic.config({
    severity_sort = true,
    virtual_lines = true,
    float = {
        scope = "cursor",
        border = "rounded",
        max_width = 80,
    },
})

vim.api.nvim_set_hl(0, "MiniStatuslineModeNormal", { fg = accent })
vim.api.nvim_set_hl(0, "MiniStatuslineModeVisual", { fg = accent })
vim.api.nvim_set_hl(0, "MiniStatuslineModeCommand", { fg = accent })
vim.api.nvim_set_hl(0, "MiniStatuslineModeInsert", { fg = accent })
vim.api.nvim_set_hl(0, "MiniStatuslineModeReplace", { fg = accent })
vim.api.nvim_set_hl(0, "MiniStatuslineModeOther", { fg = accent })
vim.api.nvim_set_hl(0, "NotifyBackground", { bg = accent })
vim.api.nvim_set_hl(0, "MiniTablineCurrent", { fg = accent })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = accent })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = accent })

-- [MODULE] file explorer
vim.pack.add({
    "https://github.com/FylerOrg/fyler.nvim",
})

local fyler = require("fyler")
fyler.setup({
    kind = "floating",
    kind_presets = {
        floating = {
            height = "90%",
            width = "20%",
            col = 'end',
            row = 'center',
            -- top = "90%",
            -- left = "90%",
        },
    },
})
vim.keymap.set("n", "<leader>fe", fyler.toggle, {})

-- [MODULE] lsp and completion

-- download configs and enable needed lsps
vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })
vim.lsp.enable("pyright") -- For Python
vim.lsp.enable("gopls")   -- For Go
vim.lsp.enable("lua_ls")  -- For Lua


-- on attach
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local opts = { buffer = args.buf }
        -- Jump to definition
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        -- Show hover documentation
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        -- Native rename symbol (New default shortcut is often GRN)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        -- View references (New default shortcut is often GRR)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    end,
})

-- -- Enable native LSP autocompletion
-- vim.lsp.completion.enable(true)

-- -- Configure popup menu behavior
vim.opt.completeopt = { 'menu', 'menuone', 'noselect', 'noinsert' }

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
        if client:supports_method('textDocument/implementation') then
            -- Create a keymap for vim.lsp.buf.implementation ...
        end

        -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
        if client:supports_method('textDocument/completion') then
            -- Optional: trigger autocompletion on EVERY keypress. May be slow!
            local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
            client.server_capabilities.completionProvider.triggerCharacters = chars

            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end

        -- formatting is handeled by conform

        -- Auto-format ("lint") on save.
        -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
        -- if not client:supports_method('textDocument/willSaveWaitUntil')
        --     and client:supports_method('textDocument/formatting') then
        --     vim.api.nvim_create_autocmd('BufWritePre', {
        --         group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
        --         buffer = ev.buf,
        --         callback = function()
        --             vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
        --         end,
        --     })
        -- end
    end,
})

vim.keymap.set("i", "<C-Space>", function()
    if vim.fn.pumvisible() == 1 then
        vim.fn.complete_info({ "selected" })
        vim.api.nvim_feedkeys(vim.keycode("<C-e>"), "n", false)
    else
        vim.lsp.completion.get()
    end
end)

-- [MODULE] conform

vim.pack.add({
    "http://github.com/stevearc/conform.nvim"
})


vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, {
    desc = "Disable autoformat-on-save",
    bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, {
    desc = "Re-enable autoformat-on-save",
})

local conform = require("conform")
conform.setup({
    notify_on_error = false,
    format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        --
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end
        local disable_filetypes = { c = true, cpp = true, sql = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
            lsp_format_opt = "never"
        else
            lsp_format_opt = "fallback"
        end
        return {
            timeout_ms = 2500,
            lsp_format = lsp_format_opt,
        }
    end,
    formatters_by_ft = {
        lua = { "stylua" },
        astro = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },

        -- javascript = { "biome", "biome-organize-imports" },
        -- javascriptreact = { "biome", "biome-organize-imports" },
        -- typescript = { "biome", "biome-organize-imports" },
        -- typescriptreact = { "biome", "biome-organize-imports" },

        json = { "prettier" },
        jsonc = { "prettier" },
        html = { "prettier" },
        htmlangular = { "prettier" },
        graphql = { "prettier" },
        go = { "goimports", "gofumpt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        sh = { "shfmt" },
        php = { "php", "easy-coding-standard" },
        sql = { "sql_formatter" },
        yaml = { "prettier" },
        python = { "black" },
    },

    formatters = {
        rustfmt = {
            prepend_args = { "--config", "max_width=80" },
        },
        php = {
            command = "php-cs-fixer",
            args = {
                "fix",
                "--rules=@PSR12", -- Formatting preset. Other presets are available, see the php-cs-fixer docs.
                "$FILENAME",
            },
            env = {
                PHP_CS_FIXER_IGNORE_ENV = "1",
            },
            stdin = false,
        },
    },
})



vim.keymap.set("n", "<leader>f", function()
    require("conform").format({ async = true, lsp_format = "fallback" })
end, { noremap = true, silent = true, desc = "CONFORM: format file" })
