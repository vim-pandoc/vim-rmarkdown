function! rmarkdown#nrrwrgn#NarrowRChunk()
    if rmarkdown#nrrwrgn#InsideRChunk() == 1
	if exists("b:nrrw_aucmd_create")
	    let old_hook = b:nrrw_aucmd_create
	endif
	let b:nrrw_aucmd_create = 'set ft=r'
	let range = rmarkdown#nrrwrgn#ChunkRange()
	exe range[0].','.range[1].'NR'
	if exists("old_hook") 
	    let b:nrrw_aucmd_create = old_hook
	endif
    endif
endfunction

function! rmarkdown#nrrwrgn#InsideRChunk(...)
    let origin_pos = getpos(".")
    if a:0 > 0
	let source_pos = a:1
    else
	let source_pos = line(".")
    endif
    call cursor(source_pos, 1)
    if synIDattr(synID(source_pos, 1, 0), "name") =~? "pandocdelimitedcodeblock"
	return 1
    endif
    let prev_delim = searchpair('^[~`]\{3}{r', '', '^[~`]\{3}', 'bnW')
    let next_delim = search('^[~`]\{3}', 'nW')
    call cursor(origin_pos[1], origin_pos[2])
    if prev_delim > 0
	if source_pos > prev_delim && source_pos < next_delim
	    return 1
	endif
    endif
endfunction

function! rmarkdown#nrrwrgn#ChunkRange(...)
    let l:range = []
    let origin_pos = getpos(".")
    if a:0 > 0
	let source_pos = a:1
    else
	let source_pos = line(".")
    endif
    echom source_pos
    call cursor(source_pos, 1)
    if rmarkdown#nrrwrgn#InsideRChunk(source_pos) == 1
	let start_delim = searchpair('^[~`]\{3}{r', '', '^[~`]\{3}', 'cnbW')
	let end_delim = search('^[~`]\{3}', 'cnW')
	if start_delim != line(".") 
	    let l:range = [start_delim+1, end_delim-1]
	else
	    " we are at the starting delimiter
	    if rmarkdown#nrrwrgn#InsideRChunk(source_pos-1) == 0

		let l:range = [start_delim + 1, search('^[~`]\{3}', 'nW') -1]
	    " we are at the ending delimiter
	    else
	        let l:range = [search('^[~`]\{3}{r', 'bnW') + 1, end_delim - 1]
	    endif
	endif
    endif
    call cursor(origin_pos[1], origin_pos[2])
    return l:range
endfunction
