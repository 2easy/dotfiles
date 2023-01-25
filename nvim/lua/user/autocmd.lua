-- vim: foldmethod=marker

-- Toggle highlighting current line only in active splits {{{1
vim.api.nvim_create_augroup('user_toggle_cursorline', { clear = true })
vim.api.nvim_create_autocmd({ 'VimEnter', 'WinEnter', 'BufWinEnter' }, {
  group = 'user_toggle_cursorline',
  desc = 'enable cursorline on focus',
  pattern = '*',
  callback = function()
    vim.opt_local.cursorline = true
  end,
})
vim.api.nvim_create_autocmd({ 'VimLeave', 'WinLeave', 'BufWinLeave' }, {
  group = 'user_toggle_cursorline',
  desc = 'disable cursorline on lost focus',
  pattern = '*',
  callback = function()
    vim.opt_local.cursorline = false
  end,
})

-- Customise colorscheme highlight groups {{{1
vim.api.nvim_create_augroup('user_customise_colorscheme', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  group = 'user_customise_colorscheme',
  desc = 'customise the colorscheme highlights',
  pattern = '*',
  callback = function()
    vim.api.nvim_set_hl(0, 'PmenuThumb', { link = 'Visual' })
    vim.api.nvim_set_hl(0, 'LspInfoBorder', { link = 'FloatBorder' })

    local lsp_types = require('cmp.types').lsp
    for kind, _ in pairs(lsp_types.CompletionItemKind) do
      if type(kind) == 'string' then
        local name = ('CmpItemKind%s'):format(kind)
        local ok, hlgroup = pcall(vim.api.nvim_get_hl_by_name, name, true)
        if ok then
          hlgroup.reverse = true
          vim.api.nvim_set_hl(0, name, hlgroup)
        end
      end
    end

    local fg = vim.api.nvim_get_hl_by_name('Label', true).foreground
    vim.api.nvim_set_hl(0, 'CmpItemMenu', { foreground = fg })
  end,
})

-- Highlight yanked text {{{1
vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
  desc = 'highlight yanked text',
  callback = function()
    vim.highlight.on_yank({ higroup = 'Visual', timeout = 500 })
  end,
})

-- Notify when Mason tools are updated {{{1
vim.api.nvim_create_augroup('user_mason_tool_update', { clear = true })
vim.api.nvim_create_autocmd('User', {
  group = 'user_mason_tool_update',
  desc = 'send a notification when Mason tools are updated',
  pattern = 'MasonToolsUpdateCompleted',
  callback = function()
    vim.notify('Successfully updated Mason tools', vim.log.levels.INFO)
  end,
})

--- }}}
