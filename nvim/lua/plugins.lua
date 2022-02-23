-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- treesitter + rainbow parens
  use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate'
  }
  use 'p00f/nvim-ts-rainbow'

  -- Editor Plugins
  use {'dracula/vim', as = 'dracula'}

  -- Clojure Plugins
  use {'google/vim-codefmt', requires = {'google/vim-maktaba', 'google/vim-glaive'}}
  use 'Olical/conjure'
  use 'guns/vim-sexp'
  use 'tpope/vim-sexp-mappings-for-regular-people'
  use 'easymotion/vim-easymotion'

  -- Vim Jack In
  use 'tpope/vim-dispatch'
  use 'clojure-vim/vim-jack-in'
  use 'radenling/vim-dispatch-neovim'

  -- Autocomplete
  use 'Shougo/deoplete.nvim'
  use 'ncm2/float-preview.nvim'
end)
