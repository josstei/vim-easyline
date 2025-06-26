function! easyline#section#Get(items,separator,side) abort
    try
        let arr_section = []
        let totalItems  = len(a:items)

        for idx in range(0, totalItems - 1)
            let item = easyline#item#Value(a:items[idx])
            if item != ''
                let item_next   = (idx + 1 < totalItems) ? easyline#item#Value(a:items[idx + 1]) : ''

                let hl_item     = easyline#item#Highlight(item,a:side,idx)
                let hl_sep      = easyline#separator#Highlight(a:separator,a:side,idx)
                
                let str = easyline#highlight#Build(easyline#Reverse(a:side,[hl_item,hl_sep]))

                call easyline#separator#Set(item_next,a:side,idx)
                call add(arr_section,str)
            endif
        endfor

        return arr_section
    catch /.*/
        echoerr 'ERROR | easyline#Section() | ' . v:exception
    endtry
endfunction

function easyline#section#BuildHighlightStr(type,side) abort
    let l:func  = 'easyline#'.a:val.'#Highlight'
    let l:val   = call(function(l:func), [])
endfunction
