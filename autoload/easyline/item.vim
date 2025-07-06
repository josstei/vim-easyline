function! easyline#item#Value(item) abort
    try
        let l:func  = 'easyline#item#'. a:item . '#get'
        let l:val   = call(function(l:func), [])
        return !empty(l:val) ? ' ' . l:val. ' ' :  ''
    catch /.*/
        return 'Error while retrieving item value: ' . v:exception
    endtry
endfunction

function! easyline#item#Highlight(value,section,idx) abort
    try
        let hl_str  =  easyline#highlight#String('Item',a:section,a:idx + 1) 
        return hl_str . ' ' . a:value . ' '
    catch /.*/
        throw 'Error while building item highlight'
    endtry
endfunction

function! easyline#item#Get(side,status) abort
    let l:side          = tolower(strpart(a:side, 0, 1)) . strpart(a:side, 1)
    let l:file_override = 'easyline_' . l:side . '_' . a:status . '_items_' . &filetype

    if exists('g:' . l:file_override)
        let l:items = copy(get(g:, l:file_override, []))
    else
        let l:items = copy(get(g:, 'easyline_' . l:side . '_' . a:status . '_items', []))
    endif
    return a:side == 'right' ? reverse(l:items) : l:items
endfunction

function! easyline#Reverse(side,arr) abort
    try
	    if a:side == 'right' | call reverse(a:arr) | endif
	    return a:arr
    catch /.*/
        echoerr 'ERROR | easyline#Reverse() | ' . v:exception
    endtry
endfunction

function! easyline#item#Next(idx,items)
    try
        let l:items = copy(a:items)
        let l:totalCount = len(l:items)
        if a:idx + 1 < l:totalCount
            let item = easyline#item#Value(l:items[a:idx + 1])
            return item
        else
            return ''
        endif                                
    catch /.*/
        throw 'Easyline: ' . v:exception
    endtry
endfunction
