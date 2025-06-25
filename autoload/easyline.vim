function! easyline#Get() abort
      try
        let winid       = win_getid()
        let cur_winid   = win_getid()

        if win_gotoid(winid)
            let status = easyline#Build()
            call win_gotoid(cur_winid)
            return status
        endif
    catch /.*/
        throw 'Error while retrieving statusline: ' . v:exception
    endtry
endfunction

function! easyline#Section(side) abort
    try
        let arr_section = []
        let items       = easyline#Reverse(a:side,easyline#item#Get(a:side))
        let separator   = easyline#separator#Get(a:side)
        let totalItems  = len(items)
        let curwinid    = win_getid()

        for idx in range(0, totalItems - 1)
            let value = easyline#item#Value(items[idx])
            if value != ''
                let item_next   = (idx + 1 < totalItems) ? easyline#item#Value(items[idx + 1]) : ''
                let hl_item     = easyline#item#Highlight(value,a:side,idx)
                let hl_sep      = easyline#separator#Highlight(separator,a:side,idx)
                let item        = easyline#highlight#Build(easyline#Reverse(a:side,[hl_item,hl_sep]))

                call easyline#separator#Set(item_next,a:side,idx)
                call add(arr_section,item)
            endif
        endfor

        return join(easyline#Reverse(a:side,arr_section),'')
    catch /.*/
        echoerr 'ERROR | easyline#Section() | ' . v:exception
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

 function! easyline#Build()
     try
         return easyline#Section('Left') . '%=' . easyline#Section('Right')
     catch /.*/
        echoerr 'ERROR | easyline#Build() | ' . v:exception
     endtry
 endfunction

function! easyline#Update() abort
    for t in range(1, tabpagenr('$'))
        for w in range(1, tabpagewinnr(t, '$'))
            let winid = win_getid(w, t)
            call win_execute(winid, 'let &l:statusline = easyline#Get()')
        endfor
    endfor
endfunction

function! easyline#ThrottledUpdate() abort
    if g:easyline_update_timer != -1 | call timer_stop(g:easyline_update_timer) | endif
    let g:easyline_update_timer = timer_start(g:easyline_update_throttle, { -> easyline#Update() })
endfunction
