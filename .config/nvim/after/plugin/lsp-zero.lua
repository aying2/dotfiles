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
    -- Guard against servers without the signatureHelper capability
    if client.server_capabilities.signatureHelpProvider then
        require('lsp-overloads').setup(client, { })
    end

    local opts = {buffer = bufnr, remap = false}

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "gd", function() vim.lsp.buf.declaration() end, opts)
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

--require('lspconfig').clangd.setup({
--    cmd = { "clangd", "--completion-style=detailed" },
--})

local luasnip = require("luasnip")
local cmp = require("cmp")
local cmp_enabled = cmp.get_config().enabled

local ELLIPSIS_CHAR = '…'
local MAX_LABEL_WIDTH = 55
local MIN_LABEL_WIDTH = 20

local cmp_config = lsp.defaults.cmp_config({
    mapping = lsp.defaults.cmp_mappings({
        -- don't complete using <Enter>
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
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
    formatting = {
        format = function(entry, vim_item)
            local label = vim_item.abbr
            local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
            if truncated_label ~= label then
                vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
            elseif string.len(label) < MIN_LABEL_WIDTH then
                local padding = string.rep(' ', MIN_LABEL_WIDTH - string.len(label))
                vim_item.abbr = label .. padding
            end
                return vim_item
        end,
    },
})
--table.insert(cmp_config.sources, {
--    name = 'nvim_lsp_signature_help'
--})
cmp.setup(cmp_config)
