return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.config").setup({
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "lua",
        "javascript",
        "html",
        "css",
        "python",
      },
    })
  end,
}
