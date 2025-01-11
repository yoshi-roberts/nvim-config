-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Create splits
vim.keymap.set('n', '<leader>sv', '<cmd>vsplit<CR>', { desc = 'Split vertically' })
vim.keymap.set('n', '<leader>sh', '<cmd>split<CR>', { desc = 'Split horizontally' })

vim.keymap.set('n', '<leader>ta', ':$tabnew<CR>', { noremap = true })
vim.keymap.set('n', '<leader>tt', ':$tabnew | terminal<CR>', { noremap = true })
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>', { noremap = true })
vim.keymap.set('n', '<leader>to', ':tabonly<CR>', { noremap = true })
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', { noremap = true })
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', { noremap = true })
-- move current tab to previous position
vim.keymap.set('n', '<leader>tmp', ':-tabmove<CR>', { noremap = true })
-- move current tab to next position
vim.keymap.set('n', '<leader>tmn', ':+tabmove<CR>', { noremap = true })

-- mini.pick --
vim.keymap.set('n', '<leader>ff', '<cmd>Pick files<CR>', { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader><leader>', '<cmd>Pick buffers<CR>', { desc = '[ ] Find existing buffers' })

local function pick_todo()
  local pick = require 'mini.pick'

  -- Get loclist entries
  local loclist = vim.fn.getloclist(0)
  -- local loclist = vim.fn.getloclist(0, { all = 1 })

  -- Prepare items for mini.pick
  local items = {}
  for _, entry in ipairs(loclist) do
    -- local text = string.format('[%d:%d] %s', entry.lnum, entry.col, entry.text)
    -- table.insert(items, entry.text)
    -- print(text)
    -- table.insert(items, {
    --   text = string.format('[%d:%d] %s', entry.lnum, entry.col, entry.text),
    --   data = '8===D',
    -- })
    local filename = vim.api.nvim_buf_get_name(entry.bufnr)
    table.insert(items, {
      text = string.format('[%s:%d:%d] %s', filename, entry.lnum, entry.col, entry.text),
      data = entry,
    })
  end

  -- Use mini.pick to display the items
  pick.start {
    source = { items = items, prompt = 'Select TODO:' },
    on_accept = function(item)
      local entry = item.data
      if entry then
        -- Open the file if it's not already open
        vim.cmd(string.format('e %s', vim.fn.fnameescape(vim.api.nvim_buf_get_name(entry.bufnr))))
        -- Jump to the selected location
        vim.api.nvim_win_set_cursor(0, { entry.lnum, entry.col - 1 })
      end
    end,
  }
end

vim.keymap.set('n', '<leader>ft', pick_todo, { desc = '[F]ind [F]iles' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

-- vim: ts=2 sts=2 sw=2 et
