let s:value = ''

function! easyline#item#gitdiff#get() abort
    return s:value    
endfunction

function! s:job_complete(_, data, ...) abort
    let l:data  = easyline#item#git#job#Validate(a:data)
    let l:file  = s:parse_stat_files(l:data)
    let l:plus  = s:parse_stat_lines(l:data,'insertions','+')
    let l:minus = s:parse_stat_lines(l:data,'deletions','-')
    let s:value = join(filter([l:file, l:plus, l:minus], 'v:val !=# ""'), ' ')
endfunction

function! s:job_refresh() abort
    call easyline#item#git#job#Run('diff --shortstat',function('s:job_complete'))
endfunction

function! s:parse_stat_lines(data, word, symbol) abort
    let pattern = '\v(\d+)\s+' . a:word
    let num = matchstr(a:data, pattern)
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
    autocmd VimEnter,BufEnter,WinEnter * call s:job_refresh()
    autocmd BufWritePost,BufReadPost * call s:job_refresh()
augroup END
