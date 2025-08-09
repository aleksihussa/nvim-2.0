return {
  {
    "catppuccin/nvim",

    name = "catppuccin",
    priority = 1000,
    opts = {
      transparent_background = true,

      integrations = {
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
          float = {
            border = "rounded",

            highlight = "NormalFloat",
          }
        }
      },
      highlight_overrides = {
        all = function(colors)
          return {
            NormalFloat = { bg = colors.base },
            FloatBorder = { fg = colors.mauve, bg = colors.base },
          }
        end
      }
    }

  }
}
