local nmap = function(keys, func, desc)
  vim.keymap.set("n", keys, func, { silent = true, desc = desc })
end


local xmap = function(keys, func, desc)

  vim.keymap.set("x", keys, func, { silent = true, desc = desc })
end

nmap("<leader>q", ":qa!<CR>", "Quit all (force)")
nmap("<leader>s", ":w!<CR>", "Save file (force)")

xmap("<", "<gv", "Indent left and keep selection")

xmap(">", ">gv", "Indent right and keep selection")

vim.api.nvim_create_autocmd("BufEnter", {

  callback = function() vim.wo.relativenumber = true end,

})

local fzf = require("fzf-lua")

nmap("<leader>ff", fzf.files, "Find files")
nmap("<leader>fp", fzf.git_files, "Git files")

nmap("<leader>fg", fzf.live_grep, "Live grep")
nmap("<leader>fb", fzf.buffers, "List buffers")
nmap("<leader>fh", fzf.help_tags, "Help tags search")


nmap("<leader>xx", function() require("trouble").toggle("diagnostics") end, "Toggle diagnostics (Trouble)")

nmap("<leader>gg", ":LazyGit<CR>", "Open LazyGit")
nmap("<leader>n", ":NvimTreeToggle<CR>", "Toggle file tree")


nmap("<leader>fr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Find & replace (current file)")
nmap("<leader>FA", [[:cdo %s/\<<C-r><C-w>\>/<C-r><C-w>/gI | update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>]], "Find & replace (quickfix files)")

nmap("<leader>dc", function() require("dap").continue() end, "DAP Continue")
nmap("<leader>dl", function() require("dap").run_last() end, "DAP Run last")
nmap("<leader>b", function() require("dap").toggle_breakpoint() end, "DAP Toggle breakpoint")
nmap("<leader>dq", function() require("dapui").close() end, "DAP UI close")
