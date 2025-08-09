return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",

  opts = {
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = false,
    enable_diagnostics = false,
    filesystem = {

      follow_current_file = { enabled = true },

      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = true,
      },
      hijack_netrw_behavior = "open_default",
    },
    window = {
      position = "left",
      width = 30,         -- starting width
      auto_resize = true, -- auto-fit to longest filename/path

    },
    default_component_configs = {
      indent = { padding = 0 },
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "",
        default = "󰈚",
      },
    },
  },
  keys = {
    { "<leader>n", "<cmd>Neotree toggle<cr>", desc = "Open & focus Neo-tree" },
  },
}
