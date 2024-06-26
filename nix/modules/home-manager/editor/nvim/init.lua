-- set vim runtime paths for compatibility
vim.cmd [[
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
]]

-- load legacy settings first
vim.cmd 'silent! source ~/.vimrc'

-- helper variables
local o = vim.o
local g = vim.g

-------------------------------------------------------------------------------

-- Enable encoding
o.encoding = "utf-8"

-- Custom timeouts
o.timeout = true
o.timeoutlen = 500

-- Editor settings
--  Whitespace rendering
o.listchars = 'tab:→ ,extends:❯,precedes:❮,trail:·,nbsp:·,space:·'
-- o.listchars = 'tab:▷▷⋮,extends:❯,precedes:❮,trail:·,nbsp:·,space:·'
o.showbreak = '↪'
--  Hidden buffers
o.hidden = true
-- Hidden mode
o.showmode = false

-------------------------------------------------------------------------------

vim.cmd [[
  function! QuickFixToggle()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
      copen
    else
      cclose
    endif
endfunction
]]

_G.MUtils= {}

local hasnpairs,npairs = pcall(require,"nvim-autopairs")

if hasnpairs then
  MUtils.CR = function()
    if vim.fn.pumvisible() ~= 0 then
      if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
        return npairs.esc('<c-y>')
      else
        return npairs.esc('<c-e>') .. npairs.autopairs_cr()
      end
    else
      return npairs.autopairs_cr()
    end
  end
  vim.api.nvim_set_keymap('i', '<cr>', 'v:lua.MUtils.CR()', { expr = true, noremap = true })

  MUtils.BS = function()
    if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ 'mode' }).mode == 'eval' then
      return npairs.esc('<c-e>') .. npairs.autopairs_bs()
    else
      return npairs.autopairs_bs()
    end
  end
  vim.api.nvim_set_keymap('i', '<bs>', 'v:lua.MUtils.BS()', { expr = true, noremap = true })
end

