-- Versión con debug
return {
  "vuki656/package-info.nvim",
  ft = "json",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("package-info").setup({
      autostart = true,
      package_manager = "npm",
      hide_unstable_versions = true,
      hide_up_to_date = false,
      notifications = true,
      icons = {
        enable = true,
      },
    })
  end,
  keys = {
    { "<leader>cps", "<cmd>lua require('package-info').show()<cr>", desc = "Show versions" },
    { "<leader>cph", "<cmd>lua require('package-info').hide()<cr>", desc = "Hide versions" },
    { "<leader>cpt", "<cmd>lua require('package-info').toggle()<cr>", desc = "Toggle versions" },
    { "<leader>cpu", "<cmd>lua require('package-info').update()<cr>", desc = "Update package" },
    { "<leader>cpd", "<cmd>lua require('package-info').delete()<cr>", desc = "Delete package" },
    { "<leader>cpi", "<cmd>lua require('package-info').install()<cr>", desc = "Install package" },
    { "<leader>cpc", "<cmd>lua require('package-info').change_version()<cr>", desc = "Change version" },
  },
}
