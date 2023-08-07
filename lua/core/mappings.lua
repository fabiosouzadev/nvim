--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",
local M = {}

M.general = {
	n = {
		-- disable arrow keys cause im learning vim ;)
		["<Up>"] = { "<Nop>", "Disable up" },
		["<Down>"] = { "<Nop>", "Disable down" },
		["<Left>"] = { "<Nop>", "Disable left" },
		["<Right>"] = { "<Nop>", "Disable right" },
		-- ["<leader>e"] = { ':vsplit %<cr>"', "Edit configuration" },
		["<leader>s"] = { "<Cmd>:source $MYVIMRC<CR>", "Reload Config" },

		-- Window
		-- Split
		["<c-w>s"] = { ":split<cr>", "Split Horrizontal" },
		["<c-w>v"] = { ":vsplit<cr>", "Split Vertical" },
		["<c-w>c"] = { ":close<cr>", "Close Split" },
		["<c-w>n"] = { "<C-w>n", "Blank split -h " },
		["<c-w>q"] = { "<C-w>q", "Close this pane" },
		["<c-w>o"] = { "<C-w>o", "Close other panes" },
		["<c-w>r"] = { "<C-w>r", "Rotate Pane" },
		["<c-w>x"] = { "<C-w>x", "exchange current window with next one" },

		-- Resize
		["<c-w>j"] = { ":resize -2<cr>", ":resize -2<cr>" },
		["<c-w>k"] = { ":resize +2<cr>", ":resize +2<cr>" },
		["<c-w>h"] = { ":vertical resize -2<cr>", ":vertical resize -2<cr>" },
		["<c-w>l"] = { ":vertical resize +2<cr>", ":vertical resize +2<cr>" },
	},
}

M.barbar = {
	plugin = true,
	n = {
		-- cycle through buffers
		["<tab>"] = { "<Cmd>BufferNext<CR>", "Goto next buffer" },
		["<S-tab>"] = { "<Cmd>BufferPrevious<CR>", "Goto prev buffer" },
		-- cycle through buffers
		["<leader>."] = { "<Cmd>BufferMoveNext<CR>", "Move buffer forward" },
		["<leader>,"] = { "<Cmd>BufferMovePrevious<CR>", "Move buffer back" },
		--  Pin/unpin buffer
		["<leader>bp"] = { "<Cmd>BufferPin<CR>", "Pin/Unpin buffer" },
		-- close buffer + hide terminal buffer
		["<leader>x"] = { "<Cmd>BufferClose<CR>", "Close buffer" },
	},
}

M.bufferline = {
	plugin = true,
	n = {
		-- cycle through buffers
		["<tab>"] = { "<Cmd>BufferLineCycleNext<CR>", "Goto next buffer" },
		["<S-tab>"] = { "<Cmd>BufferLineCyclePrev<CR>", "Goto prev buffer" },
		-- cycle through buffers
		["<leader>."] = { "<Cmd>BufferLineMoveNext<CR>", "Move buffer forward" },
		["<leader>,"] = { "<Cmd>BufferLineMovePrev<CR>", "Move buffer back" },
		--  Pin/unpin buffer
		["<leader>bp"] = { "<Cmd>BufferLineTogglePin<CR>", "Pin/Unpin buffer" },
		-- close buffer + hide terminal buffer
		["<leader>x"] = { "<Cmd>bdelete<CR>", "Close buffer" },
	},
}

