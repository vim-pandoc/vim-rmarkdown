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
    elseif ot =~ '+'
        let formats = split(ot, '+')
        let output_type = map(formats, 's:MapOT(v:val)')
    else
        throw "rmarkdown:E1"
    endif
    return output_type
endfunction

function! s:MapExt(ot)
    let ot = tolower(a:ot)
    if ot == "" || ot == "html" || ot == "md" || ot == "pdf"
        let ext = ot
    elseif ot == "word"
        let ext = "docx"
    elseif ot == "beamer"
        let ext = "pdf"
    elseif ot == "revealjs" || ot == "ioslides"
        let ext = "html"
    elseif ot == "all"
        let ext = "html"
    elseif ot =~ '+'
        let ext = map(split(ot, '+'), 's:MapOT(v:val)')[0]
    else
        throw "rmarkdown:E1"
    endif
    return ext
endfunction

function! rmarkdown#command#Command(bang, args)
    let args_data = split(a:args, " ", 1)
    try
        let output_type = s:MapOT(args_data[0])
        if type(output_type) == type("")
            let output_type_arg = '\"' . output_type . '\"'
        elseif type(output_type) == type([])
            let output_types = map(output_type, '"\\\"".v:val."\\\""')
            let output_type_arg = 'c(' . join(output_types, ",").')'
        endif
    catch /rmarkdown:E1/
        echohl errormsg
        echom "vim-rmarkdown: output type not recognized"
        echohl none
        return
    endtry
    let invocation = 'Rscript -e "rmarkdown::render(\"'.expand("%:p") . '\", '. output_type_arg.')"'
    let r_output = system(invocation)
    if v:shell_error
        echohl errormsg
        echom "vim-rmarkdown: rmarkdown failed"
        echohl none
    else
        echom "vim:markdown: succesfully ran '". substitute(invocation, '\', '', 'g') . "'"
        if a:bang == "!"
            call system('xdg-open '. expand("%:p:r").'.'.s:MapExt(args_data[0]))
        endif
    endif
endfunction

function! rmarkdown#command#CommandComplete(a, c, p)
    if len(split(a:c, " ", 1)) < 3
        return join(["pdf", "html", "word", "md", "beamer", "revealjs", "ioslides"], "\n")
    else
        return ""
    endif
endfunction
