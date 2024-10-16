local opts = {
    panel = {
        auto_refresh = false,
        layout = {
            position = "right",
            ratio = 0.3,
        },
    },
    suggestion = {
        auto_trigger = false,
        keymap = {
            accept = "<C-e>",
        },
    },
}
return opts
