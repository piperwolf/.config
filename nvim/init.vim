lua require('plugins')

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
colorscheme dracula

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

