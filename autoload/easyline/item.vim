function! easyline#item#Value(item) abort
    try
        let l:func  = 'easyline#item#'. a:item . '#get'
        let l:val   = call(function(l:func), [])
        return !empty(l:val) ? ' ' . l:val :  ''
    catch /.*/
        return 'Error while retrieving item value'
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

function!easyline#item#Get(side,status) abort
    let items = copy(get(g:, 'easyline_' . a:side . '_'. a:status . '_items', []))
    return a:side == 'right' ? reverse(items) : items
endfunction

function! easyline#Reverse(side,arr) abort
    try
	    if a:side == 'right' | call reverse(a:arr) | endif
	    return a:arr
    catch /.*/
        echoerr 'ERROR | easyline#Reverse() | ' . v:exception
    endtry
endfunction
