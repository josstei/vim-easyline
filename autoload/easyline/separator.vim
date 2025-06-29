function! easyline#separator#Highlight(value,side,idx) abort
    try
        let hl_str  =  easyline#highlight#String('Separator'.win_getid(),a:side,a:idx + 1) 
        return hl_str . a:value
    catch /.*/
        throw 'Error while retrieving item value'
    endtry
endfunction

function! easyline#separator#Set(val,side,idx) abort
    try
        let default = '1A1B26' 
        let hl_bg   = easyline#highlight#Value('Item',a:side, a:idx + 1,'bg')
        let hl_fg   = a:val != '' ? easyline#highlight#Value('Item',a:side, a:idx + 2,'bg') : default
        call easyline#highlight#Execute('Separator'.win_getid(),a:side,a:idx + 1,hl_bg,hl_fg)
    catch /.*/
        echom 'Easyline: ' . v:exception
    endtry
endfunction

function!easyline#separator#Get(side) abort
    try
        let l:side  = tolower(strpart(a:side, 0, 1)) . strpart(a:side, 1)
        return copy(get(g:, 'easyline_' . l:side . '_separator', []))
    catch /.*/
        throw 'Easyline: ' . v:exception        
    endtry
endfunction
