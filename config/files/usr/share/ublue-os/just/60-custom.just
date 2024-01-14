import '100-bling.just'

# It is preferrable to install this into user-space since
# that allows for nice integration with distroboxes.

# Install ASDF
@asdf:
    echo '=> Downloading'
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
    echo '=> Installing'
    echo 'source ~/.asdf/asdf.fish' >> ~/.config/fish/config.fish
    echo '=> Adding completions'
    mkdir -p ~/.config/fish/completions && ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
