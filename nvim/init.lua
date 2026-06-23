vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- Basic options
vim.o.number = true
vim.o.mouse = "a"
vim.o.showmode = false
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- Insert-mode movement
vim.keymap.set("i", "<C-h>", "<Left>")
vim.keymap.set("i", "<C-l>", "<Right>")
vim.keymap.set("i", "<C-j>", "<Esc>gja")
vim.keymap.set("i", "<C-k>", "<Esc>gka")
vim.keymap.set("i", "<C-CR>", "<Esc>o", { noremap = true })

-- Normal-mode basics
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic quickfix list" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus left" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus right" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus down" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus up" })

vim.keymap.set("n", "<leader>v", function()
	local word = vim.fn.expand("<cword>")

	local toggles = {
		-- numbers
		["0"] = "1",
		["1"] = "0",

		-- booleans
		["true"] = "false",
		["false"] = "true",
		["True"] = "False",
		["False"] = "True",
		["TRUE"] = "FALSE",
		["FALSE"] = "TRUE",

		-- yes / no
		["yes"] = "no",
		["no"] = "yes",
		["Yes"] = "No",
		["No"] = "Yes",
		["YES"] = "NO",
		["NO"] = "YES",

		-- on / off
		["on"] = "off",
		["off"] = "on",
		["On"] = "Off",
		["Off"] = "On",
		["ON"] = "OFF",
		["OFF"] = "ON",

		-- enabled / disabled
		["enabled"] = "disabled",
		["disabled"] = "enabled",
		["Enabled"] = "Disabled",
		["Disabled"] = "Enabled",
		["ENABLED"] = "DISABLED",
		["DISABLED"] = "ENABLED",

		-- enable / disable
		["enable"] = "disable",
		["disable"] = "enable",
		["Enable"] = "Disable",
		["Disable"] = "Enable",
		["ENABLE"] = "DISABLE",
		["DISABLE"] = "ENABLE",

		-- active / inactive
		["active"] = "inactive",
		["inactive"] = "active",
		["Active"] = "Inactive",
		["Inactive"] = "Active",
		["ACTIVE"] = "INACTIVE",
		["INACTIVE"] = "ACTIVE",

		-- open / closed
		["open"] = "closed",
		["closed"] = "open",
		["Open"] = "Closed",
		["Closed"] = "Open",
		["OPEN"] = "CLOSED",
		["CLOSED"] = "OPEN",

		-- visible / hidden
		["visible"] = "hidden",
		["hidden"] = "visible",
		["Visible"] = "Hidden",
		["Hidden"] = "Visible",
		["VISIBLE"] = "HIDDEN",
		["HIDDEN"] = "VISIBLE",

		-- public / private
		["public"] = "private",
		["private"] = "public",
		["Public"] = "Private",
		["Private"] = "Public",
		["PUBLIC"] = "PRIVATE",
		["PRIVATE"] = "PUBLIC",

		-- allow / deny
		["allow"] = "deny",
		["deny"] = "allow",
		["Allow"] = "Deny",
		["Deny"] = "Allow",
		["ALLOW"] = "DENY",
		["DENY"] = "ALLOW",

		-- allowed / denied
		["allowed"] = "denied",
		["denied"] = "allowed",
		["Allowed"] = "Denied",
		["Denied"] = "Allowed",
		["ALLOWED"] = "DENIED",
		["DENIED"] = "ALLOWED",

		-- success / failure
		["success"] = "failure",
		["failure"] = "success",
		["Success"] = "Failure",
		["Failure"] = "Success",
		["SUCCESS"] = "FAILURE",
		["FAILURE"] = "SUCCESS",

		-- pass / fail
		["pass"] = "fail",
		["fail"] = "pass",
		["Pass"] = "Fail",
		["Fail"] = "Pass",
		["PASS"] = "FAIL",
		["FAIL"] = "PASS",

		-- start / stop
		["start"] = "stop",
		["stop"] = "start",
		["Start"] = "Stop",
		["Stop"] = "Start",
		["START"] = "STOP",
		["STOP"] = "START",
	}

	local replacement = toggles[word]

	if replacement then
		vim.cmd("normal! ciw" .. replacement)
	end
end, { desc = "Toggle value" })
-- Diagnostics
vim.diagnostic.config({
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	virtual_text = true,
	virtual_lines = false,
	underline = true,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight yanked text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- UI / theme
	-- UI / theme
	{
		"tanvirtin/monokai.nvim",
		priority = 1000,
		config = function()
			require("monokai").setup({
				palette = require("monokai").classic,
			})

			vim.cmd.colorscheme("monokai")

			-- keep terminal background
			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VimEnter",
		opts = {
			delay = 0,
			spec = {
				{ "<leader>s", group = "[S]earch", mode = { "n", "v" } },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
			},
		},
	},

	{
		"nvim-mini/mini.nvim",
		config = function()
			require("mini.ai").setup({ n_lines = 500 })
			require("mini.surround").setup()

			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = vim.g.have_nerd_font })
			statusline.section_location = function()
				return "%2l:%-2v"
			end
		end,
	},

	-- File tree
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("neo-tree").setup({
				close_if_last_window = true,
				filesystem = {
					follow_current_file = { enabled = true },
					use_libuv_file_watcher = true,
				},
			})

			vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle file tree" })
		end,
	},

	-- Search
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			"nvim-telescope/telescope-ui-select.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")

			telescope.setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			pcall(telescope.load_extension, "fzf")
			pcall(telescope.load_extension, "ui-select")

			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Find buffers" })
			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "Search in current buffer" })
		end,
	},

	-- Git
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	-- Indent / pairs
	{ "NMAC427/guess-indent.nvim", opts = {} },

	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = { char = "│" },
			scope = { enabled = true },
		},
	},

	{
		"echasnovski/mini.indentscope",
		version = false,
		config = function()
			require("mini.indentscope").setup({
				symbol = "│",
			})
		end,
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			map_cr = true,
		},
	},

	-- Completion
	{
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end,
				opts = {},
			},
		},
		opts = {
			keymap = {
				preset = "super-tab",
				["<C-k>"] = {},
				["<M-k>"] = { "show_signature", "hide_signature" },
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {
				documentation = {
					auto_show = false,
					auto_show_delay_ms = 500,
				},
			},
			sources = {
				default = { "lsp", "path", "snippets" },
			},
			snippets = { preset = "luasnip" },
			fuzzy = { implementation = "lua" },
			signature = { enabled = true },
		},
	},

	{
		"Hoffs/omnisharp-extended-lsp.nvim",
		lazy = true,
	},

	-- LSP
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			{ "mason-org/mason-lspconfig.nvim", opts = {} },
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"saghen/blink.cmp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local client = vim.lsp.get_client_by_id(event.data.client_id)

					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("grn", vim.lsp.buf.rename, "Rename")
					map("gra", vim.lsp.buf.code_action, "Code action", { "n", "x" })
					map("grD", vim.lsp.buf.declaration, "Declaration")
					if client and client.name == "omnisharp" then
						local omnisharp_extended = require("omnisharp_extended")
						map("grd", omnisharp_extended.lsp_definition, "Definition")
						map("gri", omnisharp_extended.lsp_implementation, "Implementation")
						map("grr", omnisharp_extended.lsp_references, "References")
					else
						map("grd", vim.lsp.buf.definition, "Definition")
						map("gri", vim.lsp.buf.implementation, "Implementation")
						map("grr", vim.lsp.buf.references, "References")
					end
					map("K", vim.lsp.buf.hover, "Hover")

					if client and client:supports_method("textDocument/documentHighlight", event.buf) then
						local group = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = group,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = group,
							callback = vim.lsp.buf.clear_references,
						})
					end

					if client and client:supports_method("textDocument/inlayHint", event.buf) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "Toggle inlay hints")
					end
				end,
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local servers = {
				lua_ls = {},
				gopls = {},
				clangd = {},
				html = {},
				cssls = {},
				ts_ls = {},
				svelte = {},
				angularls = {},
				emmet_ls = {},
				pyright = {},
				omnisharp = {
					settings = {
						RoslynExtensionsOptions = {
							EnableDecompilationSupport = true,
						},
					},
				},
			}
			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(servers),
			})

			require("mason-tool-installer").setup({
				ensure_installed = {
					"stylua",
					"gofumpt",
					"goimports",
					"prettierd",
					"black",
				},
			})

			for name, config in pairs(servers) do
				config.capabilities = capabilities
				vim.lsp.config(name, config)
				vim.lsp.enable(name)
			end

			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						workspace = {
							checkThirdParty = false,
							library = vim.api.nvim_get_runtime_file("", true),
						},
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})

			vim.lsp.enable("lua_ls")
		end,
	},

	-- Formatting
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				local disable_filetypes = {
					c = true,
					cpp = true,
				}

				if disable_filetypes[vim.bo[bufnr].filetype] then
					return nil
				end

				return {
					timeout_ms = 1000,
					lsp_format = "fallback",
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "goimports", "gofumpt" },
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				svelte = { "prettierd" },
				html = { "prettierd" },
				css = { "prettierd" },
				json = { "prettierd" },
				yaml = { "prettierd" },
				python = { "black" },
			},
		},
	},

	-- Tree-sitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local parsers = {
				"bash",
				"c",
				"cpp",
				"go",
				"gomod",
				"gosum",
				"html",
				"css",
				"javascript",
				"typescript",
				"tsx",
				"svelte",
				"c_sharp",
				"python",
				"json",
				"yaml",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
			}

			require("nvim-treesitter").install(parsers)

			vim.api.nvim_create_autocmd("FileType", {
				pattern = parsers,
				callback = function()
					pcall(vim.treesitter.start)
				end,
			})
		end,
	},

	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
}, {
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
