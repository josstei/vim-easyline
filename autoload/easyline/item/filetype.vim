function! easyline#item#filetype#get() abort
    return &filetype !=# '' ? &filetype : '[no ft]'
endfunction
