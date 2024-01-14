
#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

# This setup will allow to authenticate with an enrolled
# fingerprint. If no fingerprint is enrolled the auth will
# move on to password auth.

authselect enable-feature with-fingerprint
authselect apply-changes