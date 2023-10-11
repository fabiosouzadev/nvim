-- vim.opt.list = true
-- vim.opt.listchars:append 'space:⋅'
-- vim.opt.listchars:append 'eol:↴'
return {
	exclude = {
		filetypes = {
			"help",
			"terminal",
			"lazy",
			"lspinfo",
			"TelescopePrompt",
			"TelescopeResults",
			"mason",
			"nvdash",
			"nvcheatsheet",
			"NvimTree",
			"Trouble",
			"startify",
			"dashboard",
			"notify",
			"toggleterm",
			"alpha",
			"neo-tree",
			"",
		},
		buftypes = { "terminal", "nofile" },
	},
	-- show_trailing_blankline_indent = false,
	-- show_first_indent_level = false,
	-- space_char_blankline = ' ',
	-- show_current_context_start = true,
}
