" load vim-pandoc
runtime ftplugin/pandoc.vim

" Rmarkdown:
command! -buffer -nargs=* -complete=custom,rmarkdown#command#CommandComplete RMarkdown call rmarkdown#command#Command('<args>')
