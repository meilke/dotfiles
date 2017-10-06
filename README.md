# dotfiles

My dotfiles...

**Make sure to save any files beforehand!**

## Vim

    $ ln -s .vimrc ~/.vimrc
    $ ln -s .vim ~/.vim

## Git

Make sure to add this to your `<home>/.gitconfig` file:

    ...
    [core]
        excludesfile = <home>/.gitignore
    ...

Then link your global `.gitignore`:

    $ ln -s dotgitignore ~/.gitignore

## pylint

    $ ln -s .pylintrc ~/.pylintrc
