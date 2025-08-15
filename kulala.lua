return {
  "mistweaverco/kulala.nvim",
  keys = {
    -- Request execution
    { "<leader>Rs", desc = "Send request" },
    { "<leader>Ra", desc = "Send all requests" },
    { "<leader>Rr", desc = "Replay last request" },
    { "<C-c>", desc = "Cancel request", ft = { "http", "rest" } },
    
    -- UI and navigation
    { "<leader>Ro", desc = "Open Kulala UI" },
    { "<leader>Rb", desc = "Open scratchpad" },
    { "<leader>Rf", desc = "Find request" },
    
    -- Environment and auth
    { "<leader>Re", desc = "Choose environment" },
    { "<leader>Ru", desc = "Manage auth" },
  },
  ft = { "http", "rest" },
  opts = {
    -- Enable global keymaps
    global_keymaps = true,
    global_keymaps_prefix = "<leader>R",
    
    -- LSP and formatting support
    lsp = {
      enabled = true,
    },
    
    -- UI configuration
    ui = {
      enabled = true,
      show_headers = true,
      show_body = true,
    },
    
    -- Request execution settings
    request = {
      timeout = 30000, -- 30 seconds
    },
  },
}