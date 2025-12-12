return {
  "phaazon/hop.nvim",
  config = function()
    require("hop").setup({
      keys = "ghfjtyvbrudkcn",
    })
  end,
  keys = {
    { mode = { "n", "v" }, "<LEADER>pw", "<CMD>HopWord<CR>", desc = "Hop To Word" },
    { mode = { "n", "v" }, "<LEADER>pl", "<CMD>HopLine<CR>", desc = "Hop To Line" },
    { mode = { "n", "v" }, "<LEADER>pa", "<CMD>HopAnywhere<CR>", desc = "Hop Anywhere" },
  },
}
