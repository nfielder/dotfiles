local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
    return
end

-- Set to false to disable icons if fonts are not supported
local enable_fancy_icons = true

local opts
if enable_fancy_icons then
    opts = {
        theme = "PaperColor"
    }
else
    opts = {
        icons_enabled = false,
        section_separators = "",
        component_separators = "|",
        theme = "PaperColor"
    }
end

lualine.setup {
    options = opts
}
