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
end)
