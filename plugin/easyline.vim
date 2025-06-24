if exists('g:easyline_loaded')
    finish
else
    let g:easyline_loaded= 1
endif

if !exists('g:easyline_left_items')
    let g:easyline_theme_loaded = 0
endif

if !exists('g:easyline_left_items')
    let g:easyline_Left_items = ['windownumber','filename','modified']
endif

if !exists('g:easyline_left_separator')
    let g:easyline_Left_separator = ''
endif

if !exists('g:easyline_right_items')
    let g:easyline_Right_items = ['position','filetype','encoding']
endif

if !exists('g:easyline_right_separator')
    let g:easyline_Right_separator = ''
endif

if !exists('g:easyline_exclude')
    let g:easyline_exclude = []
endif

function! easyline#SetTheme(name) abort
    try
        let l:theme     = a:name ==# '' ? get(g:, 'colors_name', 'default') : a:name
        let l:fn_name   = substitute('easyline#themes#' . l:theme . '#get','-','_','g')
        let l:colors    = call(function(l:fn_name),[])

        for i in range(1, 7)
            if has_key(l:colors, 'itemLeft' . i)
                execute 'highlight EasylineItemLeft' . i . 
                      \ ' guifg=' . get(l:colors, 'foreground', '#ffffff') . 
                      \ ' guibg=' . l:colors['itemLeft' . i]
            endif
            if has_key(l:colors, 'itemRight' . i)
                execute 'highlight EasylineItemRight' . i . 
                      \ ' guifg=' . get(l:colors, 'foreground', '#ffffff') . 
                      \ ' guibg=' . l:colors['itemRight' . i]
            endif
        endfor

        if has_key(l:colors, 'middle')
            execute 'highlight EasylineItemSpacer guifg=' . get(l:colors, 'foreground', '#ffffff') . ' guibg=' . l:colors['middle']
        endif
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
