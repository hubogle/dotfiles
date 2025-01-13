local opts = {
    autostart = true, -- Automatically start the plugin on load?

    -- Function to determine if a session should be saved
    ---@type fun(): boolean
    should_save = function()
        -- Do not save if the alpha dashboard is the current filetype
        if vim.bo.filetype == "alpha" then
            return false
        end
        return true
    end,

    save_dir = vim.fn.expand(vim.fn.stdpath "data" .. "/sessions/"), -- Directory where session files are saved

    follow_cwd = true, -- Change the session file to match any change in the cwd?
    use_git_branch = false, -- Include the git branch in the session file name?
    autoload = false, -- Automatically load the session for the cwd on Neovim startup?

    -- Function to run when `autoload = true` but there is no session to load
    ---@type fun(): any
    on_autoload_no_session = function() end,

    allowed_dirs = {}, -- Table of dirs that the plugin will start and autoload from
    ignored_dirs = {
        -- { vim.fn.hostname(), exact = true },
        { "~", exact = true },
        { "/", exact = true },
        { "/tmp", exact = true },
    }, -- Table of dirs that are ignored for starting and autoloading

    telescope = {
        mappings = { -- Mappings for managing sessions in Telescope
            copy_session = "<C-c>",
            change_branch = "<C-b>",
            delete_session = "<C-d>",
        },
        icons = { -- icons displayed in the Telescope picker
            selected = " ",
            dir = "  ",
            branch = " ",
        },
    },
}
return opts
