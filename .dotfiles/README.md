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

## Extra Setup

### HomeBrew 

Use `brew bundle` to install everything in your
[Brewfile](https://github.com/Homebrew/homebrew-bundle)

```
cd ~/.dotfiles
brew bundle
```

### Ruby (rbenv & gem)

Use [`rbenv`](https://github.com/rbenv/rbenv) to install the latest ruby and
[`bundler`](https://bundler.io) to install your required gems.
`rbenv`, `ruby-build`, and `bundler` were installed by HomeBrew

```
rbenv init 		# initialize your rbenv
# rbenv setup should already be in your shell from .dotfiles
source .bashrc		# source your shell files
source .bash_profile
rbenv install 2.7.2	# install ruby 2.7.2 using ruby-build
rbenv global 2.7.2	# set 2.7.2 as your global python version
cd ~/.dotfiles
bundle install		# install all the Gems in Gemfile
```

### Python (pyenv & pip)

Use `pyenv` to install the latest python and `pip` to install your required
modules. `pyenv` was installed by HomeBrew

```
pyenv init		# initialize your pyenv
# pyenv setup should already be in your shell from .dotfiles
source .bashrc		# source your shell files
source .bash_profile
pyenv install 3.9.0	# install python 3.9.0
pyenv global 3.9.0	# set 3.9.0 as your global python version
pip -r .dotfiles requirements.txt

```

### NodeJS (yarn)

Use `yarn` to install your required NodeJS modules.  `yarn` and `node` were
installed by HomeBrew

```
yarn global add standard
```
