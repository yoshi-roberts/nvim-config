return {
  'mellow-theme/mellow.nvim',

  config = function()
    vim.g.mellow_italic_functions = true
    vim.g.mellow_bold_functions = true

    vim.g.mellow_highlight_overrides = {
      ['NormalNC'] = { link = 'Normal' },
    }

    -- Load the colorscheme
    vim.cmd [[colorscheme mellow]]
  end,
}
