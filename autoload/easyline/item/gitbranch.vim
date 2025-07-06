let s:value = ''

function! easyline#item#gitbranch#get() abort
    return s:value    
endfunction

function! s:job_complete(_, data, ...) abort
    let l:data  = easyline#item#git#job#Validate(a:data)
    let s:value = empty(l:data) ? '' : '  ' . l:data
endfunction

function! s:job_refresh() abort
    call easyline#item#git#job#Run('rev-parse --abbrev-ref HEAD',function('s:job_complete'))
endfunction

augroup easyline_gitbranch
    autocmd!
    autocmd VimEnter,BufEnter,WinEnter * call s:job_refresh()
    autocmd BufWritePost,BufReadPost * call s:job_refresh()
augroup END
