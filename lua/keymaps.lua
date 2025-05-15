-- [ Keymaps básicas ]
--

-- Limpar os highlights quando apertar <esc> no modo normal
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", {})

-- Modifica o atalho para fechar o terminal mais facilmente
-- Ainda permite utilizar o comando original <C-\><C-n> para sair do terminal
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", {})

local term_bufnr = nil
local term_winid = nil

-- Função para togglar um terminal
local function toggleTerminal()
	-- Se já tiver um terminal aberto, apenas o esconda
	if term_winid and vim.api.nvim_win_is_valid(term_winid) then
		vim.api.nvim_win_close(term_winid, true)
		term_winid = nil
		return
	end

	-- Se o terminal buffer não existir, crie um novo
	if not term_bufnr or not vim.api.nvim_buf_is_valid(term_bufnr) then
		vim.cmd("split") -- or use :split for horizontal
		term_winid = vim.api.nvim_get_current_win()
		vim.cmd("term")
		term_bufnr = vim.api.nvim_get_current_buf()
	else
		-- Reuse the terminal buffer in a new window
		vim.cmd("vsplit")
		term_winid = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(term_winid, term_bufnr)
	end

	-- Move to bottom and adjust height if needed
	vim.cmd("wincmd J")
	vim.api.nvim_win_set_height(0, 10)

	vim.cmd("startinsert") -- focus terminal input
end

-- Apaga o terminal atual
vim.keymap.set("t", "<leader>T", function()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local bufnr = vim.api.nvim_win_get_buf(win)
		if vim.bo[bufnr].buftype == "terminal" then
			vim.api.nvim_win_close(win, true)
		end
	end
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[bufnr].buftype == "terminal" then
			vim.api.nvim_buf_delete(bufnr, { force = true })
		end
	end
end)

vim.keymap.set("n", "<leader>t", toggleTerminal)

-- Atalhos para mover o foco da tela em multi-tela
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- [ Autocommands básicos ]

-- Adicionar highlight quando copiar algo com yank
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})
