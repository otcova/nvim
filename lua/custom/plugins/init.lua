-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

----- (C / C++) Goto Header File -----
vim.keymap.set('n', 'gh', function()
  local extensions = {
    h = { 'c', 'cpp', 'cc' },
    hh = { 'cc', 'cpp' },
    hpp = { 'cpp', 'cc' },
    c = { 'h' },
    cc = { 'hh', 'hpp' },
    cpp = { 'hpp', 'h', 'hh' },
  }

  local buf = vim.api.nvim_buf_get_name(0)

  for from_ext, to_exts in pairs(extensions) do
    print(from_ext)
    if buf:sub(#buf - #from_ext, #buf) == '.' .. from_ext then
      for _, to_ext in ipairs(to_exts) do
        local new_buf = buf:sub(1, #buf - #from_ext) .. to_ext
        print(new_buf)
        if vim.fn.filereadable(new_buf) == 1 then
          vim.cmd.edit(new_buf)
          return
        end
      end
      break
    end
  end

  print 'Invalid file extension'
end, { desc = '[G]oto [H]eader file' })

----- Save All -----
vim.keymap.set('n', '<c-s>', ':wa<Enter>', { desc = '[S]ave all' })
vim.keymap.set('i', '<c-s>', '<Esc>:wa<Enter>', { desc = '[S]ave all' })

----- Substitute / Replace -----
vim.keymap.set('n', '<leader>S', ':%s/\\v/g<left><left>', { desc = '[S]ubstiute' })
vim.keymap.set('v', '<leader>S', ':s/\\v/g<left><left>', { desc = '[S]ubstiute' })

vim.keymap.set('n', '<leader>R', ':%s/<c-r><c-w>//g<left><left>', { desc = '[R]eplace word' })
vim.keymap.set('v', '<leader>R', 'y:%s/<c-r>0//g<left><left>', { desc = '[R]eplace selection' })

----- Window Shortcuts -----
vim.keymap.set('n', '_', '<c-w>_')
vim.keymap.set('n', '|', '<c-w>|')

----- Close Buffer -----
vim.keymap.set('n', '<leader>W', ':b# | bw#<Enter>', { desc = '[W]ipeout buffer' })

----- Show Error before warning -----
vim.diagnostic.config { severity_sort = true }

----- Lsp Virtual Text only on WARN or ERROR -----
vim.diagnostic.config { virtual_text = {
  severity = { min = vim.diagnostic.severity.WARN },
} }

----- Swap Previous Buffer -----
-- vim.keymap.set('n', 'gp', ':b#<Enter>', { desc = '[P]revious Buffer' })
vim.keymap.set('n', 'gp', ':e#<Enter>', { desc = '[P]revious Buffer' })
-- vim.keymap.set('n', 'gp', function()
--   for i, buf in ipairs(vim.v.oldfiles) do
--     if i > 10 then
--       return
--     end
--
--     if vim.fn.filereadable(buf) and buf:sub(#buf - 9, #buf - 1) ~= 'NvimTree_' then
--       print(buf)
--       --vim.cmd.edit(buf)
--       return
--     end
--   end
-- end, { desc = '[P]revious Buffer' })

----- Paste Without Copy -----
vim.keymap.set('v', '<leader>p', '"_dP', { desc = '[P]aste after without copy' })
vim.keymap.set('v', '<leader>P', '"_dP', { desc = '[P]aste before without copy' })

----- Indent -----
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false

----- Use Powershell -----
vim.opt.shell = 'powershell.exe'
vim.opt.shellcmdflag = '-command'
vim.opt.shellquote = ''
vim.opt.shellxquote = ''

----- Custom Options -----
vim.opt.relativenumber = true

----- File Tree Explorer -----
local function my_on_attach(bufnr)
  local api = require 'nvim-tree.api'

  local function opts(desc)
    return { desc = desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- BEGIN_DEFAULT_ON_ATTACH
  --vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node, opts 'CD')
  vim.keymap.set('n', '<C-c>', api.tree.change_root_to_node, opts 'CD')
  vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer, opts 'Open: In Place')
  vim.keymap.set('n', '<C-k>', api.node.show_info_popup, opts 'Info')
  vim.keymap.set('n', '<C-r>', api.fs.rename_sub, opts 'Rename: Omit Filename')
  vim.keymap.set('n', '<C-t>', api.node.open.tab, opts 'Open: New Tab')
  vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts 'Open: Vertical Split')
  -- vim.keymap.set('n', '<C-x>', api.node.open.horizontal, opts 'Open: Horizontal Split')
  vim.keymap.set('n', '<C-h>', api.node.open.horizontal, opts 'Open: Horizontal Split')
  vim.keymap.set('n', '<BS>', api.node.navigate.parent_close, opts 'Close Directory')
  vim.keymap.set('n', '<CR>', api.node.open.edit, opts 'Open')
  vim.keymap.set('n', '<Tab>', api.node.open.preview, opts 'Open Preview')
  vim.keymap.set('n', '>', api.node.navigate.sibling.next, opts 'Next Sibling')
  vim.keymap.set('n', '<', api.node.navigate.sibling.prev, opts 'Previous Sibling')
  vim.keymap.set('n', '.', api.node.run.cmd, opts 'Run Command')
  vim.keymap.set('n', '-', api.tree.change_root_to_parent, opts 'Up')
  vim.keymap.set('n', 'a', api.fs.create, opts 'Create File Or Directory')
  vim.keymap.set('n', 'bd', api.marks.bulk.delete, opts 'Delete Bookmarked')
  vim.keymap.set('n', 'bt', api.marks.bulk.trash, opts 'Trash Bookmarked')
  vim.keymap.set('n', 'bmv', api.marks.bulk.move, opts 'Move Bookmarked')
  vim.keymap.set('n', 'B', api.tree.toggle_no_buffer_filter, opts 'Toggle Filter: No Buffer')
  vim.keymap.set('n', 'c', api.fs.copy.node, opts 'Copy')
  vim.keymap.set('n', 'C', api.tree.toggle_git_clean_filter, opts 'Toggle Filter: Git Clean')
  vim.keymap.set('n', '[c', api.node.navigate.git.prev, opts 'Prev Git')
  vim.keymap.set('n', ']c', api.node.navigate.git.next, opts 'Next Git')
  vim.keymap.set('n', 'd', api.fs.remove, opts 'Delete')
  vim.keymap.set('n', 'D', api.fs.trash, opts 'Trash')
  vim.keymap.set('n', 'E', api.tree.expand_all, opts 'Expand All')
  vim.keymap.set('n', 'e', api.fs.rename_basename, opts 'Rename: Basename')
  vim.keymap.set('n', ']e', api.node.navigate.diagnostics.next, opts 'Next Diagnostic')
  vim.keymap.set('n', '[e', api.node.navigate.diagnostics.prev, opts 'Prev Diagnostic')
  vim.keymap.set('n', 'F', api.live_filter.clear, opts 'Live Filter: Clear')
  vim.keymap.set('n', 'f', api.live_filter.start, opts 'Live Filter: Start')
  vim.keymap.set('n', 'g?', api.tree.toggle_help, opts 'Help')
  vim.keymap.set('n', 'gy', api.fs.copy.absolute_path, opts 'Copy Absolute Path')
  vim.keymap.set('n', 'H', api.tree.toggle_hidden_filter, opts 'Toggle Filter: Dotfiles')
  vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter, opts 'Toggle Filter: Git Ignore')
  vim.keymap.set('n', 'J', api.node.navigate.sibling.last, opts 'Last Sibling')
  vim.keymap.set('n', 'K', api.node.navigate.sibling.first, opts 'First Sibling')
  vim.keymap.set('n', 'L', api.node.open.toggle_group_empty, opts 'Toggle Group Empty')
  vim.keymap.set('n', 'M', api.tree.toggle_no_bookmark_filter, opts 'Toggle Filter: No Bookmark')
  vim.keymap.set('n', 'm', api.marks.toggle, opts 'Toggle Bookmark')
  vim.keymap.set('n', 'o', api.node.open.edit, opts 'Open')
  vim.keymap.set('n', 'O', api.node.open.no_window_picker, opts 'Open: No Window Picker')
  vim.keymap.set('n', 'p', api.fs.paste, opts 'Paste')
  vim.keymap.set('n', 'P', api.node.navigate.parent, opts 'Parent Directory')
  vim.keymap.set('n', 'q', api.tree.close, opts 'Close')
  vim.keymap.set('n', 'r', api.fs.rename, opts 'Rename')
  vim.keymap.set('n', 'R', api.tree.reload, opts 'Refresh')
  vim.keymap.set('n', 's', api.node.run.system, opts 'Run System')
  vim.keymap.set('n', 'S', api.tree.search_node, opts 'Search')
  vim.keymap.set('n', 'u', api.fs.rename_full, opts 'Rename: Full Path')
  vim.keymap.set('n', 'U', api.tree.toggle_custom_filter, opts 'Toggle Filter: Hidden')
  vim.keymap.set('n', 'W', api.tree.collapse_all, opts 'Collapse')
  vim.keymap.set('n', 'x', api.fs.cut, opts 'Cut')
  vim.keymap.set('n', 'y', api.fs.copy.filename, opts 'Copy Name')
  vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts 'Copy Relative Path')
  vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, opts 'Open')
  vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts 'CD')
  -- END_DEFAULT_ON_ATTACH
end

return {
  {
    'nvim-tree/nvim-tree.lua',
    event = 'VeryLazy',
    config = function()
      require('nvim-tree').setup { on_attach = my_on_attach, git = { enable = false } }

      local api = require 'nvim-tree.api'
      vim.keymap.set('n', '<leader>t', function()
        api.tree.open { find_file = true }
      end, { desc = '[T]ree File Explorer' })
    end,
  },
}
