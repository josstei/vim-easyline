let s:git_stats = ''
let s:git_branch = ''

function! easyline#item#git#get() abort
	return s:git_stats
endfunction

function! s:refresh() abort
	let root = finddir('.git', expand('%:p:h').' ;')
	if empty(root) | let s:git_stats = '' | return | endif
	let cwd = fnamemodify(root, ':h')
    call s:execute_job(['git', '-C', cwd, 'rev-parse', '--abbrev-ref', 'HEAD'], function('s:getBranch'))
    call s:execute_job(['git', '-C', cwd, 'diff', '--shortstat'], function('s:on_diff'))
endfunction

function! s:getBranch(...) abort
    let data = s:get_job_data(a:000)
    if !empty(data) && data[0] !=# ''
        let s:git_branch = data
    endif
endfunction

function! s:on_diff(...) abort
  let data = s:get_job_data(a:000)
  if empty(data)
    return
  endif
  let stats = data
  let ins = matchstr(stats, '\d\+\s\+insertion')
  let del = matchstr(stats, '\d\+\s\+deletion')
  let plus = ins !=# '' ? '+'.matchstr(ins, '\d\+') : ''
  let minus = del !=# '' ? '-'.matchstr(del, '\d\+') : ''
  let s:git_stats = '  '.s:git_branch.' '.plus.' '.minus
endfunction

function! s:execute_job(cmd, cb) abort
    if !exists('*job_start')
        call a:cb(0, split(system(join(a:cmd, ' ')), "\n"), '')
        return
    endif

    let out_key         = has('nvim') ? 'on_stdout'         : 'out_cb'
    let err_key         = has('nvim') ? 'on_stderr'         : 'err_cb'
    let buff_key        = has('nvim') ? 'stdout_buffered'   : 'out_mode'
    let buff_val        = has('nvim') ? v:true              : 'nl'
    let opts            = {}

    call extend(opts, { out_key: a:cb})
    call extend(opts, { err_key: function('s:on_err') })

    let opts[buff_key]  = buff_val
    call job_start(a:cmd, opts)
endfunction

function! s:on_err(job, data, event) abort
  if !empty(a:data)
    echom 'Error: '.string(a:data)
  endif
endfunction

function! s:get_job_data(args) abort
    try
        if len(a:args) == 3
            return a:args[1][0]
        elseif len(a:args) == 2
            return a:args[1]
        else
            return []
        endif
    catch
    endtry
endfunction

augroup easyline_git 
	autocmd!
	autocmd VimEnter,BufWritePost,BufReadPost * call s:refresh()
augroup END
