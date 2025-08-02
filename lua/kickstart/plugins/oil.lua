return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons

    config = function()

      local oil = require 'oil'

      oil.setup {
        keymaps = {
          ['q'] = 'actions.close',
        },
      }

      vim.keymap.set('n', '-', '<CMD>Oil<CR>')
    end,
  },
}
