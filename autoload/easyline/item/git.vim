function! easyline#item#git#get() abort
    let l:branch    = easyline#item#gitbranch#get()
    let l:diff      = easyline#item#gitdiff#get()
    return join([l:branch,l:diff],' ' )
endfunction