M.lspconfig = {
	plugin = true,
	-- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions
	n = {
		["K"] = { "<CMD>lua vim.lsp.buf.hover()<CR>", "LSP hover" },
		["gD"] = { "<CMD>lua vim.lsp.buf.declaration()<CR>", "LSP declaration" },
		["gd"] = { "<CMD>lua vim.lsp.buf.definition()<CR>", "LSP definition" },
		["gi"] = { "<CMD>lua vim.lsp.buf.implementation()<CR>", "LSP implementation" },
		["gr"] = { "<CMD>lua vim.lsp.buf.references()<CR>", "LSP references" },
		["<C-K>"] = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "LSP signature help" },
		["<leader>D"] = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "LSP definition type" },
		["<leader>rn"] = { "<cmd>lua vim.lsp.buf.rename()<CR>", "LSP rename" },
		["<leader>ca"] = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "LSP code action" },
		["<leader>f"] = { '<cmd>lua vim.diagnostic.open_float { border = "rounded" }<CR>', "Floating diagnostic" },
		["[d"] = { '<cmd>lua vim.diagnostic.goto_prev { float = { border = "rounded" } } <CR>', "Goto prev" },
		["]d"] = { '<cmd>lua vim.diagnostic.goto_next { float = { border = "rounded" } } <CR>', "Goto next" },
		["<leader>q"] = { "<cmd>lua vim.diagnostic.setloclist()<CR>", "Diagnostic setloclist" },
		["<leader>fm"] = { "<cmd>lua vim.lsp.buf.format { async = true } <CR>", "LSP formatting" },

		-- Workspaces
		["<leader>wa"] = { "<cmd>lua vim.lsp.buf.add_workspace_folder() <CR>", "Add workspace folder" },
		["<leader>wr"] = { "<cmd>lua vim.lsp.buf.remove_workspace_folder() <CR>", "Remove workspace folder" },
		["<leader>wl"] = {
			"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders())) <CR>",
			"List workspace folders",
		},

		--- :Telescope LSP --
		["<leader>flr"] = { "<cmd>Telescope lsp_references <cr>", "Lsp references" },
		["<leader>fld"] = { "<cmd>Telescope lsp_definitions <cr>", "Lsp definitions" },
		["<leader>fli"] = { "<cmd>Telescope lsp_implementations <cr>", "Lsp Implementations" },
		["<leader>flt"] = { "<cmd>Telescope lsp_type_definitions <cr>", "Lsp Type Definitions" },
	},

	v = {
		["<leader>ca"] = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "LSP code action" },
	},
}

M.jdtls = {
	n = {
		["<leader>ji"] = { "<cmd>lua require'jdtls'.organize_imports()<cr>", "Organize Imports" },
		["<leader>jv"] = { "<cmd>lua require('jdtls').extract_variable()<cr>", "Extract Variable" },
		["<leader>jc"] = { "<cmd>lua require('jdtls').extract_constant()<cr>", "Extract Constant" },
		["<leader>jm"] = { "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", "Extract Method" },
		["<leader>jtc"] = { "<cmd>lua require'jdtls'.test_class()<cr>", "Test Class" },
		["<leader>jtm"] = { "<cmd>lua require'jdtls'.test_nearest_method()<cr>", "Teste Method" },
	},
    v = {
		["<leader>jv"] = { "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", "Extract Variable" },
		["<leader>jc"] = { "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", "Extract Constant" },
		["<leader>jm"] = { "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", "Extract Method" },
    },
}

M.lspsaga = {
	n = {
		["gp"] = { "<cmd>Lspsaga peek_definition<cr>", "Lspsaga Preview def" },
		["]e"] = { "<cmd>Lspsaga diagnostic_jump_next<cr>", "Go To Next Diagnostic" },
		["[e"] = { "<cmd>Lspsaga diagnostic_jump_prev<cr>", "Go To Previous Diagnostic" },
	},
}

M.dap = {
	n = {
		["<leader>db"] = {
			function()
				require("dap").toggle_breakpoint()
			end,
			"Toggle Breakpoint",
		},
		["<leader>dc"] = {
			function()
				require("dap").continue()
			end,
			"DAP Continue",
		},
		["<leader>dd"] = {
			function()
				require("dap").continue()
			end,
			"DAP Continue",
		},
		["<leader>di"] = {
			function()
				require("dap").step_into()
			end,
			"DAP Step Into",
		},
		["<leader>do"] = {
			function()
				require("dap").step_out()
			end,
			"DAP Step Out",
		},
		["<leader>dO"] = {
			function()
				require("dap").step_over()
			end,
			"DAP Step Over",
		},
		["<leader>dt"] = {
			function()
				require("dap").terminate()
			end,
			"DAP Terminate",
		},

		["<leader>du"] = {
			function()
				require("dapui").toggle({})
			end,
			"Dap UI",
		},
		["<leader>de"] = {
			function()
				require("dapui").eval()
			end,
			"Dap UI Eval",
		},
		["<leader>dh"] = {
			function()
				require("dapui").eval()
			end,
			"Dap UI Eval",
		},
		["<leader>dC"] = {
			function()
				require("dapui").close()
			end,
			"Dap UI Close",
		},

		["<leader>dw"] = {
			function()
				require("dapui").float_element("watches", { enter = true })
			end,
			"Dap UI Whatches",
		},
		["<leader>ds"] = {
			function()
				require("dapui").float_element("scopes", { enter = true })
			end,
			"Dap UI Scopes",
		},
		["<leader>dr"] = {
			function()
				require("dapui").float_element("repl", { enter = true })
			end,
			"DAP Step REPL",
		},
	},
	v = {
		["<leader>de"] = {
			function()
				require("dapui").eval()
			end,
			"Dap UI Eval",
		},
	},
}

