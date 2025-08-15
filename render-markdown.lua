return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "echasnovski/mini.nvim", -- For mini.icons
  },
  ft = { "markdown", "norg", "rmd", "org" },
  opts = {
    -- Configuración básica
    render_modes = { "n", "c", "t" },
    anti_conceal = {
      enabled = true,
    },
    heading = {
      enabled = true,
      sign = true,
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
    },
    code = {
      enabled = true,
      sign = true,
      style = "full",
      position = "left",
      language_pad = 0,
      disable_background = { "diff" },
    },
    dash = {
      enabled = true,
      icon = "─",
      width = "full",
    },
    bullet = {
      enabled = true,
      icons = { "●", "○", "◆", "◇" },
    },
    checkbox = {
      enabled = true,
      unchecked = {
        icon = "󰄱 ",
        highlight = "RenderMarkdownUnchecked",
      },
      checked = {
        icon = "󰱒 ",
        highlight = "RenderMarkdownChecked",
      },
    },
    quote = {
      enabled = true,
      icon = "▋",
      repeat_linebreak = false,
    },
    pipe_table = {
      enabled = true,
      style = "full",
    },
    callout = {
      note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
      tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
      important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
      warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
      caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
    },
    link = {
      enabled = true,
      image = "󰥶 ",
      email = "󰀓 ",
      hyperlink = "󰌹 ",
      highlight = "RenderMarkdownLink",
    },
    sign = {
      enabled = true,
      highlight = "RenderMarkdownSign",
    },
  },
  config = function(_, opts)
    require("render-markdown").setup(opts)
    
    -- Keymaps opcionales
    vim.keymap.set("n", "<leader>rm", ":RenderMarkdown toggle<CR>", { desc = "Toggle Render Markdown" })
  end,
}