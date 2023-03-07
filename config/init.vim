"""""""""""""""
" Set options "
"""""""""""""""
set encoding=utf-8 " nvim should also use UTF8 by default

set autoread " This should make vim automatically read changes from disk
             " However, vim doesn't regularly check for changes, making this
             " less useful than you'd hope.

set expandtab " Make tabs expand to spaces ("softtabs")
set shiftwidth=2 " Define tab length as 2 spaces
set tabstop=4 " Display hardtabs as four spaces

set ruler " Enable line and column numbers in bot-right corner
set number " Enable line numbers
set numberwidth=8 " Reserve at least 8 cols for linenumbers (last 1 is a space)

" Set line endings to Unix-style (LF or `\n`)
set ff=unix
autocmd BufNewFile * setlocal ff=unix

set linebreak " Enable line wrapping at word ends
set colorcolumn=80
set cursorline

" Set a backup statusline
set statusline=%f%r%m%h%=Line\ %l/%L\ \|\ Column\ %c\ \|\ (%P)

if (has("win32"))
  set shell=cmd.exe
endif

""""""""""""""""""""
" Set key mappings "
""""""""""""""""""""
" --NORMAL-- CTRL+[H,L] should be the name as CTRL+[LEFT,RIGHT]
nnoremap <C-h> <C-Left>
nnoremap <C-l> <C-Right>

" --NORMAL-- Allow paragraph-wise navigation with CTRL+[UP,DOWN]
nnoremap <C-Up> {
nnoremap <C-Down> }

" --NORMAL-- Allow the same with CTRL[j,k]
nnoremap <C-k> {
nnoremap <C-j> }

" --TERMINAL-- Allow exiting out of terminal mode with ESC
tnoremap <Esc> <C-\><C-n>

" --TERMINAL-- Allow pressing ESC in terminal mode (for vim in vim)
tnoremap <C-^> <Esc>


"""""""""""""""""
" Setup plugins "
"""""""""""""""""
" The think I yoinked to download Plug if it isn't available
" I have no idea if this works btw, I just joinked it and that's it.
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plug (Plugin Manager)
call plug#begin(stdpath('data') . '/plugged')

  " Themes
  Plug 'navarasu/onedark.nvim'
  Plug 'embark-theme/vim', { 'as': 'embark', 'branch': 'main' }
  Plug 'drewtempelmeyer/palenight.vim'
  Plug 'srcery-colors/srcery-vim'
  Plug 'phanviet/vim-monokai-pro'
  Plug 'pineapplegiant/spaceduck'
  Plug 'Rigellute/shades-of-purple.vim'
  Plug 'wadackel/vim-dogrun'

  " GitSigns
  Plug 'lewis6991/gitsigns.nvim'

  " Stuff for statusline
  Plug 'ryanoasis/vim-devicons'
  Plug 'itchyny/vim-gitbranch'
  Plug 'itchyny/lightline.vim'

  " Syntax Highlighting
  Plug 'pangloss/vim-javascript'

  " Dependencies
  Plug 'nvim-treesitter/nvim-treesitter'
  Plug 'neovim/nvim-lspconfig'

  " Other random utilities
  Plug 'ap/vim-css-color'
  Plug 'SmiteshP/nvim-navic'
  Plug 'andweeb/presence.nvim' " Discord Rich Presence
  Plug 'ellisonleao/glow.nvim' " Markdown Glow Preview

  Plug 'tpope/vim-obsession'

call plug#end()

" ===== Plugin configuration (except Lightline) =====
" Treesitter
lua <<EOF
  require("nvim-treesitter.configs").setup {
    ensure_installed = "all",
    highlight = { enable = true }
  }
  require("nvim-treesitter.install").compilers = { "clang" }
EOF

" Gitsigns
lua require('gitsigns').setup()
set signcolumn=yes:1 " Always show signcolumn to prevent jumping on first edit

" LSP
lua <<EOF
  -- LSP for TypeScript (supports nvim-navic)
  require("lspconfig").tsserver.setup {
    on_attach = function(client, bufnr)
      require("nvim-navic").attach(client, bufnr)
    end,
    filetypes = {
      --"javascript", "javascriptreact", "javascript.jsx",
      "typescript", "typescriptreact", "typescript.tsx"
    }
  }

  -- ESLint LSP server
  require("lspconfig").eslint.setup {
    on_attach = function(client, bufnr)
      vim.api.nvim_create_autocmd(
        "BufWritePre", {
          pattern = "<buffer=" .. bufnr .. ">",
          command = "EslintFixAll"
        }
      )
      vim.api.nvim_win_set_option(vim.fn.win_getid(), "signcolumn", "yes:3")

      print("  "
        .. "[" .. bufnr .. "] "
        .. "ESLint LSP attached; "
        .. "EslintFixAll AutoCMD installed; "
        .. "signcolumn enlargened (-> yes:3)"
      )
    end,
    filetypes = {
      "javascript", "javascriptreact", "javascript.jsx",
      "typescript", "typescriptreact", "typescript.tsx"
    }
  }

  -- LSP for RustLang (supports nvim-navic)
  require("lspconfig").rust_analyzer.setup {
    on_attach = function(client, bufnr)
      require("nvim-navic").attach(client, bufnr)
    end
  }

  -- LSP for Java
  require("lspconfig").java_language_server.setup {
    cmd = {
      "F:\\java-language-server\\dist\\lang_server_windows.cmd"
    },
    on_attach = function(client, bufnr)
      require("nvim-navic").attach(client, bufnr)
    end,
    filetypes = { "java" }
  }

  -- LSP for VimL (supports nvim-navic)
  require("lspconfig").vimls.setup {
    on_attach = function(client, bufnr)
      require("nvim-navic").attach(client, bufnr)
    end,
    filetypes = { "vim" }
  }