local mappings = {
  i = { -- Insert mode

    { "<A-j>", "<ESC><cmd>m .+1<CR>==gi" },
    { "<A-k>", "<ESC><cmd>m .-2<CR>==gi" },

    -- Save while writing
    { "<C-s>", "<ESC><C-s>", { noremap = false }},
  },
  n = { -- Normal mode

    -- Remove trailing whitespaces and save
    { "<C-s>", "<cmd>%s/\\s\\+$//e<cr><cmd>w<cr>" },

    -- Toggle spell
    { "<F1>", "<cmd>set spell!<CR>" },

    -- Toggle Highlighted search
    { "<F3>", "<cmd>set hlsearch!<CR>" },
    -- Build
    { "<F5>", "<cmd>make<cr>" },
    -- Toogle Tagbar
    { "<F8>", "<cmd>TagbarToggle<cr>" },
    -- Float Terminal
    { "<F12>", "<cmd>FloatermToggle<cr>", { silent = true, noremap = true } },

    -- Make d(elete) and similar actually delete
    { "\\d", "\"_d" },
    { "\\D", "\"_D" },
    { "\\x", "\"_x" },
    { "\\c", "\"_c" },

    -- Navigation

    --  Tree
    { "<leader>vt", "<cmd>NvimTreeToggle<cr>" },

    -- Command palette
    { "<leader>vp", "<cmd>Telescope<cr>" },
    -- View Telekasten panel
    { "<leader>vz", "<cmd>Telekasten panel<cr>" },


    -- View
    --  Reset view
    { "<leader>vr",
      table.concat({
        "<cmd>NvimTreeOpen<cr>",
        "<cmd>windo set nonumber<cr>",
        "<cmd>windo set norelativenumber<cr>",
        "<cmd>windo set nolist<cr>",
        "<cmd>NvimTreeClose<cr>",
        "<cmd>tabdo windo set number<cr>",
        "<cmd>tabdo windo set list<cr>",
        "<cmd>tabdo windo set colorcolumn=80<cr>",
        }, ''
      );
    },

    --  Buffers
    { "<C-n>b", "<cmd>bn<cr>" },
    { "<C-p>b", "<cmd>bp<cr>" },

    --  Diagnostics
    { "<C-p>d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>" },
    { "<C-n>d", "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>" },

    --  LSP Hover description
    { "<C-Space>", "<cmd>lua vim.lsp.buf.hover()<cr>" },
    { "<A-Space>", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>" },

    --  Goto symbol
    { "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<cr>" },
    { "<leader>gdd", "<cmd>Telescope lsp_definitions<cr>" },
    { "<leader>gdt", "<cmd>Telescope lsp_type_definitions<cr>" },
    { "<leader>gi", "<cmd>Telescope lsp_implementations<cr>" },
    { "<leader>gr", "<cmd>Telescope lsp_references<cr>" },

    -- Git
    { "<leader>GC", "<cmd>Telescope git_commits<cr>" },
    { "<leader>Gc", "<cmd>Telescope git_bcommits<cr>" },
    { "<leader>Gb", "<cmd>Telescope git_branches<cr>" },
    { "<leader>Gs", "<cmd>Telescope git_status<cr>" },

    -- Document actions
    { "<leader>aa", "<cmd>lua vim.lsp.buf.code_action()<cr>" },
    { "<leader>ar", "<cmd>lua vim.lsp.buf.rename()<cr>"},
    { "<leader>af", "<cmd>lua vim.lsp.buf.formatting()<cr>" },

    --  Find
    { "<leader>fF", "<cmd>lua require'plugconf/telescope'.project_files()<cr>" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>" },
    { "<leader>fd", "<cmd>Telescope lsp_document_symbols<cr>" },
    { "<leader>fw", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>" },
    { "<leader>fs", "<cmd>Telescope grep_string<cr>" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>" },
    { "<leader>fp", "<cmd>Telescope diagnostics bufnr=0<cr>" },
    { "<leader>fP", "<cmd>Telescope diagnostics<cr>" },
    { "<leader>fH", "<cmd>Telescope help_tags<cr>" },

    { "<leader>1", "<cmd>BufferLineGoToBuffer 1<cr>" },
    { "<leader>2", "<cmd>BufferLineGoToBuffer 2<cr>" },
    { "<leader>3", "<cmd>BufferLineGoToBuffer 3<cr>" },
    { "<leader>4", "<cmd>BufferLineGoToBuffer 4<cr>" },
    { "<leader>5", "<cmd>BufferLineGoToBuffer 5<cr>" },
    { "<leader>6", "<cmd>BufferLineGoToBuffer 6<cr>" },
    { "<leader>7", "<cmd>BufferLineGoToBuffer 7<cr>" },
    { "<leader>8", "<cmd>BufferLineGoToBuffer 8<cr>" },
    { "<leader>9", "<cmd>BufferLineGoToBuffer 9<cr>" },

    -- Telekasten
    { "<leader>zf", "<cmd>Telekasten find_notes<cr>" },
    { "<leader>zg", "<cmd>Telekasten search_notes<cr>" },
    { "<leader>zd", "<cmd>Telekasten goto_today<cr>" },
    { "<leader>zn", "<cmd>Telekasten new_note<cr>" },
    { "<leader>zc", "<cmd>Telekasten show_calendar<cr>" },
    { "<leader>zb", "<cmd>Telekasten show_backlinks<cr>" },
    { "<leader>zi", "<cmd>Telekasten insert_link<cr>" },
    { "<leader>zI", "<cmd>Telekasten insert_img_link<cr>" },

    --  Move lines up and down
    { "<A-j>", "<cmd>m .+1<CR>=="},
    { "<A-k>", "<cmd>m .-2<CR>=="},
  },

  v = {
    -- Delete to void register
    { "\\d", "\"_d" },
    { "\\c", "\"_c" },
    { "\\p", "\"_dp" },
    { "\\P", "\"_dP" },
    { "\\/", "\"fy/<C-R>f", { silent = false }},
    { "<C-a>", "<ESC>ggVG"},

    -- Keep visual mode on Tab and S-Tab
    { "<Tab>", ">gv" },
    { "<S-Tab>", "<gv" },
  },
  t = {
    -- Toggle float terminal
    { "<F12>", "<C-\\><C-n><cmd>FloatermToggle<cr>", { silent = true, noremap = true } },
  },
  [""] = {
    -- Toggle the QuickFix window
    { "<C-q>", "<cmd>call QuickFixToggle()<CR>" },
  },
}

-- register the set mappings
local function register_mappings(mappings, default_options)
    for mode, mode_mappings in pairs(mappings) do
    for _, mapping in pairs(mode_mappings) do
        local options = #mapping == 3 and table.remove(mapping) or default_options
        local prefix, cmd = unpack(mapping)
        pcall(vim.api.nvim_set_keymap, mode, prefix, cmd, options)
    end
    end
end

register_mappings(mappings, { silent = true, noremap = true })
