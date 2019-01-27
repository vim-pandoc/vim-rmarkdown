vim-rmarkdown
=============

[RMarkdown](http://rmarkdown.rstudio.com/) support for vim.

## Setup

vim-rmarkdown requires 

* the [vim-pandoc](https://github.com/vim-pandoc/vim-pandoc) and
[vim-pandoc-syntax](https://github.com/vim-pandoc/vim-pandoc-syntax) vim plugins. 

* the [rmarkdown standalone package](https://github.com/rstudio/rmarkdown)

vim-rmarkdown's repo uses the typical bundle layout, so it's very simple to
install using some plugin manager such as [pathogen](https://github.com/tpope/vim-pathogen), [Vundle](https://github.com/VundleVim/Vundle.vim) or [NeoBundle](https://github.com/Shougo/neobundle.vim). For
example, using Vundle you should add

    Plugin 'vim-pandoc/vim-rmarkdown'

to your .vimrc, source it, and execute `:PluginInstall`.

## Screenshot

![screenshot](http://i.imgur.com/mwr6O5t.png)

## Usage

Files with the .Rmd extension are automatically detected as RMarkdown files.
vim-rmarkdown loads vim-pandoc and pandoc's markdown syntax, and adds some
extra functionality specific to rmarkdown.

### Syntax

vim-rmarkdown extends pandoc's markdown syntax so

    ```{r qplot, fig.width=4, message=FALSE}
    library(ggplot2)
    summary(cars)
    qplot(speed, dist, data=cars) + 
        geom_smooth()
    ```

is recognized as an R code chunk, and

    inline unformatted text like `r 1 + 2` 

as inline R.

R syntax is used within such fenced codeblocks and inline spans.

### Command

To render the file using rmarkdown, the user can execute the `|:RMarkdown|`
command. Its syntax is

`:RMarkdown[!] [OUTPUT_TYPE] [- RENDER_ARGS[ -]] [OUTPUT_TYPE_ARGS]`

OUTPUT_TYPE is one of "pdf", "word", "html", "md", "beamer", "ioslides",
"revealjs", "all", or a combination thereof (e.g., "pdf+html"). Command
completion is provided for defining this variable.

RENDER_ARGS are arguments passed to rmarkdown::render(...), and
OUTPUT_TYPE_ARGS are passed to output objects such as rmarkdown::pdf_document(...) 
and rmarkdown::word_document(...). (Refer to RMarkdown's documentation).
Note RENDER_ARGS MUST be surrounded by '- ' and ' -'.

The bang (!) version opens the created file on successful execution. If the
execution fails, a message will be shown and a buffer will open with Rscript's
output (can be dismissed by pressing q in normal mode).

:RMarkdown builds a R expression that executes rmarkdown. For example, if the
current file is "input.Rmd",

    :RMarkdown pdf

executes 

    Rscript -e 'library(rmarkdown);render("input.Rmd", "pdf_document")'

If OUTPUT_TYPE is ommited, RMarkdown produces an html document.

Some more examples:

    :RMarkdown pdf latex_engine="xelatex", toc=TRUE
    ->
    Rscript -e 'library(rmarkdown);render("input.Rmd", pdf_document(latex_engine="xelatex", toc=TRUE) 

    :RMarkdown html - quiet=FALSE - toc=FALSE
    ->
    Rscript -e 'library(rmarkdown);render("input.Rmd", html_document(toc=TRUE), quiet=FALSE)

    :RMarkdown word - quiet=FALSE
    ->
    Rscript -e 'library(rmarkdown);render("input.Rmd", "word_document", quiet=FALSE)

Note `|:RMarkdown|` doesn't parse the arguments itself, so the user must type them
exactly as they should be used in R (for example, commas should separate
arguments). For example,

    :RMarkdown latex_engine="lualatex" bibliography="input.bib"

will cause rmarkdown to fail.

## NrrwRgn

If the NrrwRgn plugin is available, vim-rmarkdown will register an extra
command, |:RNrrw|, which "narrows" the current R chunk in a separate buffer.
This command is also mapped to "<LocalLeader>ccn" in normal mode.

`" vim: set ft=help :`
