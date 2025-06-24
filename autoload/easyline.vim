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
        let items       = copy(get(g:, 'easyline_' . a:side . '_items', []))
        let separator   = copy(get(g:, 'easyline_' . a:side . '_separator',''))
        let totalItems  = len(items)
        let curwinid    = win_getid()

        call easyline#Reverse(a:side,items)

        for idx in range(0, totalItems - 1)
            let item = easyline#item#Get(items[idx])
            if item != ''
                let item_next   = (idx + 1 < totalItems) ? easyline#item#Get(items[idx + 1]) : ''
                let hl_item     = easyline#item#Highlight(item,a:side,idx)
                let hl_sep      = easyline#separator#Highlight(separator,a:side,idx)
                let hl_arr      = [hl_item,hl_sep]

                call easyline#Reverse(a:side,hl_arr)
                call easyline#separator#Set(item_next,a:side,idx)
                call add(arr_section,join(hl_arr,''))
            endif
        endfor

        call easyline#Reverse(a:side,arr_section)

        return join(arr_section,'')
    catch /.*/
        echoerr 'ERROR | easyline#Section() | ' . v:exception
    endtry
endfunction

 function! easyline#Reverse(side,arr) abort
    try
        if a:side == 'right'
            call reverse(a:arr)
        endif
     catch /.*/
        echoerr 'ERROR | easyline#Reverse() | ' . v:exception
     endtry
 endfunction

 function! easyline#Build()
     try
         let s:statusline  = ''
         let s:statusline .= easyline#Section('Left')
         let s:statusline .= '%='
         let s:statusline .= easyline#Section('Right')
         return s:statusline
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

let g:easyline_update_timer = -1

function! easyline#ThrottledUpdate() abort
    if g:easyline_update_timer != -1 | call timer_stop(g:easyline_update_timer) | endif
    let g:easyline_update_timer = timer_start(150, { -> easyline#Update() })
endfunction
