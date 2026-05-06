return {
  -- add monokai
  { "tanvirtin/monokai.nvim" },

  -- Configure LazyVim to load monokai
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "monokai",
    },
  },
}
