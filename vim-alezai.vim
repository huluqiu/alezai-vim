" vim-alezai

" Init {
    if !exists('g:alezai_rescur')
        let g:alezai_rescur = 1
    endif

    if !exists('g:alezai_undodir')
        let g:alezai_undodir = $HOME . '/.vim/.vimundo/'
    endif
    if !isdirectory(g:alezai_undodir)
        call mkdir(g:alezai_undodir)
    endif
    exec "set " . "undodir" . "=" . g:alezai_undodir
" }

" ResCur{
    function! ResCur()
        if line("'\"") <= line("$")
            silent! normal! g`"
            return 1
        endif
    endfunction

    if g:alezai_rescur == 1
        autocmd BufWinEnter * call  ResCur()
    endif
" }

" List {
    function! LocationNextCycle()
        try
            lnext
        catch /E553/
            lfirst
        catch /E42/
            echo "E42: No Errors"
        endtry
    endfunction

    function! LocationPreviousCycle()
        try
            lprevious
        catch /E553/
            llast
        catch /E42/
            echo "E42: No Errors"
        endtry
    endfunction

    function! s:GetBufferList()
        redir =>buflist
        silent! ls
        redir END
        return buflist
    endfunction

    function! ToggleLocationList()
        let curbufnr = winbufnr(0)
        for bufnum in map(filter(split(s:GetBufferList(), '\n'), 'v:val =~ "Location List"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
            if curbufnr == bufnum
                lclose
                return
            endif
        endfor

        let winnr = winnr()
        let prevwinnr = winnr("#")

        let nextbufnr = winbufnr(winnr + 1)
        try
            lopen
        catch /E776/
            echohl ErrorMsg
            echo "Location List is Empty."
            echohl None
            return
        endtry
        if winbufnr(0) == nextbufnr
            lclose
            if prevwinnr > winnr
                let prevwinnr-=1
            endif
        else
            if prevwinnr > winnr
                let prevwinnr+=1
            endif
        endif
        " restore previous window
        exec prevwinnr."wincmd w"
        exec winnr."wincmd w"
    endfunction

    function! ToggleQuickfixList()
        for bufnum in map(filter(split(s:GetBufferList(), '\n'), 'v:val =~ "Quickfix List"'), 'str2nr(matchstr(v:val, "\\d\\+"))') 
            if bufwinnr(bufnum) != -1
                cclose
                return
            endif
        endfor
        let winnr = winnr()
        copen
        if winnr() != winnr
            wincmd p
        endif
    endfunction
" }
