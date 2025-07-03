function! easyline#item#git#job#Build(cwd,cmd) abort
    return join(['git -C', a:cwd, a:cmd],' ')
endfunction

function! easyline#item#git#job#Value(_, data, ...) abort
    return !empty(a:data) && a:data[0] !=# '' ? a:data : []
endfunction

function! easyline#item#git#job#Run(cmd,cb) abort
    if exists('*job_start')
        let opts = {
              \ (has('nvim') ? 'on_stdout' : 'out_cb') : a:cb,
              \ (has('nvim') ? 'on_stderr' : 'err_cb') : function('s:on_err'),
              \ (has('nvim') ? 'stdout_buffered' : 'out_mode'): has('nvim') ? v:true : 'nl'
              \ }
        call job_start(a:cmd, opts)
    else
        call a:cb(0, split(system(a:cmd), "\n"), '')
    endif
endfunction

function! s:on_err(job, data, event) abort
    if !empty(a:data)
        echom '[EASYLINE][GIT][JOB][ERROR]: ' . v:exception
    endif
endfunction
