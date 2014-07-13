" vim: set fdm=marker:

" Pandoc: {{{1
" load vim-pandoc {{{2
runtime ftplugin/pandoc.vim

" Rmarkdown: {{{1
command! -buffer -bang -nargs=* 
            \-complete=custom,rmarkdown#command#CommandComplete 
            \RMarkdown call rmarkdown#command#Command('<bang>', '<args>')
