return {
  {
    "alexghergh/nvim-tmux-navigation",
    event = "VeryLazy",
    config = function()
      local nav = require("nvim-tmux-navigation")
      nav.setup({ disable_when_zoomed = true })

      local map = function(lhs, rhs)
        vim.keymap.set({ "n", "t" }, lhs, rhs, { silent = true, desc = "Tmux navigate" })
      end

      map("<C-h>", nav.NvimTmuxNavigateLeft)
      map("<C-j>", nav.NvimTmuxNavigateDown)
      map("<C-k>", nav.NvimTmuxNavigateUp)
      map("<C-l>", nav.NvimTmuxNavigateRight)
    end,
  },
}
