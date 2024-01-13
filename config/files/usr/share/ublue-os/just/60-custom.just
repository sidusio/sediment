import '100-bling.just'

@asdf:
  echo 'Downloading'
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
  echo 'Installing'
  source ~/.asdf/asdf.fish
  echo 'Adding completions'
  mkdir -p ~/.config/fish/completions; and ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions