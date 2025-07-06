function! easyline#item#git#job#Build(cmd) abort
    let cwd = easyline#item#git#repo#Get()
    return !empty(cwd) ? join(['git -C', cwd, a:cmd],' ') : ''
endfunction

function! easyline#item#git#job#Validate(data) abort
    return !empty(a:data) && a:data[0] !=# '' ? a:data[0] : []
endfunction

function! easyline#item#git#job#Run(cmd,cb) abort
    let job = easyline#item#git#job#Build(a:cmd)
    if empty(job) | call a:cb(1, [''], '') | return | endif

    if exists('*job_start')
        let opts = {
              \ (has('nvim') ? 'on_stdout' : 'out_cb') : a:cb,
              \ (has('nvim') ? 'on_stderr' : 'err_cb') : function('s:on_err'),
              \ (has('nvim') ? 'stdout_buffered' : 'out_mode'): has('nvim') ? v:true : 'nl'
              \ }
        call job_start(job, opts)
    else
        call a:cb(0, split(system(job), "\n"), '')
    endif
endfunction

function! s:on_err(job, data, event) abort
    if !empty(a:data)
        echom '[EASYLINE][GIT][JOB][ERROR]: ' . v:exception
    endif
endfunction
