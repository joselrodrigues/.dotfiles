return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = true,
  keys = {
    { "<leader>a", nil, desc = "AI/Claude Code" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    {
      "<leader>as",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file",
      ft = { "NvimTree", "neo-tree", "oil", "minifiles" },
    },
    -- Diff management with safer cleanup
    { "<leader>aa", function()
        vim.cmd("ClaudeCodeDiffAccept")
        -- Safer cleanup after accepting
        vim.defer_fn(function()
          pcall(vim.cmd, "ClaudeCleanBuffers")
          vim.defer_fn(function()
            pcall(vim.cmd, "ClaudeCodeFocus")
          end, 100)
        end, 500)
      end, desc = "Accept diff and reopen Claude" },
    { "<leader>ad", function()
        vim.cmd("ClaudeCodeDiffDeny") 
        -- Safer cleanup after denying
        vim.defer_fn(function()
          pcall(vim.cmd, "ClaudeCleanBuffers")
          vim.defer_fn(function()
            pcall(vim.cmd, "ClaudeCodeFocus")
          end, 100)
        end, 500)
      end, desc = "Deny diff and reopen Claude" },
    -- Custom toggle key
    { "<leader>ax", "<cmd>ClaudeCleanBuffers<cr>", desc = "Clean Claude buffers" },
  },
  opts = {
    -- Server Configuration
    port_range = { min = 10000, max = 65535 },
    auto_start = true,
    log_level = "info",
    terminal_cmd = nil,
    
    -- Selection Tracking
    track_selection = true,
    visual_demotion_delay_ms = 50,
    
    -- Terminal Configuration for Floating Window
    terminal = {
      provider = "snacks",
      auto_close = true,
      
      -- Snacks floating window configuration
      ---@module "snacks"
      ---@type snacks.win.Config|{}
      snacks_win_opts = {
        position = "float",
        width = 0.75,
        height = 0.75,
        border = "rounded",
        backdrop = 40,
        keys = {
          claude_hide = {
            "<Esc><Esc>",
            function(self)
              self:hide()
            end,
            mode = { "t", "n" },
            desc = "Hide Claude Code",
          },
        },
      },
    },
    
    -- Diff Integration - CLAVE: keep_terminal_focus = false permite ver el diff
    diff_opts = {
      auto_close_on_accept = true,
      vertical_split = true,
      open_in_current_tab = true,
      keep_terminal_focus = false, -- FALSE = el foco se mueve al diff, permitiendo verlo
    },
  },
  
  config = function(_, opts)
    require("claudecode").setup(opts)
    
    -- Command to safely clean Claude buffers
    vim.api.nvim_create_user_command("ClaudeCleanBuffers", function()
      local cleaned = 0
      local current_buf = vim.api.nvim_get_current_buf()
      
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and buf ~= current_buf then
          local buf_name = vim.api.nvim_buf_get_name(buf)
          -- More specific pattern and avoid deleting active buffers
          if buf_name:match("Claude Code.*") and not vim.api.nvim_buf_get_option(buf, 'modified') then
            -- Check if buffer is not in use by any window
            local in_use = false
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              if vim.api.nvim_win_get_buf(win) == buf then
                in_use = true
                break
              end
            end
            
            if not in_use then
              local ok = pcall(vim.api.nvim_buf_delete, buf, { force = false })
              if ok then
                cleaned = cleaned + 1
              end
            end
          end
        end
      end
      
      if cleaned > 0 then
        vim.notify("Cleaned " .. cleaned .. " Claude buffers", vim.log.levels.INFO)
      end
    end, { desc = "Safely clean Claude Code buffers" })
    
    -- Simple auto-hide when Claude diff appears
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*",
      callback = function()
        local buf_name = vim.api.nvim_buf_get_name(0)
        
        -- Only trigger on Claude diff buffers
        if buf_name:match("proposed%)$") then
          vim.notify("Claude diff opened - Use <leader>aa to accept or <leader>ad to deny", vim.log.levels.INFO)
          
          -- Try to hide Claude floating window
          vim.schedule(function()
            pcall(function()
              local terminal_ok, terminal_module = pcall(require, "claudecode.terminal")
              if terminal_ok then
                local active_bufnr = terminal_module.get_active_terminal_bufnr()
                if active_bufnr then
                  local terminal_provider = require("claudecode.terminal.snacks")
                  local terminal_instance = terminal_provider._get_terminal_for_test()
                  if terminal_instance and terminal_instance.hide then
                    terminal_instance:hide()
                  end
                end
              end
            end)
          end)
        end
      end,
    })
  end,
}
