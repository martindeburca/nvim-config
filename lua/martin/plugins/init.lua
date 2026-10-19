return {
  "nvim-lua/plenary.nvim", -- lua functions that many plugins use
  {
    "christoomey/vim-tmux-navigator", -- pane/split navigation (Mac: full plugin)
    -- Mac uses the plugin's default Ctrl-hjkl mappings and its tmux handoff.
    -- On Windows we still use Ctrl-hjkl, but we can't use the plugin's edge
    -- handoff: it runs `tmux -S <socket> select-pane`, and psmux's socket path
    -- isn't accepted via -S, so it fails silently. So on Windows we disable the
    -- plugin's mappings and do the handoff ourselves with `psmux select-pane`
    -- (no -S — psmux finds the server via $TMUX, which Neovim inherits).
    init = function()
      if vim.fn.has("win32") == 1 then
        vim.g.tmux_navigator_no_mappings = 1
      end
    end,
    config = function()
      -- Inside Herdr (trial tmux replacement; config/herdr/config.toml), take over Ctrl-hjkl:
      -- move between splits, and at an edge ask Herdr to focus the neighbouring pane. Herdr's
      -- side (the jsheely/herdr-vim-navigation plugin) forwards Ctrl-hjkl here when Neovim is
      -- in the pane. Adapted from that plugin's editor/nvim.lua (MIT). Outside Herdr, the
      -- tmux (Mac) and psmux (Windows) behaviour below is unchanged.
      local herdr_pane = vim.env.HERDR_PANE_ID
      if herdr_pane and herdr_pane ~= "" then
        local herdr = (vim.env.HERDR_BIN_PATH and vim.env.HERDR_BIN_PATH ~= "") and vim.env.HERDR_BIN_PATH or "herdr"
        local function herdr_nav(wincmd, dir)
          local cur = vim.api.nvim_get_current_win()
          vim.cmd("wincmd " .. wincmd)
          if cur == vim.api.nvim_get_current_win() then
            -- target this pane explicitly: --current means Herdr's globally focused pane
            vim.fn.system({ herdr, "pane", "focus", "--direction", dir, "--pane", herdr_pane })
          end
        end
        for key, dir in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
          vim.keymap.set("n", "<C-" .. key .. ">", function() herdr_nav(key, dir) end,
            { silent = true, desc = "Nav " .. dir .. " (split/Herdr pane)" })
        end
        return
      end
      if vim.fn.has("win32") ~= 1 then
        return
      end
      -- Move to the split in `wincmd` direction; if we didn't move (already at
      -- the edge) and we're inside psmux, switch panes with select-pane.
      local function nav(wincmd, pane)
        local cur = vim.api.nvim_get_current_win()
        vim.cmd("wincmd " .. wincmd)
        if cur == vim.api.nvim_get_current_win() and vim.env.TMUX then
          vim.fn.system({ "psmux", "select-pane", "-" .. pane })
        end
      end
      local o = { silent = true }
      vim.keymap.set("n", "<C-h>", function() nav("h", "L") end, vim.tbl_extend("force", o, { desc = "Nav left (split/pane)" }))
      vim.keymap.set("n", "<C-j>", function() nav("j", "D") end, vim.tbl_extend("force", o, { desc = "Nav down (split/pane)" }))
      vim.keymap.set("n", "<C-k>", function() nav("k", "U") end, vim.tbl_extend("force", o, { desc = "Nav up (split/pane)" }))
      vim.keymap.set("n", "<C-l>", function() nav("l", "R") end, vim.tbl_extend("force", o, { desc = "Nav right (split/pane)" }))
    end,
  },
}
