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
			url = os.getenv("COSMOS_API") or "",
			api_type = "openai",
			model = "claude-opus-4", -- Default model
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
							[[You are an expert at following Conventional Commits and commitlint rules. Generate a commit message following these STRICT rules:

COMMITLINT RULES (MANDATORY):
- type-enum: ONLY use: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert
- scope-empty: MUST have a scope (never empty)
- type-case: type MUST be lowercase
- subject-case: subject MUST be lowercase
- subject-empty: subject MUST NOT be empty
- subject-full-stop: subject MUST NOT end with period
- header-max-length: first line MUST be ≤ 72 characters

FORMAT: type(scope): subject

Current branch: %s

SCOPE RULES:
- Use branch name as scope: %s
- If branch has prefixes like "feature/", "fix/", use the part after "/"
- Keep scope concise and lowercase

EXAMPLES:
feat(auth): add jwt token validation
fix(api): resolve cors headers issue  
docs(readme): update installation steps
test(user): add login validation tests

Body (optional):
- Leave blank line after header
- Use bullet points for multiple changes
- Keep concise and technical
- No fluff or formal language

STRICT REQUIREMENTS:
- Header ≤ 72 chars
- All lowercase except proper nouns
- No period at end of subject
- Must have scope
- Return ONLY the commit message

Current branch: %s
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
						url = os.getenv("COSMOS_API") .. "/chat/completions",
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
								local commit_msg = table.concat(contents, "\n")
								
								-- Escribir mensaje a archivo temporal y usar git commit -F
								local temp_file = vim.fn.tempname()
								vim.fn.writefile(vim.split(commit_msg, "\n"), temp_file)
								
								local result = vim.fn.system(string.format('git commit -F %s', temp_file))
								vim.fn.delete(temp_file)
								
								if vim.v.shell_error == 0 then
									vim.notify("Commit created successfully!", vim.log.levels.INFO)
									-- Abrir lazygit después del commit
									vim.schedule(function()
										require("snacks").lazygit()
									end)
								else
									vim.notify("Commit failed: " .. result, vim.log.levels.ERROR)
								end
							end,
						},
					},
				},
			},

			-- Default options for all requests
			default_opts = {
				url = os.getenv("COSMOS_API") .. "/chat/completions",
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
