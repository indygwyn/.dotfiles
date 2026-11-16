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

2026-11-16 (work to home), host tholt-ltm2py4.internal.salesforce.com (macOS):

1. Pull: `Already up to date.`
2. `*` appended to `~/.dotfiles/info/exclude`. The file lacked it before.
3. `~/.local/bin/dotfiles` exists and executable. A bash shell resolves `dotfiles` to that path, not an alias.
4. `dotfiles add -A -n` lists nothing.
5. `gh auth token --hostname github.com` succeeds.
6. `mise doctor` shows `github.credential_command` loaded from `~/.config/mise/config.toml`. `mise ls` shows no rate-limit or auth errors. One unrelated warning: mise tool paths do not come first in PATH, because `~/.mh-telemetry-collector-aisuite/telemetry/opencode-shim` and `~/.codeium/windsurf/bin` take precedence. The environment also exports `MISE_GITHUB_TOKEN` (value redacted in doctor output). Home may want to check whether that variable overrides the new `credential_command`.
7. Steps 8 and 9 not done. This machine has `bash-completion` 1.3_3 installed, and `/opt/homebrew/etc/profile.d/bash_completion.sh` exists as a symlink into that v1 Cellar. `brew info bash-completion@2` reports `Conflicts with: bash-completion`, so `brew install bash-completion@2` would require uninstalling v1. I left it alone and did not test Tab completion. Home needs to decide whether to uninstall v1 here. Until then the `_dotfiles_complete` block sources the v1 script and probably works only partly, since v1 targets older bash.

Update, same day: Thomas approved the migration. Ran `brew uninstall bash-completion` (no dependents per `brew uses`) and `brew install bash-completion@2` (2.18.0). `/opt/homebrew/etc/profile.d/bash_completion.sh` now links into the `@2` Cellar. `.bashrc` line 520 already sources it. In an interactive bash, `complete -p dotfiles` shows `_dotfiles_complete` registered, and calling it for `dotfiles checkout ma` returns `main` (listed twice in COMPREPLY, which readline collapses). I could not press Tab in a real terminal, so Thomas should confirm that once in a new shell. Steps 8 and 9 closed.

Nothing committed or pushed. The handoff edit sits uncommitted in the dotfiles work tree.

## Done

(none yet)
