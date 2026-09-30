-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<C-S-e>", "<Cmd>belowright split | terminal<CR>", { desc = "Open terminal below" })
vim.keymap.set("n", "<C-S-o>", "<Cmd>belowright vsplit | terminal<CR>", { desc = "Open terminal right" })

-- Switch between split windows/terminals with SUPER + arrows
for _, map in ipairs({
  { "<D-Left>", "h" },
  { "<D-Right>", "l" },
  { "<D-Up>", "k" },
  { "<D-Down>", "j" },
}) do
  vim.keymap.set("n", map[1], "<C-w>" .. map[2], { desc = "Super Arrow: window " .. ({ h = "left", l = "right", k = "above", j = "below" })[map[2]] })
  vim.keymap.set("t", map[1], "<C-\\><C-n><C-w>" .. map[2], { desc = "Super Arrow: window " .. ({ h = "left", l = "right", k = "above", j = "below" })[map[2]] })
end
