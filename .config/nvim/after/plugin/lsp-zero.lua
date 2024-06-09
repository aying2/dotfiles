-- Learn the keybindings, see :help lsp-zero-keybindings
-- Learn to configure LSP servers, see :help lsp-zero-api-showcase
local lsp = require('lsp-zero')
lsp.preset('lsp-compe')

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

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

local on_attach = function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
    lsp.buffer_autoformat()
    -- Guard against servers without the signatureHelper capability
    if client.server_capabilities.signatureHelpProvider then
        require('lsp-overloads').setup(client, {})
    end

    local opts = { buffer = bufnr }
end

lsp.on_attach(on_attach)
lsp.setup()

-- not in Mason
require('lspconfig').qmlls.setup({
    cmd = { "qmlls6" },
    on_attach = on_attach,
})


require('lspconfig').clangd.setup({
    cmd = { "clangd", "--completion-style=detailed" },
    on_attach = on_attach,
})


local luasnip = require("luasnip")
local cmp = require("cmp")
local cmp_enabled = cmp.get_config().enabled

local ELLIPSIS_CHAR = '…'
local MAX_LABEL_WIDTH = 50
local MIN_LABEL_WIDTH = 50

local cmp_config = lsp.defaults.cmp_config({
    mapping = lsp.defaults.cmp_mappings({
        -- don't complete using <Enter>
        --['<CR>'] = cmp.mapping.confirm({ select = true }),
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
    formatting = {
        -- fields: kind, abbr, menu
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
cmp.setup(cmp_config)


local function trim_use(str)
    local pos = string.find(str, "%(use")

    if pos ~= nil then
        return string.sub(str, 1, pos - 1 - 1) .. "~"
    end
    return str
end

MAX_NAME_WIDTH = 20
MIN_NAME_WIDTH = 20
cmp_config.formatting = {
    -- fields: kind, abbr, menu
    format = function(entry, vim_item)
        local label = trim_use(vim_item.abbr)
        --local label = vim_item.abbr
        local truncated_label = vim.fn.strcharpart(label, 0, MAX_NAME_WIDTH)
        if truncated_label ~= label then
            vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
        elseif string.len(label) < MIN_NAME_WIDTH then
            local padding = string.rep(' ', MIN_NAME_WIDTH - string.len(label))
            vim_item.abbr = label .. padding
        end

        local menu = vim_item.menu
        local truncated_menu = vim.fn.strcharpart(menu, 0, MAX_LABEL_WIDTH - MAX_NAME_WIDTH)
        if truncated_menu ~= menu then
            vim_item.menu = truncated_menu .. ELLIPSIS_CHAR
        elseif string.len(menu) < MIN_LABEL_WIDTH then
            local padding = string.rep(' ', MIN_LABEL_WIDTH - string.len(menu) - MAX_NAME_WIDTH)
            vim_item.menu = menu .. padding
        end
        return vim_item
    end,
}
cmp.setup.filetype('rust', cmp_config)
