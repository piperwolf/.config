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
  use {'dracula/vim', as = 'dracula'}

  -- Clojure Plugins
  use 'google/vim-maktaba'
  use 'google/vim-glaive'
  use 'google/vim-codefmt'
  use 'Olical/conjure'
  use 'guns/vim-sexp'
  use 'tpope/vim-sexp-mappings-for-regular-people'
  use 'easymotion/vim-easymotion'

  -- Autocomplete
  use 'Shougo/deoplete.nvim'
  use 'ncm2/float-preview.nvim'
end)
