-- smear cursor plugin --
return {
    'sphamba/smear-cursor.nvim',

    opts = {
        smear_between_buffers = true,
        smear_between_neighbor_lines = true,
        scroll_buffer_space = true,
        legacy_computing_symbols_support = false,
        smear_insert_mode = true,
        vertical_bar_cursor = true,
        vertical_bar_cursor_insert_mode = true,
    },
}
