let s:branch = ''
let s:diff   = ''

function! easyline#item#git#get() abort
    return s:get_stats()    
endfunction

function! s:clear_data(data) abort
    let s:branch = ''
    let s:diff   = ''
endfunction

function! s:refresh() abort
    let cwd         = easyline#item#git#repo#Get()
    let branch_job  = easyline#item#git#job#Build(cwd,'rev-parse --abbrev-ref HEAD')
    let diff_job    = easyline#item#git#job#Build(cwd,'diff --shortstat')

    call easyline#item#git#job#Run(branch_job,function('s:on_branch'))
    call easyline#item#git#job#Run(diff_job,function('s:on_diff'))
endfunction

function! s:on_branch(_, data, ...) abort
    let l:data      = s:validate_data(a:data)    
    let s:branch    = '  ' . a:data[0]
endfunction

function! s:get_stats() abort
    return s:branch . ' ' . s:diff
endfunction

function! s:validate_data(data) abort
    return !empty(a:data) && a:data[0] !=# '' ? a:data[0] : ''
endfunction

function! s:on_diff(_, data, ...) abort
    let l:data  = s:validate_data(a:data)    
    let l:plus  = s:parse_stat(l:data,'insertions','+')
    let l:minus = s:parse_stat(l:data,'deletions','-')
    let s:diff  =  plus . ' ' . minus
endfunction

function! s:parse_stat(data,str,symbol) abort
    let stat = matchstr(a:data, '\v(\d+)\s+'.a:str)
    return stat !=# '' ? a:symbol . matchstr(a:data, '\v(\d+)\s+'.a:str,1,1) : ''
endfunction

function! s:on_err(job, data, event) abort
    if !empty(a:data)
        echom 'Easyline git error: ' . string(a:data)
    endif
endfunction

augroup easyline_git
    autocmd!
    autocmd VimEnter,BufWritePost,BufReadPost * call s:refresh()
augroup END
