if exists('g:easyline_loaded')
    finish
else
    let g:easyline_loaded= 1
endif

if !exists('g:easyline_Left_active_items')
    let g:easyline_Left_active_items = ['windownumber','filename','modified']
endif

if !exists('g:easyline_Left_inactive_items')
    let g:easyline_Left_inactive_items = ['windownumber','filename','modified']
endif

if !exists('g:easyline_Left_separator')
    let g:easyline_Left_separator = ''
endif

if !exists('g:easyline_Right_active_items')
    let g:easyline_Right_active_items = ['position','filetype','encoding']
endif

if !exists('g:easyline_Right_inactive_items')
    let g:easyline_Right_inactive_items = ['position','filetype','encoding']
endif

if !exists('g:easyline_Right_separator')
    let g:easyline_Right_separator = ''
endif

if !exists('g:easyline_buffer_exclude')
    let g:easyline_buffer_exclude = []
endif

if !exists('g:easyline_update_throttle')
    let g:easyline_update_throttle = 20
endif

let g:easyline_update_timer = -1

function! easyline#SetTheme(name) abort
    try
        let l:theme     = a:name ==# '' ? get(g:, 'colors_name', 'default') : a:name
        let l:fn_name   = substitute('easyline#themes#' . l:theme . '#get','-','_','g')
        let l:colors    = call(function(l:fn_name),[])
        let fg          = get(l:colors, 'foreground', '#ffffff')
        let mid         = get(l:colors, 'middle', '#ffffff')

        for i in range(1, 7)
            for side in ['Left','Right']
                let bg = get(l:colors, 'item' .side . i, '#ffffff')
                execute 'highlight EasylineItem' . side . i . ' guifg=' . fg . ' guibg=' . bg
            endfor
        endfor

        execute 'highlight EasylineItemSpacer guifg=' . fg . ' guibg=' . mid

    catch /.*/
        echo 'Easyline: Error while setting theme : ' . v:exception
    endtry
endfunction

augroup easyline_update
        autocmd!
        autocmd ColorScheme * call easyline#SetTheme('') | call easyline#Update()
        autocmd VimEnter,BufEnter,WinEnter * call easyline#SetTheme('') | call easyline#Update()
        autocmd BufLeave,WinLeave * call easyline#Update()
        autocmd CursorMoved,CursorMovedI * call easyline#ThrottledUpdate()
augroup END
