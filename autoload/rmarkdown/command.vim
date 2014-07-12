function! rmarkdown#command#Command(args)
    if g:rmarkdown#pipeline == "rmarkdown"
        call system('R -e "rmarkdown::render(\"'. expand("%:p") . '\")"')
    endif
endfunction
