
function! easyline#item#Get(item) abort
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
        let hl_str .= ' '
        let hl_str .= a:value
        let hl_str .= ' '
        return hl_str
    catch /.*/
        throw 'Error while building item highlight'
    endtry
endfunction
