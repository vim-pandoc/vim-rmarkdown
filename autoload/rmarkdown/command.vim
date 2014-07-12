function! rmarkdown#command#Command(args)
    if g:rmarkdown#pipeline == "rmarkdown"
        call system('Rscript -e "rmarkdown::render(\"'. expand("%:p") . '\")"')
    endif
endfunction
