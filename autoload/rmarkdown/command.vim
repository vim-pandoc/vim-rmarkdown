let s:exexec = expand("<sfile>:h") . "/exexec.R"

function! s:MapOT(ot)
    let ot = tolower(a:ot)
    if ot == "" || ot == "pdf" || ot == "html" || ot == "word" || ot == "md"
        if ot == ""
            let output_type = "html_document"
        else
            let output_type = ot . "_document"
        endif
    elseif ot == "beamer" || ot == "revealjs" || ot == "ioslides" || ot == "slidy"
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
    elseif ot == "revealjs" || ot == "ioslides" || ot == "slidy"
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

    " we support passing arguments to rmarkdown::render and output objects,
    " but only for single formats (i.e., "pdf", but not "pdf+html")
    if type(output_type) == type("")
        let opts_data = matchlist(a:args, '\(-\s\)\@<=\(.*\)\(\s-\)\@=\(\(.*-\s\)\(.*$\)\)*')
        if opts_data != []
            let render_opts = ', '. substitute(opts_data[2], '\"', '\\\"', 'g')
            let object_opts = opts_data[6]
            if object_opts != ''
                let output_type_arg = substitute(output_type . "(".object_opts.")", '\"', '\\\"', 'g')
            endif
        else
            let render_opts_data = matchstr(a:args, '\(-\s\)\@<=.*')
            if render_opts_data != ''
                let render_opts  = ', ' .render_opts_data
            else
                let render_opts = ''
                let object_opts = join(args_data[1:], ' ')
                if object_opts != ''
                    let output_type_arg = substitute(output_type . "(" . object_opts . ")" , '\"', '\\\"', 'g')
                endif
            endif
        endif
    else
        let render_opts = ''
    endif

    if output_type == "revealjs_presentation"
        let invocation = 'Rscript -e "library(rmarkdown);library(revealjs);render(\"'. 
                    \ expand("%:p") . '\", '. 
                    \ 'revealjs_presentation()' .
                    \ render_opts.')"'
    else
        let invocation = 'Rscript -e "library(rmarkdown);render(\"'. 
                    \ expand("%:p") . '\", '. 
                    \ output_type_arg .
                    \ render_opts.')"'
    endif
    let s:output_file = expand("%:p:r"). '.' .s:MapExt(args_data[0])
    if has('clientserver') && 
                \v:servername != '' &&
                \executable(s:exexec)
        if a:bang == "!"
            let open_arg = "--open"
        else
            let open_arg = "--noopen"
        endif
        silent exe "!".s:exexec." --servername ".v:servername . " ". open_arg. " " .invocation . "&"
        "Replace the line above with this to debug
        "exe "!".s:exexec." --servername ".v:servername . " ". open_arg. " " .invocation 
    else
        let r_output = systemlist(invocation)
        if v:shell_error
            botright 10new
            call append(line('$'), r_output)
            norm dd
            call s:RmarkdownFailure()
        else
            call s:RmarkdownSuccess(a:bang == "!")
        endif
    endif
endfunction

function! rmarkdown#command#Callback(open)
    if filereadable("rmarkdown.out")
        botright 10split rmarkdown.out
        silent exe "!rm rmarkdown.out"
        call s:RmarkdownFailure()
    else 
        call s:RmarkdownSuccess(a:open)
    endif
endfunction

function! s:RmarkdownSuccess(open)
    echom "vim:rmarkdown: ran succesfully"
    call rmarkdown#command#OpenFile(a:open)
endfunction

function! s:RmarkdownFailure()
        echohl errormsg
        echom "vim-rmarkdown: rmarkdown failed"
        echohl none
        setlocal buftype=nofile
        setlocal bufhidden=wipe
        setlocal nomodifiable
        noremap <buffer> q :close<CR>
        redraw!
endfunction

function! rmarkdown#command#OpenFile(open)
    if a:open == 1
        call system('xdg-open '. s:output_file)
    endif
endfunction

function! rmarkdown#command#CommandComplete(a, c, p)
    if len(split(a:c, " ", 1)) < 3
        return join(["pdf", "html", "word", "md", "beamer", "revealjs", "ioslides", "slidy"], "\n")
    else
        return ""
    endif
endfunction
