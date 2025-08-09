local opt = vim.opt

local g = vim.g
local cmd = vim.cmd
local indent = 2

-- Encoding

opt.fileencoding = "utf-8"

opt.encoding = "utf-8"

-- Indentation
opt.autoindent = true
opt.expandtab = true
opt.shiftwidth = indent
opt.smartindent = true
opt.softtabstop = indent
opt.tabstop = indent
opt.shiftround = true

-- Search
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.wildignore = { "*/node_modules/*", "*/.git/*", "*/vendor/*" }
opt.wildmenu = true


-- UI
opt.cursorline = true
opt.clipboard = "unnamedplus"
opt.laststatus = 2
opt.list = true
opt.listchars = {
  tab = "┊ ",
  trail = "·",
  extends = "»",
  precedes = "«",
  nbsp = "×"

}
opt.cmdheight = 0
opt.mouse = "a"
opt.number = true
opt.scrolloff = 18
opt.sidescrolloff = 3
opt.signcolumn = "yes"
opt.splitbelow = true

opt.splitright = true
opt.wrap = false
opt.termguicolors = true

-- Backups
opt.backup = false
opt.swapfile = false

opt.writebackup = false

-- Completion
opt.completeopt = { "menu", "menuone", "noselect" }
opt.shortmess:append("c")
opt.showmode = true

-- Performance
opt.history = 100
opt.redrawtime = 1500
opt.timeoutlen = 250
opt.ttimeoutlen = 10
opt.updatetime = 100

-- Persistent undo
local undodir = vim.fn.stdpath("data") .. "/undo"
opt.undofile = true
opt.undodir = undodir
opt.undolevels = 1000
opt.undoreload = 10000

-- Folds
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- Match pairs
opt.matchpairs = { "(:)", "{:}", "[:]", "<:>" }

-- Yank highlight
vim.diagnostic.config({ float = { border = "rounded" } })

-- Backspace behavior
opt.backspace = { "eol", "start", "indent" }

-- Disable built-ins
local disabled_built_ins = {
  "2html_plugin", "getscript", "getscriptPlugin", "gzip", "logipat",
  "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers", "matchit",
  "tar", "tarPlugin", "rrhelper", "spellfile_plugin", "vimball", "vimballPlugin",
  "zip", "zipPlugin", "tutor", "rplugin", "synmenu", "optwin", "compiler",
  "bugreport", "ftplugin"
}
for _, plugin in ipairs(disabled_built_ins) do
  g["loaded_" .. plugin] = 1
end

cmd.colorscheme("catppuccin")
