-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'google/vim-maktaba'
  use 'google/vim-glaive'
  use 'google/vim-codefmt'
  use {'dracula/vim', as = 'dracula'}
end)
