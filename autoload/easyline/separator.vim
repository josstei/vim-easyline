function! easyline#separator#Highlight(value, side, curr_idx, next_idx) abort
  try
    let default     = '1A1B26'
    let identifier  = 'Separator'.win_getid()
    let bg          = easyline#highlight#Value('Item', a:side, a:curr_idx + 1, 'bg')
    let fg          = a:next_idx == -1 ? default : easyline#highlight#Value('Item', a:side, a:next_idx + 1, 'bg')

    call easyline#highlight#Execute(identifier,a:side,a:curr_idx + 1, bg, fg)

    return easyline#highlight#String(identifier, a:side, a:curr_idx + 1) . a:value
  catch /.*/
    throw 'Error while retrieving separator highlight: ' . v:exception
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
