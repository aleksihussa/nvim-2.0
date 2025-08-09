return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    opts = {
      winopts = {
        height = 0.85,
        width = 0.80,
        preview = { layout = "vertical" },
      },
      fzf_opts = {
        ["--layout"] = "reverse-list",
      },
      files = {
        prompt = "Files❯ ",
        git_icons = true,
      },
      grep = {
        prompt = "Rg❯ ",
        git_icons = true,
      },
    },
  },
}
