local autocmd  = vim.api.nvim_create_autocmd
local augroup  = vim.api.nvim_create_augroup


local grp_edit   = augroup("EditTweaks",   { clear = true })
local grp_format = augroup("FormatOnSave", { clear = true })


autocmd("TextYankPost", {
  group = grp_edit,
  desc = "Briefly highlight on yank",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 1000 })
  end,
})

autocmd("BufWritePre", {
  group = grp_edit,
  pattern = "*",
  desc = "Trim trailing whitespace",
  command = [[keepjumps keeppatterns %s/\s\+$//e]],
})

autocmd("BufWritePre", {
  group = grp_edit,
  pattern = "*",
  desc = "Use Unix line endings",
  callback = function()

    vim.bo.fileformat = "unix"
  end,
})

autocmd("BufWritePre", {
  group = grp_edit,
  pattern = "*",
  desc = "Strip stray carriage returns inside lines",
  command = [[%s/\r//ge]],
})

autocmd("FileType", {
  group = grp_edit,
  pattern = { "xml", "html", "xhtml", "css", "scss", "yaml", "lua" },
  desc = "Two-space indentation",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2

  end,
})


autocmd("FileType", {
  group = grp_edit,
  pattern = { "gitcommit", "markdown", "text" },
  desc = "Wrap and spellcheck prose",
  callback = function()
    vim.opt_local.wrap = true

    vim.opt_local.spell = true
  end,
})

autocmd("BufWritePre", {

  group = grp_format,
  pattern = "*",
  desc = "LSP format on save (except Java, excluding ESLint)",
  callback = function(args)
    if vim.bo[args.buf].filetype == "java" then return end

    local format_clients = vim.lsp.get_clients({
      bufnr = args.buf,

      method = "textDocument/formatting",
    })

    local has_non_eslint = false
    for _, c in ipairs(format_clients) do
      if c.name ~= "eslint" then
        has_non_eslint = true
        break
      end
    end
    if not has_non_eslint then return end

    vim.lsp.buf.format({
      bufnr = args.buf,
      async = false,
      timeout_ms = 2000,
      filter = function(c) return c.name ~= "eslint" end,
    })
  end,
})

