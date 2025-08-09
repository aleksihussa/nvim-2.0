return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local fzf = require("fzf-lua")

    fzf.setup({
      fzf_opts = {
        ["--layout"] = "default",
        ["--info"]   = "inline",
      },
      winopts = {
        height = 0.85,
        width  = 0.80,
        preview = {
          vertical = "up:45%",
          scrollchar = "┃",
        },
        keymap = {
          builtin = {
            ["<C-j>"] = "preview-down",
            ["<C-k>"] = "preview-up",
            ["<C-d>"] = "preview-page-down",
            ["<C-u>"] = "preview-page-up",
          },
          fzf = {
            ["ctrl-j"] = "down",
            ["ctrl-k"] = "up",
            ["ctrl-d"] = "page-down",
            ["ctrl-u"] = "page-up",
          },
        },
      },
    })

    -- Keymaps
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { desc = desc, noremap = true, silent = true })
    end

    map("n", "<leader>ff", fzf.files, "Find files")
    map("n", "<leader>fp", fzf.git_files, "Git files")
    map("n", "<leader>fg", fzf.live_grep, "Live grep")
    map("n", "<leader>fb", fzf.buffers, "List buffers")
    map("n", "<leader>fh", fzf.help_tags, "Help tags search")
  end,
}
