function! easyline#item#percent#get()
    return line2byte(line('.')) * 100 / line2byte(line('$')) . '%'
endfunction
