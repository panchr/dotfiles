#!/bin/bash
#
# init-full.sh installs and configures everything: core, agents, and misc.

set -euxo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
"$SCRIPT_DIR/init.sh" --agents --misc "$@"
