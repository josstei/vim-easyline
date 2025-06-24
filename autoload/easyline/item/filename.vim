function! easyline#item#filename#get() abort
    return expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
endfunction
