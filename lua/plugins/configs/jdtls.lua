local M = {}

M.java_cmds = vim.api.nvim_create_augroup("java_cmds", { clear = true })

M.cache_vars = {}

M.get_jdtls_paths = function()
	if M.cache_vars.paths then
		return M.cache_vars.paths
	end

	local paths = {}

	local mason_registry = require("mason-registry")
	local jdtls_mason = mason_registry.get_package("jdtls")
	local jdtls_path = jdtls_mason:get_install_path()

	local SYSTEM
	if vim.fn.has("mac") then
		SYSTEM = "mac"
	elseif vim.fn.has("win32") then
		SYSTEM = "win"
	else
		SYSTEM = "linux"
	end

	paths.platform_config = jdtls_path .. "/config_" .. SYSTEM
	paths.lombok = jdtls_path .. "/lombok.jar"
	paths.launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

	M.cache_vars.paths = paths
	return paths
end

M.get_root_dir = function()
	return require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })
end

M.get_workspace = function()
	if M.cache_vars.paths.workspace_dir then
		return M.cache_vars.paths.workspace_dir
	end

	local workspace_path = vim.fn.stdpath("cache") .. "/nvim-jdtls"
	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
	local workspace_dir = workspace_path .. project_name

	M.cache_vars.paths.workspace_dir = workspace_dir
	return workspace_dir
end

M.get_bundles = function()
	if M.cache_vars.paths.bundles then
		return M.cache_vars.paths.bundles
	end

	local mason_registry = require("mason-registry")
	local java_debug = mason_registry.get_package("java-debug-adapter")
	local java_test = mason_registry.get_package("java-test")
	local java_debug_path = java_debug:get_install_path()
	local java_test_path = java_test:get_install_path()

	local bundles = {}

	vim.list_extend(
		bundles,
		vim.split(vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n")
	)
	vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar"), "\n"))

	M.cache_vars.paths.bundles = bundles
	return bundles
end

M.get_extendedClientCapabilities = function()
	local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
	extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
	return extendedClientCapabilities
end

M.build_cmd = function()
	local paths = M.get_jdtls_paths()
	-- The command that starts the language server
	-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
	local cmd = {

		"java", -- or '/path/to/java17_or_newer/bin/java'
		-- depends on if `java` is in your $PATH env variable and if it points to the right version.

		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-javaagent:" .. paths.lombok,
		"-Xmx1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",

		"-jar",
		paths.launcher_jar,
		-- Must point to the                                                     Change this to
		-- eclipse.jdt.ls installation                                           the actual version

		"-configuration",
		paths.platform_config,

		-- Must point to the                      Change to one of `linux`, `win` or `mac`
		-- eclipse.jdt.ls installation            Depending on your system.

		-- See `data directory configuration` section in the README
		"-data",
		M.get_workspace(),
	}
	return cmd
end

M.get_java_settings = function()
	return {
		java = {
			autobuild = { enabled = false },
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
			saveActions = {
				organizeImports = true,
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
			codeGeneration = {
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
				},
				hashCodeEquals = {
					useJava7Objects = true,
				},
				useBlocks = true,
			},
			eclipse = {
				downloadSources = true,
			},
			configuration = {
				updateBuildConfiguration = "interactive",
				-- NOTE: Add the available runtimes here
				-- https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
				-- runtimes = {
				--   {
				--     name = "JavaSE-18",
				--     path = "~/.sdkman/candidates/java/18.0.2-sem",
				--   },
				-- },
			},
			maven = {
				downloadSources = true,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referencesCodeLens = {
				enabled = true,
			},
			references = {
				includeDecompiledSources = true,
			},
			inlayHints = {
				parameterNames = {
					enabled = "all", -- literals, all, none
				},
			},
			format = {
				enabled = false,
			},
			-- NOTE: We can set the formatter to use different styles
			-- format = {
			--   enabled = true,
			--   settings = {
			--     url = vim.fn.stdpath "config" .. "/lang-servers/intellij-java-google-style.xml",
			--     profile = "GoogleStyle",
			--   },
			-- },
			completion = {
				favoriteStaticMembers = {
					"org.hamcrest.MatcherAssert.assertThat",
					"org.hamcrest.Matchers.*",
					"org.hamcrest.CoreMatchers.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
					"org.mockito.Mockito.*",
				},
				filteredTypes = {
					"com.sun.*",
					"io.micrometer.shaded.*",
					"java.awt.*",
					"jdk.*",
					"sun.*",
				},
			},
		},
	}
end

M.enable_codelens = function(bufnr)
	pcall(vim.lsp.codelens.refresh)

	vim.api.nvim_create_autocmd("BufWritePost", {
		buffer = bufnr,
		group = M.java_cmds,
		desc = "refresh codelens",
		callback = function()
			pcall(vim.lsp.codelens.refresh)
		end,
	})
end

M.enable_debugger = function(bufnr)
	require("jdtls").setup_dap({ hotcodereplace = "auto" })
	require("jdtls.dap").setup_dap_main_class_configs()
	require("core.utils").load_mappings("jdtls", { buffer = bufnr })
end

M.jdtls_on_attach = function(_, bufnr)
	M.enable_debugger(bufnr)
	-- M.enable_codelens(bufnr)

	-- debugger
	require("jdtls.setup").add_commands()
	require("lspkind").init()
	require("lspsaga").init_lsp_saga()

	-- codelens
	vim.api.nvim_create_autocmd("BufWritePost", {
		pattern = { "*.java" },
		desc = "refresh codelens",
		callback = function()
			pcall(vim.lsp.codelens.refresh)
		end,
	})
end

M.get_capabilities = function()
	local capabilities = require("plugins.configs.lspconfig").lsp_capabilites()
	return capabilities
end

M.setup = function()
	local jdtls_ok, jdtls = pcall(require, "jdtls")
	if not jdtls_ok then
		print("JDTLS not found, install with `:LspInstall jdtls`")
		return
	end
	-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
	local config = {
		cmd = M.build_cmd(),

		-- This is the default if not provided, you can remove it. Or adjust as needed.
		-- One dedicated LSP server & client will be started per unique root_dir
		root_dir = M.get_root_dir(),

		flags = {
			allow_incremental_sync = true,
			debounce_text_changes = 150,
			server_side_fuzzy_completion = true,
		},

		-- Here you can configure eclipse.jdt.ls specific settings
		-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
		-- for a list of options
		settings = M.get_java_settings(),

		-- Language server `initializationOptions`
		-- You need to extend the `bundles` with paths to jar files
		-- if you want to use additional eclipse.jdt.ls plugins.
		--
		-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
		--
		-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
		init_options = {
			bundles = M.get_bundles(),
			extendedClientCapabilities = M.get_extendedClientCapabilities(),
		},

		on_attach = M.jdtls_on_attach,
		capabilities = M.get_capabilities(),
	}
	-- This starts a new client & server,
	-- or attaches to an existing client & server depending on the `root_dir`.
	jdtls.start_or_attach(config)
end

return M
