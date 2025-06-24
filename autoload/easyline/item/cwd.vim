function! easyline#item#cwd#get()
    return fnamemodify(getcwd(), ':t')
endfunction
