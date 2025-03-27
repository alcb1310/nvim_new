local M = {
	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ -- If encountering errors, see telescope-fzf-native README for installation instructions
				"nvim-telescope/telescope-fzf-native.nvim",

				-- `build` is used to run some command when the plugin is installed/updated.
				-- This is only run then, not every time Neovim starts up.
				build = "make",

				-- `cond` is a condition used to determine whether this plugin should be
				-- installed and loaded.
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },

			-- Useful for getting pretty icons, but requires a Nerd Font.
			{ "echasnovski/mini.icons", opts = {} },
		},
		config = function()
			local actions = require("telescope.actions")
			local open_with_trouble = require("trouble.sources.telescope").open

			-- Use this to add more results without clearing the trouble list
			local add_to_trouble = require("trouble.sources.telescope").add

			local telescope = require("telescope")
			telescope.setup({
				mappings = {
					i = { ["<c-t>"] = open_with_trouble },
					n = { ["<c-t>"] = open_with_trouble },
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			-- Enable Telescope extensions if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			-- See `:help telescope.builtin`
			local builtin = require("telescope.builtin")
			local ivy = require("telescope.themes").get_ivy()

			vim.keymap.set("n", "<leader>sh", function()
				builtin.help_tags(ivy)
			end, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", function()
				builtin.keymaps(ivy)
			end, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", function()
				builtin.find_files(ivy)
			end, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", function()
				builtin.builtin(ivy)
			end, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sw", function()
				builtin.grep_string(ivy)
			end, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", function()
				builtin.live_grep(ivy)
			end, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", function()
				builtin.diagnostics(ivy)
			end, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", function()
				builtin.resume(ivy)
			end, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", function()
				builtin.oldfiles(ivy)
			end, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader>sb", function()
				builtin.buffers(ivy)
			end, { desc = "[ ] Find existing buffers" })

			-- Slightly advanced example of overriding default behavior and theme
			vim.keymap.set("n", "<leader>/", function()
				-- You can pass additional configuration to Telescope to change the theme, layout, etc.
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			-- It's also possible to pass additional configuration options.
			--  See `:help telescope.builtin.live_grep()` for information about particular keys
			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })

			-- Shortcut for searching your Neovim configuration files
			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })
		end,
	},
}

return M
