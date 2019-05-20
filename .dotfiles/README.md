# Keep dotfiles where they belong and avoid symlinks entirely

This arrangement of dotfiles is taken from [here](https://news.ycombinator.com/item?id=11070797)
and [here](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/).
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
git clone --separate-git-dir=$HOME/.dotfiles https://github.com/githubuser/dotfiles.git tmpdotfiles
rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
rm -r tmpdotfiles
```
