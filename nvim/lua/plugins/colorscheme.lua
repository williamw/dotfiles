return {
  -- Configure monokai-pro theme
  {
    "loctvl842/monokai-pro.nvim",
    opts = {
      filter = "spectrum", -- classic | octagon | pro | machine | ristretto | spectrum
      transparent_background = false,
      terminal_colors = true,
      devicons = true,
    },
  },

  -- Configure LazyVim to load monokai-pro
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "monokai-pro",
    },
  },
}
