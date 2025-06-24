function! easyline#highlight#Constant(highlight,section, idx) abort
    return printf('Easyline%s%s%d',a:highlight, a:section, a:idx)
endfunction

function! easyline#highlight#Value(highlight,section,idx,type)
    try
        let hl_str = easyline#highlight#Constant(a:highlight,a:section,a:idx)
        let hi     = execute('hi ' . hl_str)
        return matchstr(hi, 'gui' . a:type . '=#\zs\x\{6\}')
    catch /.*/
        throw 'Easyline: ' . v:exception
    endtry
endfunction

function! easyline#highlight#String(highlight,section,idx) abort
    return '%#'.easyline#highlight#Constant(a:highlight,a:section, a:idx).'#'
endfunction

function! easyline#highlight#Execute(highlight,section,idx,fg,bg) abort
    let hl_str = easyline#highlight#Constant(a:highlight,a:section, a:idx)
    execute printf('highlight %s guifg=#%s guibg=#%s',hl_str,a:fg,a:bg)
endfunction
