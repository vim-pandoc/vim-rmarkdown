" load vim-pandoc
runtime ftplugin/pandoc.vim

" Rmarkdown:
command! -buffer -nargs=* RMarkdown call rmarkdown#command#Command('<args>')
