return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function()
    -- import comment plugin safely
    local comment = require("Comment")

    -- Comment.nvim asks for the right commentstring when you comment (pre_hook below), so the
    -- plugin's own CursorHold autocmd isn't needed. It also errors on Neovim 0.12 in buffers
    -- without a Treesitter parser (e.g. during :Lazy update).
    require("ts_context_commentstring").setup({ enable_autocmd = false })

    local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")
    local ts_pre_hook = ts_context_commentstring.create_pre_hook()

    -- enable comment
    comment.setup({
      -- for commenting tsx, jsx, svelte, html files. Only where the buffer has a Treesitter
      -- parser: without one, both this hook and Comment.nvim's own lookup fail on Neovim 0.12
      -- and nothing gets commented, so hand back the buffer's commentstring (e.g. "# %s").
      pre_hook = function(ctx)
        if vim.treesitter.get_parser(0, nil, { error = false }) then
          return ts_pre_hook(ctx)
        end
        return vim.bo.commentstring
      end,
    })
  end,
}
