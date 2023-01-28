local keyset = vim.keymap.set

keyset('n', '<leader>f', '<cmd>Telescope find_files theme=get_dropdown<cr>')
keyset('n', '<leader>g', '<cmd>Telescope git_files theme=get_dropdown<cr>')
keyset('n', '<leader>s', '<cmd>Telescope live_grep theme=get_dropdown<cr>')
keyset('n', '<leader>b', '<cmd>Telescope buffers show_all_buffers=true theme=get_dropdown<cr>')
