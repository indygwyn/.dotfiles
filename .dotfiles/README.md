## Keep dotfiles where they belong and avoid symlinks entirely

This arrangement of dotfiles is taken from
[here](https://news.ycombinator.com/item?id=11070797) and
[here](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/)
and [here](https://medium.com/toutsbrasil/how-to-manage-your-dotfiles-with-git-f7aeed8adf8b).

This approach keeps all the dotfiles at their original locations, and avoids
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

### mise-en-place

Much of what used to be installed and managed by HomeBrew is now managed by
[mise-en-place](https://mise.jdx.dev), a version manager similar to rbenv or
pyenv but with plugins to manage just about anything

The .default-* files control the Ruby Gems, Python Modules, Rust Crates,
NodeJS Packages, and Go Packages that are maintained/installed when you install
a new version of those tools

### VIM setup

My VIM setup remains fairly simple but depends on many linters
and LSP providers maintained via mise or homebrew

I install MacVIM as most of my machines run macOS, but the setup should work
with plain jane vim as well (some day NeoVIM or OniVIM2)

The main plugins I depend on are ALE(linting) and deoplete(completion) and they
both use vim-lsp to use LSP providers.

I do depend on the [FiraCode](https://github.com/tonsky/FiraCode) font to
provide some powerline and git merge glyphs in lightline and I do use ligatures
in my setup.

### Terminal

I use [Hyper](https://hyper.is), I like it. You could easily adapt this to
iTerm2. Hyper supports my font ligatures. My preferred color theme remains
[Dracula](https://draculatheme.com) or
[Daycula](https://github.com/ghifarit53/daycula-vim)

### -local

Many of my configs will load up a .blah-local file if it exists for settings
and such that are only required on that particular machine/environment.

## SCRATCH

### Mermaid test

```mermaid
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
```