M.nvimtree = {
	plugin = true,

	n = {
		-- toggle
		["<C-n>"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },

		-- focus
		["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "Focus nvimtree" },
	},
}

M.telescope = {
	plugin = true,

	n = {
		-- find
		["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "Find files" },
		["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "Find all" },
		["<leader>fb"] = { "<cmd> Telescope buffers <CR>", "Find buffers" },
		["<leader>fg"] = { "<cmd> Telescope live_grep <CR>", "Live grep" },
		["<leader>fh"] = { "<cmd> Telescope help_tags <CR>", "Help page" },
		["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "Find oldfiles" },
		["<leader>ft"] = { "<cmd> Telescope treesitter <CR>", "Find Treesitter" },
		["<leader>fz"] = { "<cmd> Telescope current_buffer_fuzzy_find <CR>", "Find in current buffer" },
		["<leader>ma"] = { "<cmd> Telescope marks <CR>", "Find bookmarks" },
		["<leader>f?"] = { "<cmd> Telescope keymaps <CR>", "Find keymaps" },

		-- git
		["<leader>fc"] = { "<cmd> Telescope git_commits <CR>", "Git commits" },
		["<leader>fs"] = { "<cmd> Telescope git_status <CR>", "Git status" },
		["<leader>fi"] = { "<cmd> Telescope git_files <CR>", "Git files" },

		-- pick a hidden term
		-- ["<leader>pt"] = { "<cmd> Telescope terms <CR>", "Pick hidden term" },

		-- theme switcher
		-- ["<leader>th"] = { "<cmd> Telescope colorscheme <CR>", "theme switcher" },
	},
}

M.blankline = {
	plugin = true,

	n = {
		["<leader>cc"] = {
			function()
				local ok, start = require("indent_blankline.utils").get_current_context(
					vim.g.indent_blankline_context_patterns,
					vim.g.indent_blankline_use_treesitter_scope
				)

				if ok then
					vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start, 0 })
					vim.cmd([[normal! _]])
				end
			end,

			"Jump to current context",
		},
	},
}

M.gitsigns = {
	plugin = true,

	n = {
		-- Navigation through hunks
		["]c"] = {
			function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					require("gitsigns").next_hunk()
				end)
				return "<Ignore>"
			end,
			"Jump to next hunk",
			opts = { expr = true },
		},

		["[c"] = {
			function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					require("gitsigns").prev_hunk()
				end)
				return "<Ignore>"
			end,
			"Jump to prev hunk",
			opts = { expr = true },
		},

		-- Actions
		["<leader>hr"] = {
			function()
				require("gitsigns").reset_hunk()
			end,
			"Reset hunk",
		},

		["<leader>hp"] = {
			function()
				require("gitsigns").preview_hunk()
			end,
			"Preview hunk",
		},

		["<leader>hi"] = {
			function()
				require("gitsigns").preview_hunk_inline()
			end,
			"Preview hunk inline",
		},

		["<leader>hb"] = {
			function()
				package.loaded.gitsigns.blame_line()
			end,
			"Blame line",
		},

		["<leader>htd"] = {
			function()
				require("gitsigns").toggle_deleted()
			end,
			"Toggle deleted",
		},

		["<leader>hd"] = {
			function()
				require("gitsigns").diffthis()
			end,
			"Diff this",
		},

		["<leader>hD"] = {
			function()
				require("gitsigns").diffthis("~")
			end,
			"Diff this",
		},
	},
}

M.harpoon = {
	n = {
		["<c-e>"] = { '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', "Harpoon Toogle Menu" },
	},
}

M.whichkey = {
	plugin = true,
	n = {
		["<leader>wK"] = {
			function()
				vim.cmd("WhichKey")
			end,
			"Which-key all keymaps",
		},
		["<leader>wk"] = {
			function()
				local input = vim.fn.input("WhichKey: ")
				vim.cmd("WhichKey " .. input)
			end,
			"Which-key query lookup",
		},
	},
}

return M
