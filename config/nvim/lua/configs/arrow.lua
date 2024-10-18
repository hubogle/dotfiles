local opts = {
    show_icons = true,
    leader_key = "m", -- Recommended to be a single key
    buffer_leader_key = "M", -- Per Buffer Mappings
    always_show_path = false,
    separate_by_branch = false, -- Bookmarks will be separated by git branch
    hide_handbook = false, -- set to true to hide the shortcuts on menu.
    custom_actions = {
        open = function(target_file_name, current_file_name)
            vim.cmd("edit " .. target_file_name)
        end, -- target_file_name = file selected to be open, current_file_name = filename from where this was called
        split_vertical = function(target_file_name, current_file_name)
            vim.cmd("vsplit " .. target_file_name)
        end,
        split_horizontal = function(target_file_name, current_file_name)
            vim.cmd("split " .. target_file_name)
        end,
    },
    window = { -- controls the appearance and position of an arrow window (see nvim_open_win() for all options)
        width = "auto",
        height = "auto",
        row = "auto",
        col = "auto",
        border = "double",
    },
}
return opts
