function! easyline#item#git#repo#Get() abort
    let root = finddir('.git', expand('%:p:h').' ;')
    return !empty(root) ? fnamemodify(root, ':h') : ''
endfunction

function! s:get_repo() abort
    let root = finddir('.git', expand('%:p:h').' ;')
    return !empty(root) ? fnamemodify(root, ':h') : ''
endfunction
