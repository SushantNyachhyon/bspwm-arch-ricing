local status, null_ls = pcall(require, "null-ls")
if (not status) then return end

local augroup_format = vim.api.nvim_create_augroup("Format", { clear = true })
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting

null_ls.setup {
  sources = {
    diagnostics.eslint_d.with({
      diagnostics_format = '[eslint] #{m}\n(#{c})'
    }),
    formatting.eslint_d,
    formatting.prettier.with({
            filetypes={
                "css",
                "scss",
                "less",
                "html",
                "json",
                "yaml",
                "markdown",
                "markdown.mdx",
                "graphql",
                "handlebars"
            }
        }),
    formatting.black,
    formatting.prismaFmt,
    formatting.pint,
    formatting.blade_formatter
  },
  on_attach = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_clear_autocmds { buffer = 0, group = augroup_format }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup_format,
        buffer = 0,
        callback = function() vim.lsp.buf.format() end
      })
    end
  end,
}
