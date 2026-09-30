return {
    {
        "bjarneo/aether.nvim",
        branch = "v2",
        name = "aether",
        priority = 1000,
        opts = {
            transparent = false,
            colors = {
                -- Background colors
                bg = "#0d1117",
                bg_dark = "#0d1117",
                bg_highlight = "#484f58",

                -- Foreground colors
                -- fg: Object properties, builtin types, builtin variables, member access, default text
                fg = "#f0f6fc",
                -- fg_dark: Inactive elements, statusline, secondary text
                fg_dark = "#b1bac4",
                -- comment: Line highlight, gutter elements, disabled states
                comment = "#484f58",

                -- Accent colors
                -- red: Errors, diagnostics, tags, deletions, breakpoints
                red = "#ff7b72",
                -- orange: Constants, numbers, current line number, git modifications
                orange = "#ffa198",
                -- yellow: Types, classes, constructors, warnings, numbers, booleans
                yellow = "#d29922",
                -- green: Comments, strings, success states, git additions
                green = "#3fb950",
                -- cyan: Parameters, regex, preprocessor, hints, properties
                cyan = "#39c5cf",
                -- blue: Functions, keywords, directories, links, info diagnostics
                blue = "#58a6ff",
                -- purple: Storage keywords, special keywords, identifiers, namespaces
                purple = "#bc8cff",
                -- magenta: Function declarations, exception handling, tags
                magenta = "#d2a8ff",
            },
        },
        config = function(_, opts)
            require("aether").setup(opts)
            vim.cmd.colorscheme("aether")

            -- Enable hot reload
            require("aether.hotreload").setup()
        end,
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "aether",
        },
    },
}
