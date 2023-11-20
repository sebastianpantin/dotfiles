function nvims
    set items default nvim-old nvim-new nvim-new2
    set config (printf "%s\n" $items | fzf --prompt=" Neovim Config  " --height=50% --layout=reverse --border --exit-0)
    if [ -z $config ]
        echo "Nothing selected"
        return 0
    else if [ $config = "default" ]
        set config ""
    end
    env NVIM_APPNAME=$config nvim $argv
end

bind \ca 'nvims\n'```
