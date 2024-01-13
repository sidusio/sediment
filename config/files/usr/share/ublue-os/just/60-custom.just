import '100-bling.just'

# It is preferrable to install this into user-space since
# that allows for nice integration with distroboxes.
@asdf:
    echo 'Downloading'
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
    echo 'Installing'
    source ~/.asdf/asdf.fish
    echo 'Adding completions'
    mkdir -p ~/.config/fish/completions; and ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
