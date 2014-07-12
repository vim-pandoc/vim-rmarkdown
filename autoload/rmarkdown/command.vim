function! rmarkdown#command#Command(args)
    call system('Rscript -e "rmarkdown::render(\"'. expand("%:p") . '\")"')
endfunction
