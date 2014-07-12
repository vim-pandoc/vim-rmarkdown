runtime syntax/pandoc.vim
PandocHighlight r
" rmarkdown recognizes embedded R differently than regular pandoc
exe 'syn region pandocRChunk '. 
            \'start=/\(```\s*{\s*r.*\n\)\@<=\_^/ ' .
            \'end=/\_$\n\(\(\s\{4,}\)\=\(`\{3,}`*\|\~\{3,}\~*\)\_$\n\_$\)\@=/ '. 
            \'contained containedin=pandocDelimitedCodeblock contains=@R'

syn region pandocInlineR matchgroup=Operator start=/`r\s/ end=/`/ contains=@R concealends
