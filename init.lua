vim.g.mapleader = ';'

-- buffer navigation
vim.api.nvim_set_keymap("n", "<Tab>", "<cmd>:bnext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-Tab>", "<cmd>:bprev<CR>", { noremap = true, silent = true })

-- line numbers
vim.wo.relativenumber = true
vim.wo.number = true

-- color scheme
require('kanagawa').setup({
	transparent = true,
	theme = "dragon",
	colors = {
		palette = {
			sumiInk0 = "#000000",
			sumiInk1 = "#0B0B0E",
			sumiInk2 = "#1a1a22",
			sumiInk3 = "#1a1a22",
			sumiInk4 = "#1F1F28",
			sumiInk5 = "#2A2A37",
			sumiInk6 = "#363646",
		}}
	})

vim.opt.termguicolors = true
vim.cmd.colorscheme 'kanagawa'

-- mason 
require("mason").setup({
    ui = {
        icons = {
            package_installed = "",
            package_pending = "",
            package_uninstalled = "",
        },
    }
})
require("mason-lspconfig").setup()

-- rust-tools
local rt = require("rust-tools")
rt.setup({
	server = {
		settings = {
			["rust-analyzer"] = {
				-- Add clippy lints for Rust.
				checkOnSave = {
					allFeatures = true,
					command = "clippy",
					extraArgs = { "--no-deps" },
				},
				procMacro = {
					enable = true 
				},
				cargo = {
					allFeatures = true,
				},
			}
		},
		on_attach = function(_, bufnr)
			vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
			-- Hover actions
			vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
			-- Code actions
			vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
		end,
	},
	tools = {
		inlay_hints = {
			max_len_align = true,
			max_len_align_padding = 2
		}
	}
})

local format_sync_grp = vim.api.nvim_create_augroup("Format", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rs",
  callback = function()
    vim.lsp.buf.format({ timeout_ms = 200 })
  end,
  group = format_sync_grp,
})

-- diagnostics
local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({name = 'DiagnosticSignError', text = ''})
sign({name = 'DiagnosticSignWarn', text = ''})
sign({name = 'DiagnosticSignHint', text = ''})
sign({name = 'DiagnosticSignInfo', text = ''})

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

-- diagnostics: trouble keymaps
vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end)
vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end)
vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end)
vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end)
vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)
require("trouble").setup({
	position = "right"
})

-- Completion Plugin Setup
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
  -- Installed sources:
  sources = {
    { name = 'path' },                              -- file paths
    { name = 'nvim_lsp', keyword_length = 3 },      -- from language server
    { name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
    { name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
    { name = 'buffer', keyword_length = 2 },        -- source current buffer
    { name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip 
    { name = 'calc'},                               -- source for math calculation
  },
  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  formatting = {
      fields = {'menu', 'abbr', 'kind'},
      format = function(entry, item)
          local menu_icon ={
              nvim_lsp = 'λ',
              vsnip = '⋗',
              buffer = 'Ω',
              path = '🖫',
          }
          item.menu = menu_icon[entry.source.name]
          return item
      end,
  },
})
