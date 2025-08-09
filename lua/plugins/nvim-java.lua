return {
  "nvim-java/nvim-java",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "mfussenegger/nvim-jdtls",
    "mason-org/mason.nvim",
  },
  config = function()
    require("java").setup({
      jdk = { auto_install = false },
      jdtls = { version = "1.46.0" },
    })


    require("lspconfig").jdtls.setup({
      settings = {
        ["java.settings.url"] = "file://" .. vim.fn.expand("~/.config/nvim/rule/java-settings.prefs"),
      },
      on_attach = function(_, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
        end

        map("n", "<leader>tr", function() require("java").test.view_last_report() end, "Java: Test Report")
        map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
        map("n", "K", vim.lsp.buf.hover, "Hover")
        map("n", "<leader>a", vim.lsp.buf.code_action, "Code Action")
        map("n", "<leader>rr", vim.lsp.buf.references, "References")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")

        -- External Maven command
        vim.keymap.set("n", "<A-f>", ":!mvn spotless:apply<CR>", { noremap = true, silent = true })
      end,
    })
  end,

}
