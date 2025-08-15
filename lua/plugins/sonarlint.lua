return {
  {
    "https://gitlab.com/schrieveslaach/sonarlint.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Prevent multiple SonarLint instances
      for _, client in ipairs(vim.lsp.get_clients()) do
        if client.name == "sonarlint" then
          return -- Already running, skip setup
        end
      end


      local mason_path = vim.fn.stdpath("data")

      local analyzer_jar = vim.fs.joinpath(
        mason_path,

        "mason",
        "packages",
        "sonarlint-language-server",
        "extension",
        "analyzers",
        "sonarjava.jar"
      )

      require("sonarlint").setup({
        server = {
          cmd = {
            "sonarlint-language-server",
            "-stdio",
            "-analyzers",
            analyzer_jar,
          },
        },
        filetypes = { "java" },
        settings = {
          sonarlint = {
            rules = {

              ["java:*"] = { level = "on" },
            },
          },
        },
        autostart = true,

      })
    end,

  },

}
