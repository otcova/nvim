--------------------------
----- Custom Setting -----
--------------------------

--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = 'a' -- allow

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Don't keep signcolumn on by default
vim.opt.signcolumn = 'no'

-- Decrease update time
vim.opt.updatetime = 2000
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }
-- vim.opt.listchars.tab = '» '
-- vim.opt.listchars.tab = '│ '

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

----- Diagnostic keymaps -----
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

----- Indent -----
vim.opt.softtabstop = 4
-- vim.opt.tabstop = 4 -- see plugin `sleuth`
-- vim.opt.shiftwidth = 4
vim.opt.expandtab = false

----- Use Powershell -----
vim.opt.shell = 'powershell.exe'
vim.opt.shellcmdflag = '-command'
vim.opt.shellquote = ''
vim.opt.shellxquote = ''

----- Terminal -----
vim.keymap.set('n', '<c-w>t', ':NvimTreeFocus<Enter><c-w>s:term<Enter>i', { desc = '[T]erminal' })
local focus_term = '<Esc>:wa<CR>:NvimTreeFocus<Enter><c-w>ji'
vim.keymap.set('n', '<leader>t', focus_term, { desc = '[T]erminal' })
vim.keymap.set({ 'n', 'v' }, '<leader>@', focus_term .. '<Up><CR><c-\\><c-n><c-w>l', { desc = 'Run last [T]erminal cmd' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

----- Save All -----
vim.keymap.set('n', '<c-s>', ':wa<Enter>', { desc = '[S]ave all' })
vim.keymap.set('i', '<c-s>', '<Esc>:wa<Enter>', { desc = '[S]ave all' })

----- Substitute / Replace -----
vim.keymap.set('n', '<leader>rs', ':%s//g<left><left>', { desc = '[S]ubstiute' })
vim.keymap.set('v', '<leader>rs', ':s//g<left><left>', { desc = '[S]ubstiute inside selection' })

vim.keymap.set('n', '<leader>rr', ':%s/<c-r><c-w>//g<left><left>', { desc = '[R]eplace word' })
vim.keymap.set('v', '<leader>rr', 'y:%s/<c-r>0//g<left><left>', { desc = '[R]eplace selection' })

----- Window Shortcuts -----
vim.keymap.set('n', '_', '<c-w>_')
vim.keymap.set('n', '|', '<c-w>|')

----- Show Error before warning -----
vim.diagnostic.config { severity_sort = true }

----- Lsp Virtual Text only on WARN or ERROR -----
vim.diagnostic.config { virtual_text = {
  severity = { min = vim.diagnostic.severity.WARN },
} }

----- Swap Previous Buffer -----
local swap_buffer = ":<c-u>exe v:count ? v:count . 'b' : 'b' . (bufloaded(0) ? '#' : 'n')"
vim.keymap.set('n', '<c-p>', swap_buffer .. '<cr>', { desc = '[P]revious Buffer', silent = true })

----- Close Buffer -----
vim.keymap.set('n', '<leader>W', swap_buffer .. ' | bw#<cr>', { desc = '[W]ipeout buffer', silent = true })

----- Paste Without Copy -----
vim.keymap.set('v', '<leader>p', '"_dP', { desc = '[P]aste after without copy' })
vim.keymap.set('v', '<leader>P', '"_dP', { desc = '[P]aste before without copy' })

----- Window Navigation -----
vim.keymap.set('t', '<c-w>', '<c-\\><c-n><c-w>')
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

----- Show Signcolumn -----
vim.keymap.set('n', '<leader>g', function()
  if vim.opt.signcolumn:get() == 'no' then
    local has_num_col = vim.opt.number:get() or vim.opt.relativenumber:get()
    vim.opt.signcolumn = has_num_col and 'number' or 'yes'
  else
    vim.opt.signcolumn = 'no'
  end
end, { desc = '[G]it signcolumn' })

----- Goto Header/Source File -----
vim.keymap.set('n', 'gh', function()
  local extensions = {
    h = { 'c', 'cpp', 'cc' },
    hh = { 'cc', 'cpp' },
    hpp = { 'cpp', 'cc' },
    c = { 'h' },
    cc = { 'hh', 'hpp' },
    cpp = { 'hpp', 'h', 'hh' },
    vert = { 'frag' },
    frag = { 'vert' },
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

----- Highlight yank -----
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

----- Install `lazy.nvim` plugin manager -----
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end
vim.opt.rtp:prepend(lazypath)

-----------------------------------------
----- Configure and install plugins -----
-----------------------------------------
require('lazy').setup {
  ----- Detect Indent -----
  'tpope/vim-sleuth',

  ----- Comment -----
  {
    'numToStr/Comment.nvim',
    opts = {
      toggler = {
        line = 'gcc',
        block = 'gbc',
      },
      opleader = {
        line = 'gc',
        block = 'gb',
      },
      extra = {
        above = 'gcO',
        below = 'gco',
        eol = 'gcA',
      },
    },
  },

  ----- Git Signs -----
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
      },
    },
  },

  ----- Show key description -----
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function()
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').register {
        ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
        ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
        ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
        ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
        ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
      }
    end,
  },

  ----- Coloshceme -----
  {
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`
    'folke/tokyonight.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- Load the colorscheme here
      vim.cmd.colorscheme 'tokyonight-night'

      -- You can configure highlights by doing something like
      vim.cmd.hi 'Comment gui=none guifg=#6b79b3'
    end,
  },

  ----- Highlight todo, notes, etc in comments -----
  {
    'folke/todo-comments.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  ----- Extra Motions -----
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      statusline.setup()

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we disable the section for
      -- cursor information because line numbers are already enabled
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return ''
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },

  ----- Code Highlight -----
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc' },
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      }

      vim.filetype.add { extension = { wgsl = 'wgsl' } }

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },
  ----- Fuzzy Finder -----
  {
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for install instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires special font.
      --  If you already have a Nerd Font, or terminal set up with fallback fonts
      --  you can enable this
      { 'nvim-tree/nvim-web-devicons' },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of help_tags options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      ----- Configure Telescope -----
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable telescope extensions, if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>so', builtin.oldfiles, { desc = '[S]earch [O]ld Files' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      vim.keymap.set('n', '<leader>sr', function()
        builtin.resume()
        -- This will refresh the search
        vim.schedule(function()
          vim.api.nvim_input '<esc>xpa'
        end)
      end, { desc = '[S]earch [R]esume' })

      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>se', function()
        builtin.diagnostics { severity = 'ERROR' }
      end, { desc = '[S]earch [E]rrors' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- Also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
  ----- File Tree Explorer -----
  {
    'nvim-tree/nvim-tree.lua',
    event = 'VeryLazy',
    config = function()
      local function my_on_attach(bufnr)
        local api = require 'nvim-tree.api'

        local function opts(desc)
          return { desc = desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        vim.keymap.set('n', '<C-c>', api.tree.change_root_to_node, opts 'CD')
        vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer, opts 'Open: In Place')
        vim.keymap.set('n', '<C-k>', api.node.show_info_popup, opts 'Info')
        vim.keymap.set('n', '<C-r>', api.fs.rename_sub, opts 'Rename: Omit Filename')
        vim.keymap.set('n', '<C-t>', api.node.open.tab, opts 'Open: New Tab')
        vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts 'Open: Vertical Split')
        vim.keymap.set('n', '<C-h>', api.node.open.horizontal, opts 'Open: Horizontal Split')
        vim.keymap.set('n', '<BS>', api.node.navigate.parent_close, opts 'Close Directory')
        vim.keymap.set('n', '<CR>', api.node.open.no_window_picker, opts 'Open: No Window Picker')
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
        vim.keymap.set('n', 'O', function()
          local actions = require 'nvim-tree.actions.node.open-file'
          actions.resize_window = false
          api.node.open.edit()
          actions.resize_window = true
        end, opts 'Open and resize')
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
      end

      require('nvim-tree').setup {
        on_attach = my_on_attach,
        renderer = {
          icons = {
            git_placement = 'signcolumn',
            glyphs = {
              git = {
                unstaged = '✗',
                staged = '✓',
                unmerged = '',
                renamed = '➜',
                untracked = '★',
                deleted = '',
                ignored = '◌',
              },
            },
          },
        },
        view = {
          width = 40,
          signcolumn = 'no',
        },
      }

      -- local actions = require 'nvim-tree.actions.node.open-file'
      -- actions.resize_window = false

      local api = require 'nvim-tree.api'
      vim.keymap.set('n', '<leader>f', function()
        api.tree.open { find_file = true }
      end, { desc = '[F]ile Tree Explorer' })
    end,
  },

  ---------------------------------
  ---------- LSP Plugins ----------
  ---------------------------------

  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself
          -- many times.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-T>.
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace
          --  Similar to document symbols, except searches over your whole project.
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP Specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`tsserver`) will work just fine
        -- tsserver = {},
        --
        --

        lua_ls = {
          -- cmd = {...},
          -- filetypes { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              runtime = { version = 'LuaJIT' },
              workspace = {
                checkThirdParty = false,
                -- Tells lua_ls where to find all the Lua files that you have loaded
                -- for your neovim configuration.
                library = {
                  '${3rd}/luv/library',
                  unpack(vim.api.nvim_get_runtime_file('', true)),
                },
                -- If lua_ls is really slow on your computer, you can try this instead:
                -- library = { vim.env.VIMRUNTIME },
              },
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu
      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          ['rust_analyzer'] = function() end, -- do not setup rust_analyzer here
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  ----- Autoformat -----
  {
    'stevearc/conform.nvim',
    opts = {
      notify_on_error = false,
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        -- javascript = { { "prettierd", "prettier" } },
      },
    },
  },

  ----- Autocompletion -----
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets
          -- This step is not supported in many windows environments
          -- Remove the below condition to re-enable on windows
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',

      -- If you want to add a bunch of pre-configured snippets,
      --    you can use this plugin to help you. It even has snippets
      --    for various frameworks/libraries/etc. but you will have to
      --    set up the ones that are useful for you.
      -- 'rafamadriz/friendly-snippets',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-y>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          },
          ['<C-c>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<C-a>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },

  {
    'mrcjkb/rustaceanvim',
    dependencies = {
      'williamboman/mason.nvim',
    },
    version = '4.22.x',
    lazy = false, -- This plugin is already lazy
    config = function()
      vim.g.rustaceanvim = function()
        local reg = require 'mason-registry'
        local cfg = require 'rustaceanvim.config'

        local rust_analyzer = reg.get_package 'rust-analyzer'
        local rust_analyzer_bin = rust_analyzer:get_install_path() .. '/rust-analyzer.exe'

        local codelldb = reg.get_package 'codelldb'
        local codelldb_exe = codelldb:get_install_path() .. '\\extension\\adapter\\codelldb'
        local lldb_lib = codelldb:get_install_path() .. '\\extension\\lldb\\'

        local this_os = vim.uv.os_uname().sysname
        if this_os:find 'Windows' then
          codelldb_exe = codelldb_exe .. '.exe'
          lldb_lib = lldb_lib .. 'bin\\liblldb.dll'
        elseif this_os:find 'Linux' then
          lldb_lib = lldb_lib .. 'lib/liblldb.so'
        elseif this_os:find 'Mac' then
          lldb_lib = lldb_lib .. 'lib/liblldb.dylib'
        else
          error 'Unknown os'
        end

        return {
          tools = {},
          server = {
            cmd = { rust_analyzer_bin },
            on_attach = function(client, bufnr)
              -- you can also put keymaps in here
            end,
            default_settings = {
              ['rust-analyzer'] = {
                imports = {
                  granularity = {
                    group = 'module',
                  },
                },
              },
            },
          },
          dap = {
            adapter = cfg.get_codelldb_adapter(codelldb_exe, lldb_lib),
          },
        }
      end
    end,
  },

  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',

      -- Installs the debug adapters for you
      'williamboman/mason.nvim',
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      -- Open DapUI on debug
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      -- Basic debugging keymaps, feel free to change to your liking!
      vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
      vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
      vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
      vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>B', function()
        dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end, { desc = 'Debug: Set Breakpoint' })

      dapui.setup {
        -- icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        -- controls = {
        --   icons = {
        --     pause = '⏸',
        --     play = '▶',
        --     step_into = '⏎',
        --     step_over = '⏭',
        --     step_out = '⏮',
        --     step_back = 'b',
        --     run_last = '▶▶',
        --     terminate = '⏹',
        --     disconnect = '⏏',
        --   },
        -- },
      }
    end,
  },

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
}
