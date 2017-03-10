" Make: async make.

" 有 makefile 的情况下需提前编译 <leader>c
" 约定 makefile 编译后的入口为 main (待完善)
func! CompileRunGcc()
    let makefile = expand("%:p:h") . "/makefile"
    if filereadable(makefile)
        exec "! ./main"
    else
        exec "silent w"
        exec "silent !gcc % -o %<"
        exec "! ./%<"
        exec "silent ! rm ./%<"
    endif
endfunc

nnoremap <leader>r :call CompileRunGcc()<CR>
