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
      jdtls = { enable = true, version = "1.46.1" },
    })


    local function disable_semantic_tokens(client)
      if client.server_capabilities.semanticTokensProvider then
        client.server_capabilities.semanticTokensProvider = nil
      end
    end


    require("lspconfig").jdtls.setup({
      settings = {
        ["java.settings.url"] = "file://" .. vim.fn.expand("~/.config/nvim/rule/java-settings.prefs"),
      },
      on_attach = function(client, bufnr)
        disable_semantic_tokens(client)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
        end

        map("n", "<leader>tr", function() require("java").test.view_last_report() end, "Java: Test Report")

        -- External Maven command
        vim.keymap.set("n", "<A-f>", ":!mvn spotless:apply<CR>", { noremap = true, silent = true })
      end,
    })
  end,

}
