local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

-- Autocommand that reloads neovim whenever you save the plugins.lua file
local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	command = "source <afile> | PackerCompile",
	group = packer_group,
	pattern = vim.fn.expand("plugins.lua"),
})

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	print "=================================="
	print "    Plugins are being installed"
	print "    Wait until Packer completes,"
	print "       then restart nvim"
	print "=================================="
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
	git = {
		clone_timeout = 300, -- Timeout, in seconds, for git clones
	},
})

return packer.startup(function(use)
	-- Packer can manage itself
	use({ "https://github.com/wbthomason/packer.nvim" })

	-- Telescope fuzzy finder
	use({
		"https://github.com/nvim-telescope/telescope.nvim", tag = "0.1.0",
		requires = { {"https://github.com/nvim-lua/plenary.nvim"} }
	})

	-- Treesitter for nicer highlighting
	use({
		"https://github.com/nvim-treesitter/nvim-treesitter",
		run = function()
			pcall(require("nvim-treesitter.install").update({ with_sync = true }))
		end,
	})

	-- LSP Setup
	use({
		"https://github.com/VonHeikemen/lsp-zero.nvim",
		requires = {
			-- LSP Support
			{"https://github.com/neovim/nvim-lspconfig"},
			{"https://github.com/williamboman/mason.nvim"},
			{"https://github.com/williamboman/mason-lspconfig.nvim"},

			-- Autocompletion
			{"https://github.com/hrsh7th/nvim-cmp"},
			{"https://github.com/hrsh7th/cmp-buffer"},
			{"https://github.com/hrsh7th/cmp-path"},
			{"https://github.com/saadparwaiz1/cmp_luasnip"},
			{"https://github.com/hrsh7th/cmp-nvim-lsp"},
			{"https://github.com/hrsh7th/cmp-nvim-lua"},

			-- Snippets
			{"https://github.com/L3MON4D3/LuaSnip"},
			{"https://github.com/rafamadriz/friendly-snippets"},
		}
	})

	-- Colourscheme
	use({
		"https://github.com/NLKNguyen/papercolor-theme",
		as = "PaperColor",
		config = function()
			vim.cmd("colorscheme PaperColor")
		end
	})

    -- Quick file switching
    use({ "https://github.com/theprimeagen/harpoon" })

    -- Status bar
	use({
        "https://github.com/nvim-lualine/lualine.nvim",
        requires = { "https://github.com/kyazdani42/nvim-web-devicons", opt = true }
    })

    -- Commenting
    use({
        "https://github.com/numToStr/Comment.nvim",
        config = function()
            pcall(require("Comment").setup())
        end
    })

	-- Other
	use({ "https://github.com/mbbill/undotree" })
	use({ "https://github.com/tpope/vim-fugitive" })
	use({ "https://github.com/preservim/nerdcommenter" })
	use({ "https://github.com/cespare/vim-toml" })
	use({ "https://github.com/hashivim/vim-terraform" })
	use({ "https://github.com/fatih/vim-go" })

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)
