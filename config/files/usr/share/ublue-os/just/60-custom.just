!include 100-bling.just
# Include some of your custom scripts here!

# Make fish your SHELL
fish:
    #!/usr/bin/env bash
    if [[ -f ~/.bashrc && $(tail -n 1 ~/.bashrc) != "SHELL=/usr/bin/fish" ]]; then
        echo "SHELL=/usr/bin/fish" >> ~/.bashrc
    fi