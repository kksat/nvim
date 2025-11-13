return {
  "L3MON4D3/LuaSnip",
  -- build = "make install_jsregexp",
  -- dependencies = {
  --   "rafamadriz/friendly-snippets",
  -- },
  config = function()
    -- local ls = require("luasnip")

    -- ls.config.set_config({
    --   history = true,
    --   updateevents = "TextChanged,TextChangedI",
    --   enable_autosnippets = true,
    --   ext_opts = {
    --     [require("luasnip.util.types").choiceNode] = {
    --       active = {
    --         virt_text = { { "●", "GruvboxOrange" } },
    --       },
    --     },
    --   },
    -- })

    -- Load snippets from friendly-snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Load custom lua snippets
    require("luasnip.loaders.from_lua").lazy_load({ paths = vim.fn.stdpath("config") .. "/lua/plugins/luasnippets" })

    -- -- Keybindings for snippet navigation
    -- vim.keymap.set({ "i", "s" }, "<C-k>", function()
    --   if ls.expand_or_jumpable() then
    --     ls.expand_or_jump()
    --   end
    -- end, { silent = true, desc = "Expand or jump forward in snippet" })

    -- vim.keymap.set({ "i", "s" }, "<C-j>", function()
    --   if ls.jumpable(-1) then
    --     ls.jump(-1)
    --   end
    -- end, { silent = true, desc = "Jump backward in snippet" })

    -- vim.keymap.set({ "i", "s" }, "<C-l>", function()
    --   if ls.choice_active() then
    --     ls.change_choice(1)
    --   end
    -- end, { silent = true, desc = "Cycle through choice nodes" })
  end,
}
