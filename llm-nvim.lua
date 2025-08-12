return {
	"Kurama622/llm.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	cmd = { "LLMAppHandler" },
	keys = {
		{ "<leader>gc", desc = "Generate Commit Message", mode = "n" },
	},
	config = function()
		local tools = require("llm.tools")

		require("llm").setup({
			-- Your local endpoint configuration
			url = "",
			api_type = "openai",
			model = "claude-sonnet-4", -- Default model
			fetch_key = function()
				return "dummy" -- Some plugins require non-empty key even for local endpoints
			end,

			app_handler = {
				-- AI Commit Messages Configuration for lazygit
				CommitMsg = {
					handler = tools.flexi_handler,
					prompt = function()
						-- Get current branch name
						local branch = vim.fn.system("git branch --show-current"):gsub("\n", "")

						-- Get diff statistics and file names
						local diff_stat = vim.fn.system("git diff --staged --stat")
						local file_names = vim.fn.system("git diff --staged --name-status")

						-- Get actual diff, but check size first
						local diff_size = tonumber(vim.fn.system("git diff --staged --no-ext-diff | wc -c"))
						local diff_content = ""

						if diff_size and diff_size < 10000 then
							-- If diff is small enough (< 10KB), include full diff
							diff_content = vim.fn.system("git diff --no-ext-diff --staged")
						else
							-- For large diffs, show summary and first 50 lines of each file
							local files = vim.fn.systemlist("git diff --staged --name-only")
							diff_content = "LARGE DIFF - Showing summary and samples:\n\n"
							diff_content = diff_content .. diff_stat .. "\n\n"

							for _, file in ipairs(files) do
								if #files <= 5 then
									-- For few files, show more context
									local file_diff = vim.fn.system(
										"git diff --staged --no-ext-diff -- "
											.. vim.fn.shellescape(file)
											.. " | head -100"
									)
									diff_content = diff_content .. "File: " .. file .. "\n" .. file_diff .. "\n...\n\n"
								end
							end

							diff_content = diff_content .. "\nFiles changed:\n" .. file_names
						end

						return string.format(
							[[You are an expert at following the Conventional Commit specification. Given the git changes below, please generate a commit message for me:

Current branch: %s

1. First line: conventional commit format type(%s): concise description
   - Include the branch name in parentheses after the type
   - Use semantic types like feat, fix, docs, style, refactor, perf, test, chore, etc.
2. Optional bullet points if more context helps:
   - Keep the second line blank
   - Keep them short and direct
   - Focus on what changed
   - Always be terse
   - Don't overly explain
   - Drop any fluffy or formal language

Return ONLY the commit message - no introduction, no explanation, no quotes around it.

Examples (for a branch called "feature/auth"):
feat(feature/auth): add user auth system

- Add JWT tokens for API auth
- Handle token refresh for long sessions

fix(bugfix/memory): resolve memory leak in worker pool

- Clean up idle connections
- Add timeout for stale workers

Simple change example:
fix(docs/update): typo in README.md

Very important: 
- Do not respond with any of the examples
- Always use the actual branch name: %s
- Your message must be based off the changes provided below

Changes:
%s
]],
							branch,
							branch,
							branch,
							diff_content
						)
					end,

					opts = {
						-- Use your endpoint for chat completions
						url = "http://192.168.1.81:8150/cosmos/genai-gateway/v1/chat/completions",
						model = "claude-sonnet-4", -- Claude Sonnet 4 for commit messages
						api_type = "openai",
						fetch_key = function()
							return "" -- Empty key for local endpoint
						end,

						enter_flexible_window = true,
						apply_visual_selection = false,
						win_opts = {
							relative = "editor",
							position = "50%",
						},
						accept = {
							mapping = {
								mode = "n",
								keys = "<cr>",
							},
							action = function()
								local contents = vim.api.nvim_buf_get_lines(0, 0, -1, true)

								local cmd = string.format('!git commit -m "%s"', table.concat(contents, '" -m "'))
								cmd = (cmd:gsub(".", {
									["#"] = "\\#",
								}))

								vim.api.nvim_command(cmd)
								-- Optional: Open lazygit after commit (uncomment if desired)
								-- vim.schedule(function()
								--   require("snacks").lazygit()
								-- end)
								vim.notify("Commit created successfully!", vim.log.levels.INFO)
							end,
						},
					},
				},
			},

			-- Default options for all requests
			default_opts = {
				url = "http://192.168.1.81:8150/cosmos/genai-gateway/v1/chat/completions",
				model = "claude-sonnet-4",
				max_tokens = 500,
				temperature = 0.5,
				fetch_key = function()
					return "" -- Empty key for local endpoint
				end,
			},
		})

		-- Keymap for quick commit message generation
		vim.keymap.set("n", "<leader>gc", function()
			vim.cmd("LLMAppHandler CommitMsg")
		end, { desc = "Generate Commit Message" })
	end,
}
