-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- LuaSnip config
-- require("luasnip.loaders.from_vscode").load({ include = { "python" } }) -- Load only python snippets
-- The directories will have to be structured like eg. <https://github.com/rafamadriz/friendly-snippets> (include
-- a similar `package.json`)
-- require("luasnip.loaders.from_vscode").lazy_load({ paths = { "~/.config/Code/User/snippets" } }) -- Load snippets from VS Code folder

-- You can also use lazy loading so you only get in memory snippets of languages you use
-- require("luasnip.loaders.from_vscode").lazy_load() -- You can pass { paths = "./my-snippets/"} as well
