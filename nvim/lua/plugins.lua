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
  -- Note: run `brew install ripgrep` to enable Telescope live-grep
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function ()
      require('telescope').setup{
        defaults = {
          layout_strategy = "vertical",
          layout_config = {
            height = vim.o.lines - 5,
            width = vim.o.columns - 8,
            prompt_position = "top",
            preview_height = 0.6, -- 60% of available lines
          },
        },
      }
    end
  }

  -- Themes
  use {'dracula/vim', as = 'dracula'}
  use 'EdenEast/nightfox.nvim'
  use 'morhetz/gruvbox'

  -- Clojure Plugins
  use {'google/vim-codefmt', requires = {'google/vim-maktaba', 'google/vim-glaive'}}
  use 'Olical/conjure'
  use 'guns/vim-sexp'
  use 'tpope/vim-sexp-mappings-for-regular-people'
  use 'easymotion/vim-easymotion'
  use 'dense-analysis/ale'
  use 'nvim-treesitter/nvim-treesitter-context'

  -- Vim Jack In
  use 'tpope/vim-dispatch'
  use 'clojure-vim/vim-jack-in'
  use 'radenling/vim-dispatch-neovim'

  -- Autocomplete
  use 'Shougo/deoplete.nvim'
  use 'ncm2/float-preview.nvim'

  -- Copilot
  use 'github/copilot.vim'

  -- Galaxyline
  use({
  'glepnir/galaxyline.nvim',
  branch = 'main',
  -- your statusline
  config = function()
    require("customline")
  end,
  -- some optional icons
  requires = { 'nvim-tree/nvim-web-devicons', opt = true },
})
end)
