return {
  "nvimdev/dashboard-nvim",
  opts = function(_, opts)
    local logo = [[
                                     __                
        ___     ___    ___   __  __ /\_\    ___ ___    
       / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  
      /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ 
      \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\
       \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/
    ]]
    logo = string.rep("\n", 8) .. logo .. "\n"
    opts.config.header = vim.split(logo, "\n")
  end,
}
