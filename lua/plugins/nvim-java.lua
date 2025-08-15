return {
  "mfussenegger/nvim-jdtls",

  ft = { "java" },
  config = function()
    local jdtls = require("jdtls")

    -- Detect top-level project root (parent pom w/ <modules>, gradle settings, else .git)
    local function has_modules_pom(pom_path)
      if vim.fn.filereadable(pom_path) ~= 1 then return false end
      for _, line in ipairs(vim.fn.readfile(pom_path, "", 300)) do
        if line:find("<modules>") then return true end
      end
      return false
    end

    local function find_top_root(start_path)
      local dir = vim.fs.dirname(start_path)
      while dir and dir ~= "" and dir ~= "/" do
        if has_modules_pom(dir .. "/pom.xml")
            or vim.fn.filereadable(dir .. "/settings.gradle") == 1
            or vim.fn.filereadable(dir .. "/settings.gradle.kts") == 1
            or vim.fn.isdirectory(dir .. "/.git") == 1
        then
          return dir
        end
        dir = vim.fs.dirname(dir)
      end
      return vim.fs.dirname(start_path)
    end

    local function start_or_attach_top_root()
      local buf_path = vim.api.nvim_buf_get_name(0)
      if buf_path == "" then return end


      local root_dir = find_top_root(buf_path)
      if not root_dir or root_dir == "" then return end

      -- One workspace per repo/root (hash to avoid collisions)
      local ws_name = (vim.fn.fnamemodify(root_dir, ":t") or "jdt")
      local ws_hash = vim.fn.sha256(root_dir):sub(1, 8)

      local workspace_dir = string.format("%s/jdtls-workspaces/%s_%s", vim.fn.stdpath("data"), ws_name, ws_hash)
      vim.fn.mkdir(workspace_dir, "p")

      -- Lombok
      local lombok_jar = "/home/aleksi/.local/share/lombok/lombok.jar"

      -- Debug + Test bundles from Mason
      local mason = vim.fn.stdpath("data") .. "/mason"
      local bundles = {}
      local dbg = vim.fn.glob(mason ..
        "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar")
      if dbg ~= "" then table.insert(bundles, dbg) end
      local test_jars = vim.split(vim.fn.glob(mason .. "/packages/java-test/extension/server/*.jar"), "\n",
        { trimempty = true })
      for _, jar in ipairs(test_jars) do
        if jar ~= "" then table.insert(bundles, jar) end
      end

      -- Build JDTLS cmd (single server for the whole repo)
      local cmd = { "jdtls" }

      if vim.fn.filereadable(lombok_jar) == 1 then
        table.insert(cmd, "--jvm-arg=-javaagent:" .. lombok_jar)
        table.insert(cmd, "--jvm-arg=--add-opens=java.base/java.util=ALL-UNNAMED")
        table.insert(cmd, "--jvm-arg=--add-opens=java.base/java.lang=ALL-UNNAMED")
      end
      -- (Optional heap if the repo is big)
      -- table.insert(cmd, "--jvm-arg=-Xms1G")

      table.insert(cmd, "-data")
      table.insert(cmd, workspace_dir)

      local prefs_uri = vim.uri_from_fname(vim.fn.expand("~/.config/nvim/rule/java-settings.prefs"))

      local settings = {
        java = {
          signatureHelp = { enabled = true },
          contentProvider = { preferred = "fernflower" },
          referencesCodeLens = { enabled = true },
          inlayHints = { parameterNames = { enabled = "all" } },
          completion = {

            favoriteStaticMembers = {
              "org.hamcrest.MatcherAssert.assertThat",
              "org.hamcrest.Matchers.*",
              "org.junit.jupiter.api.Assertions.*",
              "org.mockito.Mockito.*",
            },
            guessMethodArguments = true,

          },

          sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
        },
        ["java.settings.url"] = prefs_uri,
      }

      local on_attach = function(_, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, opts)
        -- Tests
        vim.keymap.set("n", "<leader>tm", jdtls.test_nearest_method, opts)
        vim.keymap.set("n", "<leader>tc", jdtls.test_class, opts)
        -- DAP
        require("jdtls.setup").add_commands()

        jdtls.setup_dap({ hotcodereplace = "auto" })
      end

      local config = {
        cmd = cmd,
        root_dir = root_dir, -- top-level root
        on_attach = on_attach,

        settings = settings,
        init_options = { bundles = bundles },
        workspace_folders = { { name = ws_name, uri = vim.uri_from_fname(root_dir) } },
      }


      -- Start only once per root; subsequent buffers just attach
      vim.g._jdtls_started = vim.g._jdtls_started or {}
      if not vim.g._jdtls_started[root_dir] then
        jdtls.start_or_attach(config)
        vim.g._jdtls_started[root_dir] = true
      else
        jdtls.attach()
      end
    end

    -- Run for every Java buffer (ensures attach in all modules)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      group = vim.api.nvim_create_augroup("JdtlsSingleWorkspace", { clear = true }),
      callback = start_or_attach_top_root,
    })
  end,
}