EOF

" presence.nvim (Discord Rich Presence)
lua <<EOF
  require("presence"):setup({
    auto_update         = true,
    neovim_image_text   = "NeoVIM",
    main_image          = "file",
    log_level           = "error",
    debounce_timeout    = 2,
    blacklist           = {},
    buttons             = true,
    show_timer          = false,

    editing_text        = "Editing %s",
    file_explorer_text  = "Browsing through files",
    git_commit_text     = "`git commit`ing",
    plugin_manager_text = "Performing maintenance...",
    reading_text        = "Reading %s",
    workspace_text      = "In %s",
    line_number_text    = "On line %s / %s"
  })
EOF

"""""""""""""""""""
" Visual Settings "
"""""""""""""""""""
" Functions for Lightline
function! GetGitBranchWithIcon()
  if gitbranch#name() != ''
    return ' ' . gitbranch#name()
  endif

  " If no branch could be found, return an empty string
  return ''
endfunction

function! GetFiletypeIcon()
  let currentFileName = expand('%:t') " This gets only the extension (w/o '.')
  let fileTypeIcon = WebDevIconsGetFileTypeSymbol(currentFileName)

  if fileTypeIcon != ''
    " If there is one, return just the icon
    return fileTypeIcon
  endif

  " Return the filetype name if no icon could be found
  return &filetype
endfunction

function! LinePercent()
  let currentLine = line('.')
  let numberOfLines = line('$')

  if currentLine == 1
    return 'Top'
  elseif currentLine == numberOfLines
    return 'Bot'
  else
    let percentage = currentLine * 100 / numberOfLines
    if percentage < 10
      return '0' . percentage . '%'
    else
      return percentage . '%'
    endif
  endif

endfunction

function! GetLineInfoWithIcon()
  return '  ' . line('.') . ':' . col('.') . ' (' . LinePercent() . ')'
endfunction

function! GetReadOnlyIcon()
  if &readonly == 1
    return ''
  endif
  return ''
endfunction

function GetGpsLocation()
  if luaeval("require('nvim-navic').is_available()")
    return luaeval("require('nvim-navic').get_location()")
  endif
  return "  Navic Not Available"
endfunction

function CustomObsessionStatus()
  let obsess_active = " "
  let obsess_paused = " "
  let obsess_error  = " "

  if !exists(":Obsession")
    return obsess_error
  endif

  let raw = ObsessionStatus(obsess_active, obsess_paused)
  if raw == ""
    return obsess_error
  endif
  return raw
endfunction

" Configure lightline
lua <<EOF
  vim.g.lightline = {
    colorscheme = "embark",
    active = {
      left = {
        { "mode", "paste" },
        { "readonlyicon", "filename", "modified" },
        { "gpslocation" }
      },
      right = {
        { "gitbranch", "lineinfowithicon" },
        { "obsession", "filetypeicon", "fileencoding" }
      }
    },
    inactive = {
      left = {
        { "paste" },
        { "readonlyicon", "filename", "modified" }
      },
      right = {
        { "lineinfowithicon" },
        { "filetypeicon" }
      }
    },
    component_function = {
      gitbranch = "GetGitBranchWithIcon",
      filetypeicon = "GetFiletypeIcon",
      lineinfowithicon = "GetLineInfoWithIcon",
      readonlyicon = "GetReadOnlyIcon",
      gpslocation = "GetGpsLocation",
      obsession = "CustomObsessionStatus"
    }
  }
EOF
set noshowmode " Hide --INSERT-- and so on, as it is shown in the lightline

" Configure vim-javascript plugins
let g:javascript_plugin_jsdoc = 1

" Set the editor background for default colorschemes
set background=dark

" Background color fix
if (has("termguicolors"))
  set termguicolors
endif

"== Set the active color scheme! (Commented themes are installed but inactive)
" colorscheme onedark
" colorscheme palenight
colorscheme embark
" colorscheme srcery
" colorscheme monokai_pro
" colorscheme spaceduck
" colorscheme shades_of_purple

" Manually map file extensions
autocmd BufNewFile,BufRead *.html :set syntax=html

" Map custom file extensions
autocmd BufNewFile,BufRead *.bash.kdfpatch :set filetype=bash

" Import system-specific configurations, if existant
if !empty(glob(expand("~/.config/nvim/systeminit.vim")))
  source ~/.config/nvim/systeminit.vim
endif

if !empty(glob(expand("~/.local/share/nvim/site/autoload/systeminit.vim")))
  source ~/.local/share/nvim/site/autoload/systeminit.vim
endif
