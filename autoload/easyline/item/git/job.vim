let s:running_jobs = {}

function! easyline#item#git#job#Build(cmd) abort
    let cwd = easyline#item#git#repo#Get()
    return !empty(cwd) ? join(['git -C', shellescape(cwd), a:cmd], ' ') : ''
endfunction

function! easyline#item#git#job#Validate(data) abort
    if type(a:data) == type([]) && len(a:data) > 0
        return a:data[0] !=# '' ? a:data[0] : ''
    endif
    return ''
endfunction

function! easyline#item#git#job#Run(cmd, cb, ...) abort
    let cache_key   = a:0 > 0 ? a:1 : a:cmd
    let force       = a:0 > 1 ? a:2 : 0
    
    if !force
        let cached = easyline#item#git#cache#Get(cache_key)
        if cached isnot v:null
            call a:cb(0, [cached], '')
            return
        endif
    endif
    
    let job_cmd = easyline#item#git#job#Build(a:cmd)
    if empty(job_cmd) 
        call a:cb(1, [''], '')
        return 
    endif

    if has_key(s:running_jobs, cache_key)
        return
    endif
    
    let s:running_jobs[cache_key] = 1
    
    let Callback = function('s:job_callback_wrapper', [a:cb, cache_key])
    
    if has('nvim')
        call s:run_nvim_job(job_cmd, Callback)
    elseif exists('*job_start')
        call s:run_vim_job(job_cmd, Callback)
    else
        call s:run_timer_job(job_cmd, Callback)
    endif
endfunction

function! s:job_callback_wrapper(original_cb, cache_key, job_id, data, event) abort
    if has_key(s:running_jobs, a:cache_key)
        unlet s:running_jobs[a:cache_key]
    endif
    
    let result = easyline#item#git#job#Validate(a:data)
    
    if !empty(result)
        call easyline#item#git#cache#Set(a:cache_key, result)
    endif
    
    call a:original_cb(a:job_id, a:data, a:event)
    
    call easyline#Update()
endfunction

function! s:run_nvim_job(cmd, callback) abort
    let opts = {
        \ 'on_stdout': a:callback,
        \ 'on_stderr': function('s:on_err'),
        \ 'stdout_buffered': v:true,
        \ 'stderr_buffered': v:true
        \ }
    call jobstart(a:cmd, opts)
endfunction

function! s:run_vim_job(cmd, callback) abort
    let opts = {
        \ 'out_cb': a:callback,
        \ 'err_cb': function('s:on_err'),
        \ 'out_mode': 'nl',
        \ 'timeout': 3000
        \ }
    call job_start(a:cmd, opts)
endfunction

function! s:run_timer_job(cmd, callback) abort
    let timer_id = timer_start(0, function('s:timer_execute', [a:cmd, a:callback]))
endfunction

function! s:timer_execute(cmd, callback, timer_id) abort
    try
        let result = split(system(a:cmd), "\n")
        call a:callback(0, result, '')
    catch /.*/
        call a:callback(1, [], v:exception)
    endtry
endfunction

function! s:on_err(job, data, event) abort
    if !empty(a:data) && len(filter(a:data, 'v:val !=# ""')) > 0
        " echo '[EASYLINE][GIT][ERROR]: ' . string(a:data)
    endif
endfunction
