" vim: set fdm=marker:

" Pandoc: {{{1
" load vim-pandoc {{{2
runtime ftplugin/pandoc.vim

" init vim-pandoc-after, if present {{{2
try
    call pandoc#after#Init()
catch /E117/
endtry

" Rmarkdown: {{{1
command! -buffer -bang -nargs=* 
            \-complete=custom,rmarkdown#command#CommandComplete 
            \RMarkdown call rmarkdown#command#Command('<bang>', '<args>')

if exists(":NR") == 2
    command! -buffer RNrrw call rmarkdown#nrrwrgn#NarrowRChunk()
    noremap <buffer> <localleader>ccn :RNrrw<cr>
endif
