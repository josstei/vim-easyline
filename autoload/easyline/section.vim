function! easyline#section#Get(items, separator, side) abort
    try
        let arr_section = []
        let totalItems  = len(a:items)
        for idx in range(0, totalItems - 1)
            let item = easyline#item#Value(a:items[idx])
            if item != ''
                let idx_next = -1
                for j in range(idx + 1, totalItems - 1)
                    if easyline#item#Value(a:items[j]) != ''
                        let idx_next = j
                        break
                    endif
                endfor

                let hl_item = easyline#item#Highlight(item, a:side, idx)
                let hl_sep  = easyline#separator#Highlight(
                      \ a:separator,
                      \ a:side,
                      \ idx,
                      \ idx_next 
                      \ )
                let str = easyline#highlight#Build(easyline#Reverse(a:side, [hl_item, hl_sep]))
                call add(arr_section, str)
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

