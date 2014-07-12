function! s:MapOT(ot)
    let ot = tolower(a:ot)
    if ot == "" || ot == "pdf" || ot == "html" || ot == "word" || ot == "md"
        if ot == ""
            let output_type = "html_document"
        else
            let output_type = ot . "_document"
        endif
    elseif ot == "beamer" || ot == "revealjs" || ot == "ioslides"
        let output_type = ot . "_presentation"
    elseif ot == "all"
        let output_type = ot
    else
        throw "rmarkdown:E1"
    endif
    return output_type
endfunction

function! rmarkdown#command#Command(args)
    let args_data = split(a:args, " ", 1)
    try
        let output_type = s:MapOT(args_data[0])
    catch /rmarkdown:E1/
        echohl ErrorMsg
        echom "vim-rmarkdown: output type not recognized"
        echohl None
        return
    endtry
    let invocation = 'Rscript -e "rmarkdown::render(\"'.expand("%:p") . '\", \"'. output_type.'\")"'
    call system(invocation)
endfunction
