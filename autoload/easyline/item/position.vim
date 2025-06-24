function! easyline#item#position#get()
    return line('.') . ':' . col('.')
endfunction
