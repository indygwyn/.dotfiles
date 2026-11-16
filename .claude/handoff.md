---
title: Claude handoff between home and work
updated: 2026-11-16
---

Home Claude and work Claude use this file to pass tasks across machines. Append a dated entry under "Open items", mark finished items under "Done", and commit it with the rest of the dotfiles. Never store secrets here.

## Open items

### 2026-11-16 (home to work): move `dotfiles` from alias to script

Home changed three things. Work needs a few steps to match.

Home changes:
- Added `~/.local/bin/dotfiles`, a script that runs `git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"`. It replaces `alias dotfiles` in `.bashrc`, so it works in scripts and agent shells.
- Added `*` to `~/.dotfiles/info/exclude` so `dotfiles add -A` and `dotfiles add .` stage nothing new. New files need `dotfiles add -f <path>`.
- Added `credential_command = "gh auth token --hostname github.com"` to `.config/mise/config.toml`, and removed the keychain token block from `.bash_profile`.

Work steps, in order:
1. Pull with the explicit command, because the old alias may still run: `git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" pull --ff-only`
2. Run `printf '*\n' >> ~/.dotfiles/info/exclude`. Git does not sync this file, so each machine needs this once.
3. Open a new shell and confirm `command -v dotfiles` prints `~/.local/bin/dotfiles`, not an alias.
4. Run `dotfiles add -A -n` and confirm it lists nothing.
5. Run `gh auth token --hostname github.com >/dev/null && echo ok`. mise now depends on it. If it fails, run `gh auth login`.
6. Check `mise doctor` or `mise ls` for GitHub rate limit or auth errors.
7. Report results below.

Completion (done on home): `.bashrc` now loads git completion and registers `_dotfiles_complete`, which sets `GIT_DIR` and `GIT_WORK_TREE` so branch and subcommand completion see the bare repo. It needs `bash-completion@2` (macOS: `brew install bash-completion@2`, already in `.Brewfile`; Linux: the distro `bash-completion` package). Without it the block does nothing and nothing breaks.

Extra work steps:
8. Run `brew install bash-completion@2` if missing, open a new shell, type `dotfiles checkout ma` then Tab, and confirm `main` completes.
9. If the old `bash-completion` (v1) also sits installed and `/opt/homebrew/etc/profile.d/bash_completion.sh` does not exist, tell home. Home saw this on twhmba.

### Work reply

(work Claude writes here)

## Done

(none yet)
