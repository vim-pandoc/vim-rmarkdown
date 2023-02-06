quarto-vim
=============

[Quarto](https://quarto.org) support for vim.

quarto-vim is a fork of the [vim-rmarkdown](https://github.com/vim-pandoc/vim-rmarkdown) plugin.

quarto-vim currently only handles syntax highlighthing for qmd
files, however we'd very much like to add more of the features
available in the excellent [vim-pandoc](https://githhub.com/vim-pandoc/viv-pandoc)
plugin. If you are interested in contributing please get in
touch by filing an issue or sending a pull request!

## Setup

quarto-vim requires the [vim-pandoc-syntax](https://github.com/vim-pandoc/vim-pandoc-syntax) vim plugin. 


quarto-vim's repo uses the typical bundle layout, so it's very simple to
install using some plugin manager such as [pathogen](https://github.com/tpope/vim-pathogen), [Vundle](https://github.com/VundleVim/Vundle.vim) or [NeoBundle](https://github.com/Shougo/neobundle.vim). For
example, using Vundle you should add

```viml
Plugin 'vim-pandoc/vim-pandoc-syntax'
Plugin 'quarto-dev/quarto-vim'
```

to your .vimrc, source it, and execute `:PluginInstall`.

Using [packer.nvim](https://github.com/wbthomason/packer.nvim), you should add

```lua
use({
   "quarto-dev/quarto-vim",
   requires = {
      {"vim-pandoc/vim-pandoc-syntax"},
   },
   ft = {"quarto"},
})
``` 
to your `.vimrc` (or `init.lua` in Neovim).

## Usage

Files with the .qmd extension are automatically detected as Quarto files and use highlithing rules from vim-pandoc-syntax (in addition to some special rules for Quarto executable code).

### Syntax

quarto-vim extends pandoc's markdown syntax so that:

    ```{python}
    import numpy as np
    np.arange(15).reshape(3, 5)
    ```

    ```{r}
    summary(cars)
    ```
are recognized as Python and R code cells.

Inline R is also handled for the knitr engine:

    inline unformatted text like `r 1 + 2` 

R and Python syntax is used within such fenced codeblocks and inline spans.
