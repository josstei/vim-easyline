let s:value             = ''
let s:update_timer      = -1
let s:debounce_timeout  = 200

function! easyline#item#gitdiff#get() abort
    return s:value    
endfunction

function! s:job_complete(_, data, ...) abort
    let l:data  = easyline#item#git#job#Validate(a:data)
    let l:file  = s:parse_stat_files(l:data)
    let l:plus  = s:parse_stat_lines(l:data, 'insertions', '+')
    let l:minus = s:parse_stat_lines(l:data, 'deletions', '-')
    let s:value = empty(l:data) ? '' : join(filter([l:file, l:plus, l:minus], 'v:val !=# ""'), ' ')
endfunction

function! s:job_refresh(...) abort
    let force = a:0 > 0 ? a:1 : 0
    call easyline#item#git#job#Run('diff --shortstat', function('s:job_complete'), 'diff', force)
endfunction

function! s:debounced_refresh() abort
    if s:update_timer != -1
        call timer_stop(s:update_timer)
    endif
    let s:update_timer = timer_start(s:debounce_timeout, { -> s:job_refresh() })
endfunction

function! s:parse_stat_lines(data, word, symbol) abort
    let pattern = '\v(\d+)\s+' . a:word
    let num     = matchstr(a:data, pattern)
    if num !=# ''
        let num = matchstr(num, '\d\+')
        return a:symbol . num
    endif
    return ''
endfunction

function! s:parse_stat_files(data) abort
    let full = matchstr(a:data, '\v(\d+)\s+file[s]?\s+changed')
    let stat = matchstr(full, '\d\+')
    return stat !=# '' ? '~' . stat : ''
endfunction

augroup easyline_gitdiff
    autocmd!
    autocmd VimEnter * call s:job_refresh(1)
    autocmd BufEnter,WinEnter * call s:debounced_refresh()
    autocmd BufWritePost,TextChanged,TextChangedI * call s:debounced_refresh()
    autocmd DirChanged * call easyline#item#git#cache#Clear('diff') | call s:job_refresh(1)
augroup END
