return require('packer').startup(function()
	use 'wbthomason/packer.nvim'

	-- color scheme
	use "rebelot/kanagawa.nvim"

	-- LSPs
	use 'williamboman/mason.nvim'
	use 'williamboman/mason-lspconfig.nvim'

	-- lspconfig and rust-tools
	use 'neovim/nvim-lspconfig'
	use 'simrat39/rust-tools.nvim'

	-- completions
	use 'hrsh7th/nvim-cmp' 
	use 'hrsh7th/cmp-vsnip'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-nvim-lsp-signature-help'
	use 'hrsh7th/cmp-nvim-lua'
	use 'hrsh7th/cmp-path'                              
	use 'hrsh7th/cmp-buffer'                            

	-- diagnostics
	use 'folke/trouble.nvim'
	use 'nvim-tree/nvim-web-devicons'
end)
