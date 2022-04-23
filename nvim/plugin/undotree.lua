vim.g.undotree_SetFocusWhenToggle = 1

vim.api.nvim_set_keymap('n', '<leader>u', ':UndotreeToggle<CR>', { noremap = true })

local status_ok, which_key = pcall(require, 'which-key')
if not status_ok then
  return
end

which_key.register({ ['<leader>u'] = 'Open Undotree' })
