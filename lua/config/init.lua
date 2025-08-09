-- 0) Leaders ASAP
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- 1) Core options ONLY (no colorscheme, no plugin calls)
pcall(require, "config.options")

-- 2) Bootstrap + prepend lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- 3) Lazy setup (plugins)
require("lazy").setup({
  spec = { { import = "plugins" } },
  defaults = { lazy = false, version = nil },
  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = false, notify = false }, -- <- silence updates
})

-- 4) Set theme
pcall(vim.cmd.colorscheme, "catppuccin")

-- 5) Rest
for _, mod in ipairs({ "config.autocmds", "config.keymaps" }) do
  local ok, err = pcall(require, mod)
  if not ok then vim.notify("Error loading " .. mod .. "\n\n" .. err, vim.log.levels.ERROR) end
end
