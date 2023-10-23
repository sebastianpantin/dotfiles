-- Nicer filetree than NetRW
return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("nvim-tree").setup()
        require("helpers.keys").map(
            { "n", "v" },
            "<leader>e",
            "<cmd>NvimTreeToggle<cr>",
            "Toogle file explorer"
        )
    end,
}
