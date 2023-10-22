function pya -d "Activates the current project's Python virtualenv"
    if [ -e "Pipfile" ]
        command pipenv shell --fancy
    else if [ -e ".python-version" ]
        pyenv activate (cat ".python-version")
    else if [ -e "pyproject.toml" ]
        set -l path (poetry env info -p)
        source $path/bin/activate.fish
    else
        echo "No virtual environment found for this project!"
    end
end
