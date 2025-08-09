return {
  {
    "rebelot/heirline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()

      local conditions = require("heirline.conditions")
      local palette = require("catppuccin.palettes").get_palette()
      local colors = {
        fg = palette.text, bg = nil, red = palette.red, yellow = palette.yellow,
        blue = palette.blue, cyan = palette.sky, magenta = palette.mauve,
      }


      local Space = { provider = " " }

      local Macro = {
        condition = function() return vim.fn.reg_recording() ~= "" end,
        provider = function() return "Recording @" .. vim.fn.reg_recording() end,
        hl = { fg = palette.peach, bold = true },
      }

      local GitBranch = {
        condition = conditions.is_git_repo,
        init = function(self) self.status_dict = vim.b.gitsigns_status_dict end,
        provider = function(self)
          if self.status_dict and self.status_dict.head and #self.status_dict.head > 0 then
            return " " .. self.status_dict.head
          end
        end,
        hl = { fg = colors.blue, bold = true },
      }

      local Filename = {
        condition = conditions.buffer_not_empty,
        provider = function()

          local name = vim.api.nvim_buf_get_name(0)
          if name == "" then return "" end
          return vim.fn.fnamemodify(name, ":~:.")
        end,
        hl = { fg = colors.magenta, bold = true },
      }

      local LspName = {
        provider = function()
          local clients = vim.lsp.get_clients({ bufnr = 0 })

          if not clients or #clients == 0 then return "LSP:null" end

          return "LSP:" .. clients[1].name
        end,
        hl = { fg = colors.cyan, bold = true },
      }

      local Diagnostics = {
        condition = conditions.has_diagnostics,
        static = { icons = { error = " ", warn = " ", info = " " } },

        init = function(self)
          self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
          self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
          self.infos = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
        end,

        {
          condition = function(self) return self.errors > 0 end,
          provider = function(self) return self.errors .. self.icons.error end,
          hl = { fg = colors.red },
        },
        Space,
        {

          condition = function(self) return self.warnings > 0 end,
          provider = function(self) return self.warnings .. self.icons.warn end,
          hl = { fg = colors.yellow },
        },
        Space,
        {
          condition = function(self) return self.infos > 0 end,
          provider = function(self) return self.infos .. self.icons.info end,
          hl = { fg = colors.cyan },
        },
      }

      local Align = { provider = "%=" }
      local Progress = { provider = "%3p%%", hl = { fg = colors.fg, bold = true } }

      require("heirline").setup({
        opts = { colors = colors },

        statusline = {
          Space, Macro, Space, GitBranch, Align,
          Filename, Space, LspName, Space, Diagnostics, Space, Progress, Space,
        },
        winbar = nil,
        tabline = nil,

      })
    end,

  }
}

