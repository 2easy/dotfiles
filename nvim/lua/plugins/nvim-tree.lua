return {
  {
    'kyazdani42/nvim-tree.lua',
    keys = {
      {
        '<leader>fl',
        function()
          local api = require('nvim-tree.api').tree
          api.open({ focus = true, find_file = true })
        end,
        desc = 'Locate file in explorer',
      },
      {
        '<leader>fe',
        function()
          require('nvim-tree.api').tree.toggle()
        end,
        desc = 'Open file explorer',
      },
    },
    config = function()
      local icons = require('user.icons')
      local opts = {
        hijack_netrw = false,
        diagnostics = { enable = true, icons = icons.nerdtree },
        respect_buf_cwd = true,
        on_attach = function(bufnr)
          local api = require('nvim-tree.api')

          local function opts(desc)
            return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          api.config.mappings.default_on_attach(bufnr)

          vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
          vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
          vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
          vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, opts('Open'))
          vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
        end,
        renderer = {
          add_trailing = true,
          highlight_git = true,
          indent_markers = { enable = true },
          special_files = { 'Makefile', 'README.md', 'go.mod' },
          icons = {
            glyphs = {
              git = {
                unstaged = icons.git.status.modified,
                staged = icons.git.status.added,
                unmerged = icons.git.status.unmerged,
                renamed = icons.git.status.renamed,
                untracked = icons.git.status.untracked,
                deleted = icons.git.status.deleted,
                ignored = icons.git.status.ignored,
              },
            },
          },
        },
        git = {
          ignore = false,
        },
        view = {
          adaptive_size = true,
          width = 40,
          side = 'left',
        },
        actions = {
          file_popup = {
            open_win_config = {
              border = 'rounded',
            },
          },
          open_file = {
            window_picker = {
              enable = false,
            },
          },
        },
      }

      require('nvim-tree').setup(opts)
    end,
  },
}
