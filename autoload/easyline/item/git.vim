let s:git_stats  = ''
let s:git_branch = ''

function! easyline#item#git#get() abort
    return s:git_stats
endfunction

function! s:is_empty(data) abort
    if empty(a:data)
        let s:git_stats = ''
        return 1 
    endif
endfunction

function! s:refresh() abort
    let root = finddir('.git', expand('%:p:h').' ;')
    if s:is_empty(root) | return | endif

    let cwd = fnamemodify(root, ':h')
    call s:run_job(['git', '-C', cwd, 'rev-parse', '--abbrev-ref', 'HEAD'], function('s:on_branch'))
    call s:run_job(['git', '-C', cwd, 'diff', '--shortstat'], function('s:on_diff'))
endfunction

function! s:on_branch(_, data, ...) abort
    if !empty(a:data) && a:data[0] !=# ''
        let s:git_branch = a:data[0]
    endif
endfunction

function! s:on_diff(_, data, ...) abort
    if s:is_empty(a:data) | return | endif

    let stats = a:data[0]
    let plus  = matchstr(stats, '\v(\d+)\s+insertion') !=# '' ? '+' . matchstr(stats, '\v(\d+)\s+', 1, 1) : ''
    let minus = matchstr(stats, '\v(\d+)\s+deletion') !=# '' ? '-' . matchstr(stats, '\v(\d+)\s+', 1, 1) : ''
    let s:git_stats = '  ' . s:git_branch . ' ' . plus . ' ' . minus
endfunction

function! s:run_job(cmd, cb) abort
    if exists('*job_start')
        let opts = {
              \ (has('nvim') ? 'on_stdout' : 'out_cb'): a:cb,
              \ (has('nvim') ? 'on_stderr' : 'err_cb'): function('s:on_err'),
              \ (has('nvim') ? 'stdout_buffered' : 'out_mode'): has('nvim') ? v:true : 'nl'
              \ }
        call job_start(a:cmd, opts)
    else
        call a:cb(0, split(system(join(a:cmd, ' ')), "\n"), '')
    endif
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
