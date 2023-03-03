local M = {}

local diagnostics = require('utils.diagnostics')
local icons = require('user.icons').lspconfig

local function configure_keymaps(bufnr)
  -- Mark diagnostics as enabled by default
  diagnostics.set(bufnr, true)

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local diagnostic_float_opts = {
    focusable = false,
    close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter' },
    border = 'rounded',
    source = 'always',
    prefix = function(_, i, total)
      if total > 1 then
        return tostring(i) .. '. '
      end

      return ''
    end,
    format = function(diagnostic)
      if diagnostic.code then
        return string.format('%s [%s]', diagnostic.message, diagnostic.code)
      end

      return diagnostic.message
    end,
    scope = 'cursor',
    header = { 'Diagnostics', 'Title' },
  }

  local keymap = require('utils.keymap')
  keymap.set('n', '<leader>gD', vim.lsp.buf.declaration, { desc = 'Declaration', buffer = bufnr })
  keymap.set('n', '<leader>gd', vim.lsp.buf.definition, { desc = 'Definition', buffer = bufnr })
  keymap.set('n', '<leader>gt', vim.lsp.buf.type_definition, { desc = 'Type definition', buffer = bufnr })
  keymap.set('n', '<leader>gI', vim.lsp.buf.implementation, { desc = 'Implementation', buffer = bufnr })
  keymap.set('n', '<leader>gi', vim.lsp.buf.incoming_calls, { desc = 'Incoming calls', buffer = bufnr })
  keymap.set('n', '<leader>go', vim.lsp.buf.outgoing_calls, { desc = 'Outgoing calls', buffer = bufnr })
  keymap.set('n', '<leader>gr', vim.lsp.buf.references, { desc = 'References', buffer = bufnr })
  keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Documentation', buffer = bufnr })
  keymap.set('n', '<leader>ck', vim.lsp.buf.signature_help, { desc = 'Signature help', buffer = bufnr })
  keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = 'Rename', buffer = bufnr })
  keymap.set('n', '<leader>ce', function()
    diagnostics.set(bufnr, true)
    vim.diagnostic.enable(bufnr)
  end, { desc = 'Enable diagnostics', buffer = bufnr })
  keymap.set('n', '<leader>cd', function()
    diagnostics.set(bufnr, false)
    vim.diagnostic.disable(bufnr)
  end, { desc = 'Disable diagnostics', buffer = bufnr })
  keymap.set({ 'v', 'n' }, '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action', buffer = bufnr })
  keymap.set('n', '[d', function()
    if diagnostics.is_disabled(bufnr) then
      return
    end
    vim.diagnostic.goto_prev({ float = diagnostic_float_opts })
  end, { desc = 'Go to previous diagnostic', buffer = bufnr })
  keymap.set('n', ']d', function()
    if diagnostics.is_disabled(bufnr) then
      return
    end
    vim.diagnostic.goto_next({ float = diagnostic_float_opts })
  end, { desc = 'Go to next diagnostic', buffer = bufnr })
  keymap.set('n', '<leader>cs', function()
    if diagnostics.is_disabled(bufnr) then
      return
    end
    vim.diagnostic.open_float(nil, vim.tbl_extend('force', diagnostic_float_opts, { scope = 'line' }))
  end, { desc = 'Show diagnostics', buffer = bufnr })
  keymap.set('n', '<leader>cl', vim.diagnostic.setloclist, { desc = 'Populate loclist', buffer = bufnr })
  keymap.set('n', '<leader>cf', vim.lsp.buf.format, { desc = 'Format', buffer = bufnr })

  keymap.register_group('<leader>g', 'Goto', { buffer = bufnr })
  keymap.register_group('<leader>c', 'LSP', { buffer = bufnr })
  keymap.register_group('<leader>c', 'LSP', { buffer = bufnr, mode = 'v' })
end

local function configure_autocmds(client, bufnr)
  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup('user_lsp_document_highlight', { clear = false })
    vim.api.nvim_clear_autocmds({
      group = 'user_lsp_document_highlight',
      buffer = bufnr,
    })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = 'user_lsp_document_highlight',
      buffer = bufnr,
      desc = 'highlight current symbol on hover',
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      group = 'user_lsp_document_highlight',
      buffer = bufnr,
      desc = 'clear current symbol highlight',
      callback = vim.lsp.buf.clear_references,
    })
  end

  if client.supports_method('textDocument/formatting') then
    vim.api.nvim_create_augroup('user_lsp_document_format', { clear = false })
    vim.api.nvim_clear_autocmds({
      group = 'user_lsp_document_format',
      buffer = bufnr,
    })
    local null_ls_command_prefix = 'NULL_LS'
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = 'user_lsp_document_format',
      buffer = bufnr,
      desc = 'format on save',
      callback = function(_)
        vim.lsp.buf.format({ bufnr = bufnr })

        -- Workaround for gopls not organizing imports on vim.lsp.buf.format
        -- Call the organizeImports codeActions for *.go files
        if vim.bo.filetype == 'go' then
          local params = vim.lsp.util.make_range_params()
          params.context = { only = { 'source.organizeImports' } }
          ---@diagnostic disable-next-line: param-type-mismatch
          local result = vim.lsp.buf_request_sync(bufnr, 'textDocument/codeAction', params, 3000)
          for _, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
              if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
              elseif r.command:sub(1, #null_ls_command_prefix) ~= null_ls_command_prefix then
                vim.lsp.buf.execute_command(r.command)
              end
            end
          end
        end
      end,
    })
  end
end

local function attach_navic(client, bufnr)
  local status_ok, navic = pcall(require, 'nvim-navic')
  if not status_ok then
    vim.notify('Failed to import nvim-navic', vim.log.levels.WARN)
    return
  end

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local function on_attach(client, bufnr)
  configure_keymaps(bufnr)
  configure_autocmds(client, bufnr)
  attach_navic(client, bufnr)
end

-- Create config that activates keymaps and enables snippet support
local function create_config(servers, server)
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  local opts = {
    capabilities = capabilities,
    on_attach = on_attach,
  }

  if servers[server] then
    opts = vim.tbl_deep_extend('force', opts, servers[server]())
  end

  return opts
end

local function customise_ui()
  -- Update the sign icons
  for type, icon in pairs(icons) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  -- Set borders to floating windows
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })

  -- Use nvim-notify for LSP messages
  vim.lsp.handlers['window/showMessage'] = function(_, result, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    local lvl = ({ 'ERROR', 'WARN', 'INFO', 'DEBUG' })[result.type]
    local timeout = (result.type < 2 and 3000 or 1500)
    vim.notify(result.message, lvl, { title = 'LSP | ' .. client.name, timeout = timeout })
  end

  -- Update LspInfo window border
  require('lspconfig.ui.windows').default_options.border = 'rounded'
end

local function setup_vim_diagnostics()
  vim.diagnostic.config({
    underline = true,
    virtual_text = false,
    signs = true,
    float = false,
    update_in_insert = true,
    severity_sort = true,
  })
end

M.on_attach = on_attach
M.create_config = create_config
M.customise_ui = customise_ui
M.setup_vim_diagnostics = setup_vim_diagnostics

return M
