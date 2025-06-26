function! easyline#Get(active) abort
    try
        let winid     = win_getid()
        let cur_winid = win_getid()
        if win_gotoid(winid)
            let status =  easyline#Build(a:active) 
            call win_gotoid(cur_winid)
            return status
        endif
    catch /.*/
        throw 'Error while retrieving statusline: ' . v:exception
    endtry
endfunction

function! easyline#Reverse(side,arr) abort
    try
	    if a:side == 'right' | call reverse(a:arr) | endif
	    return a:arr
    catch /.*/
        echoerr 'ERROR | easyline#Reverse() | ' . v:exception
    endtry
endfunction

function! easyline#Build(status) abort
    let statusline = [] 
    for side in ['Left','Right']
        let items       = easyline#item#Get(side,a:status)
        let separator   = easyline#separator#Get(side)
        let section     = easyline#section#Get(items,separator,side)

        call add(statusline,join(easyline#Reverse(side,section),''))
    endfor
    return join(statusline,'%=')
endfunction

function! easyline#Update() abort
    let cur_winid = win_getid()
    for t in range(1, tabpagenr('$'))
        for w in range(1, tabpagewinnr(t, '$'))
            let winid = win_getid(w, t)
            let is_active = (winid == cur_winid) ? 'active' : 'inactive'
            call win_execute(winid, 'let &l:statusline = easyline#Get("' . (is_active) . '")')
        endfor
    endfor
endfunction

function! easyline#ThrottledUpdate() abort
    if g:easyline_update_timer != -1 | call timer_stop(g:easyline_update_timer) | endif
    let g:easyline_update_timer = timer_start(g:easyline_update_throttle, { -> easyline#Update() })
endfunction
