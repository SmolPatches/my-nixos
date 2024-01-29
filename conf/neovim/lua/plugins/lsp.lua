return {
    "neovim/nvim-lspconfig",
    dependencies = {
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
    },
    config = function()
	require("mason").setup()
	require("mason-lspconfig").setup()
	require("lspconfig").gopls.setup {}
	require("lspconfig").rust_analyzer.setup {}
	require("lspconfig").yamlls.setup {}
	require("lspconfig").zls.setup {}
	require("lspconfig").bashls.setup {}
	require("lspconfig").pyright.setup {}

    end
}
