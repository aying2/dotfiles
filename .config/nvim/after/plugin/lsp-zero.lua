-- Learn the keybindings, see :help lsp-zero-keybindings
-- Learn to configure LSP servers, see :help lsp-zero-api-showcase
local lsp = require('lsp-zero')
lsp.preset('lsp-compe')

vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

-- (Optional) Configure lua language server for neovim
lsp.nvim_workspace()

lsp.set_preferences({
  sign_icons = {
     error = '',
     warn = '',
     hint = '',
     info = '',
  }
})

lsp.on_attach(function(client, bufnr)
    local opts = {buffer = bufnr, remap = false}

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

local luasnip = require("luasnip")
local cmp = require("cmp")
local cmp_enabled = cmp.get_config().enabled

local cmp_config = lsp.defaults.cmp_config({
    mapping = lsp.defaults.cmp_mappings({
        -- don't complete using <Enter>
        ['<CR>'] = vim.NIL,
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm()
            elseif luasnip.jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),

    }),
    enabled = function()
        if require('cmp.config.context').in_treesitter_capture('comment') == true
            or require('cmp.config.context').in_syntax_group('Comment')
        then
             return false
         else
             -- execute cmp's original function
              return cmp_enabled()
        end
    end,
})

cmp.setup(cmp_config)
