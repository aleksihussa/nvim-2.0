return {
  {
    "numToStr/Comment.nvim",
    opts = {
      padding = true,
      sticky = true,
      ignore = "^$",
      mappings = {
        basic = true,
        extra = true,

      },
      toggler = {
        line = "mm",
        block = "mbm",

      },
      opleader = {
        line = "m",
        block = "mb",
      },
      extra = {
        eol = "mA",
      },
    },
    config = function(_, opts)
      require("Comment").setup(opts)
    end,
  }
}
