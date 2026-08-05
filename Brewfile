# Terminal
brew "zsh"
brew "tmux"
cask "ghostty"

# Window management
cask "rectangle"

# System monitor in the menubar
cask "stats"

# Keep the machine awake on demand
tap "panchr/tap", trusted: true
cask "panchr/tap/espresso"

# Terminal utilities
brew "tree"
brew "vnstat"
brew "telnet"
brew "watch"
brew "grep"
brew "btop"
brew "ripgrep"
brew "rsync"
brew "the_silver_searcher"
brew "yq"
brew "jq"
brew "noti"
brew "fzf"
brew "fd"
brew "bat"
brew "riff"
brew "moor"
brew "prettier"
brew "mise"
brew "asciinema"

tap "teamookla/speedtest", trusted: true
brew "teamookla/speedtest/speedtest"

# Git
brew "gh"
brew "git"

# Emacs
tap "d12frosted/emacs-plus", trusted: true
brew "d12frosted/emacs-plus/emacs-plus@30"

# emacs-plus@30 declares libjpeg as build-only, but the built binary links against
# it at runtime. Brew therefore considers it removable and autoremove drops it,
# leaving Emacs unable to start. Pin it explicitly so it survives cleanup.
brew "jpeg"
# Runtime deps of emacs-plus@30 that went missing alongside jpeg.
brew "gcc"
brew "libgccjit"
brew "isl"
brew "mpfr"
brew "libmpc"
brew "tree-sitter@0.25"

# Agentic coding tools
cask "claude-code@latest"
cask "claude"
tap "anomalyco/tap", trusted: true
brew "anomalyco/tap/opencode"
tap "steveyegge/beads", trusted: true
brew "steveyegge/beads/bd"
tap "allthingsclaude/battery", trusted: true
cask "allthingsclaude/battery/claude-battery"

# Python
brew "openssl"
brew "readline"
brew "sqlite3"
brew "xz"
brew "zlib"

# Languages
brew "bazelisk"
brew "buildifier"
brew "clang-format"
brew "shellcheck"
brew "shfmt"
brew "terraform"
brew "tflint"
brew "llvm"
brew "xcodegen"

# Containers
brew "podman"

# Misc
brew "awscli"
brew "binwalk"
brew "findutils"
brew "coreutils"
brew "gnutls"
brew "gnupg"
brew "ffmpeg"
brew "imagemagick"
brew "openssh"
brew "pinentry-mac"
cask "utm"
