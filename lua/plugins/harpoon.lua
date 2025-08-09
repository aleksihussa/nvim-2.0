return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      local grp = vim.api.nvim_create_augroup("HarpoonKeymaps", { clear = true })
      vim.api.nvim_create_autocmd("BufEnter", {
        group = grp,
        callback = function(args)
          if vim.bo[args.buf].buftype ~= "" then return end
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = args.buf, silent = true, desc = desc })
          end

          map("<leader>e", function() harpoon:list():add() end, "Harpoon add")
          map("<leader>o", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, "Harpoon menu")
          map("<C-n>", function() harpoon:list():prev() end, "Harpoon prev")
          map("<C-m>", function() harpoon:list():next() end, "Harpoon next")
        end,
      })
    end,
  }
}
