" load vim-pandoc
runtime ftplugin/pandoc.vim

" Rmarkdown:
" defaults: 
if !exists("g:rmarkdown#pipeline")
    let g:rmarkdown#pipeline = "rmarkdown"
endif

command! -buffer -nargs=* RMarkdown call rmarkdown#command#Command('<args>')
