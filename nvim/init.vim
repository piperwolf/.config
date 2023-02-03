""" Import Plugins
lua require('plugins')
lua require('treesitter-config')

""" Main Configurations
filetype plugin indent on
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab smarttab autoindent
set incsearch ignorecase smartcase hlsearch
set wildmode=longest,list,full wildmenu
set ruler laststatus=2 showcmd showmode
set list listchars=trail:»,tab:»-
set fillchars+=vert:\ 
set wrap breakindent
set encoding=utf-8
set textwidth=0
set hidden
set title
set splitright
colorscheme dracula

""" Remappings

" Leader key
let mapleader = "\<space>"
let maplocalleader = "\<space>"

" Stop highlighting
nnoremap <leader>n <cmd>noh<cr>

" Map addition operation
nnoremap <C-a> <C-c>

" Conjure
let g:conjure#log#wrap = v:true

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>ft <cmd>Telescope<cr>
nnoremap <leader>fk <cmd>Telescope keymaps<cr>

" Scroll Cursor
map <ScrollWheelUp> <Up>
map <ScrollWheelDown> <Down>

" Fix issue causing telescope to cause "Not Allowed" error
autocmd FileType TelescopePrompt call deoplete#custom#buffer_option('auto_complete', v:false)

""" Autocomplete configuration
""" NOTE: Requires installing python3 + neovim module

let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('keyword_patterns', {'clojure': '[\w!$%&*+/:<=>?@\^_~\-\.#]*'})
set completeopt-=preview

let g:float_preview#docked = 0
let g:float_preview#max_width = 80
let g:float_preview#max_height = 40

""" vim-codefmt setup
call glaive#Install()
autocmd FileType clojure AutoFormatBuffer cljstyle

""" Linting
""" Before using kondo: https://github.com/clj-kondo/clj-kondo/blob/master/doc/install.md
let g:ale_linters = {'clojure': ['clj-kondo']}

