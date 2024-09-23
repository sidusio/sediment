# Install mullvad VPN
mullvad:
    #!/usr/bin/env bash
    echo "# Downloading repo file"
    TEMP_FILE=$(mktemp)
    curl -sSfL https://repository.mullvad.net/rpm/stable/mullvad.repo > $TEMP_FILE
    echo "# Adding repo"
    sudo cp $TEMP_FILE /etc/yum.repos.d/mullvad.repo
    echo "# Installing package"
    rpm-ostree install mullvad-vpn

