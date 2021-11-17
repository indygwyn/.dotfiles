# Keep dotfiles where they belong and avoid symlinks entirely

This arrangement of dotfiles is taken from [here](https://news.ycombinator.com/item?id=11070797)
and [here](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/) and [here](https://medium.com/toutsbrasil/how-to-manage-your-dotfiles-with-git-f7aeed8adf8b).
The idea is to keep all the dotfiles at their original locations, and avoid
symlinks entirely (as opposed to the general approach of putting all config
files in one directory and symlinking them with a script or GNU stow).
Basically, we create a bare git repo and set the work-tree to be our
$HOME directory. Then everytime we add a new config file to this repo, we do
so specifying this work-tree (we make this easy by defining an alias command).
This lets us keep the config files at their original locations, while also
allowing them to be under version control. Here's how to do it:

## First time setup

```
git init --bare $HOME/.dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
dotfiles remote add origin https://github.com/githubuser/.dotfiles.git
```

You'll need to change the remote URL to your git repo. You should also add the
dotfiles alias command to your .bashrc or .zshrc. Now, you can use the dotfiles
command to do git operation from anywhere in your $HOME directory:

## Operations

```
cd $HOME
dotfiles add .tmux.conf
dotfiles commit -m "Add .tmux.conf"
dotfiles push
```

## New machine setup

To set up a new machine, clone the repo to a temporary directory. This is
because you might have some default config files in your $HOME which will
cause a normal clone to fail.

```
git clone --bare https://github.com/USERNAME/dotfiles.git $HOME/.dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles checkout
```

## Tools Setup

### HomeBrew

Use `brew bundle --global` to install everything in your
~/.[Brewfile](https://github.com/Homebrew/homebrew-bundle)

### ASDF

Much of what used to be installed and managed by HomeBrew is now managed by
[ASDF](https://asdf-vm.com), which is a version manager similar to rbenv or
pyenv but with plugins to manage just about anything

- asdf plugin list
  - direnv
  - fzf
  - golang
  - java
  - nodejs
  - python
  - ruby
  - rust
  - shellcheck
  - shfmt
  - starship
  - terraform

The .default-* files control the Ruby Gems, Python Modules, Rust Crates,
NodeJS Packages, and Go Packages that are maintained/installed when you install
ad new version of those tools

### VIM setup

My VIM setup is not terribly complicated but depends on a lot of the linters
and LSP providers that are maintained via asdf or homebrew

I install MacVIM as most of my machines are macs, but it the setup should work
with plain jane vim as well (some day NeoVIM or OniVIM2)

The main plugins I depend on are ALE(linting) and deoplete(completion) and they
both use vim-lsp to use LSP providers.

I do depend on the Fira Code font to provide some powerline and git merge glyphs
in lightline and I do use ligatures in my setup.

### Terminal

I use Hyper, I like it.  You could easily adapt this to iTerm2. Hyper supports
my font ligatures.  My preferred colorthem is Dracula or Daycula

### -local

Many of my configs will load up a .blah-local file if it exists for settings
and such that are only required on that particular machine/environment.
