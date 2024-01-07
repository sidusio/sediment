#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

# This is a workaround to set the SELinux context of
# the greetd binary correctly. 
# (See: https://github.com/sidusIO/sediment/pull/26)

cp /usr/bin/greetd /usr/local/bin/greetd
semanage fcontext -a -t xdm_exec_t /usr/local/bin/greetd
restorecon /usr/local/bin/greetd