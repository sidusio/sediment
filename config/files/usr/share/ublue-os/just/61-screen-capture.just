# Select an area of your screen to save, result will be opened in swappy which allows editing of the result.
screenshot-edit:
    slurp | grim -g - - | swappy -f -

# Select an area of your screen to save, result will automatically be saved to clipboard.
screenshot:
    slurp | grim -g - - | wl-copy	

# Record the screen, recordin is saved to ~/Videos/screencapture-{timestamp}.mkv
screencapture:
     wf-recorder -f "$HOME/Videos/screencapture-$(date +%Y-%m-%dT%H:%M:%S).mkv"
