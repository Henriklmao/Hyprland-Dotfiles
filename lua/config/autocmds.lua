-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- for TMUX, new pane in cwd:
vim.api.nvim_create_autocmd({ "DirChanged", "VimEnter" }, {
  pattern = "*",
  callback = function()
    if vim.env.TMUX then
      local cwd = vim.fn.getcwd()
      local pane_id = vim.env.TMUX_PANE
      vim.fn.system(string.format("tmux set-buffer -b tmux_cwd_%s '%s'", pane_id, cwd))
    end
  end,
})
