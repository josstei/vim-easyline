let s:value             = ''
let s:update_timer      = -1
let s:debounce_timeout  = 100

function! easyline#item#gitbranch#get() abort
    return s:value    
endfunction

function! s:job_complete(_, data, ...) abort
    let l:data  = easyline#item#git#job#Validate(a:data)
    let s:value = empty(l:data) ? '' : '  ' . l:data
endfunction

function! s:job_refresh(...) abort
    let force = a:0 > 0 ? a:1 : 0
    call easyline#item#git#job#Run('rev-parse --abbrev-ref HEAD', function('s:job_complete'), 'branch', force)
endfunction

function! s:debounced_refresh() abort
    if s:update_timer != -1
        call timer_stop(s:update_timer)
    endif
    let s:update_timer = timer_start(s:debounce_timeout, { -> s:job_refresh() })
endfunction

augroup easyline_gitbranch
    autocmd!
    autocmd VimEnter * call s:job_refresh(1)
    autocmd BufEnter,WinEnter * call s:debounced_refresh()
    autocmd BufWritePost * call s:job_refresh(1)
    autocmd DirChanged * call easyline#item#git#repo#ClearCache() | call s:job_refresh(1)
augroup END
