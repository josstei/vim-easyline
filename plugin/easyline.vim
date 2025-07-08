if exists('g:easyline_loaded')
    finish
else
    let g:easyline_loaded= 1
endif

if !exists('g:easyline_left_active_items')
    let g:easyline_left_active_items = ['windownumber','filename','modified']
endif

if !exists('g:easyline_left_inactive_items')
    let g:easyline_left_inactive_items = ['windownumber','filename','modified']
endif

if !exists('g:easyline_left_separator')
    let g:easyline_left_separator = '█'
endif

if !exists('g:easyline_right_active_items')
    let g:easyline_right_active_items = ['position','filetype','encoding']
endif

if !exists('g:easyline_right_inactive_items')
    let g:easyline_right_inactive_items = ['position','filetype','encoding']
endif

if !exists('g:easyline_right_separator')
    let g:easyline_right_separator = '█'
endif

if !exists('g:easyline_buffer_exclude')
    let g:easyline_buffer_exclude = []
endif

if !exists('g:easyline_update_throttle')
    let g:easyline_update_throttle = 20
endif

if !exists('g:easyline_default_theme')
    let g:easyline_default_theme = 'default'
endif

let g:easyline_update_timer = -1

function! easyline#SetTheme(name) abort
    try
        let l:theme = a:name ==# '' ? get(g:, 'colors_name', g:easyline_default_theme) : a:name
        
        try
            let l:fn_name   = substitute('easyline#themes#' . l:theme . '#get','-','_','g')
            let l:colors = call(function(l:fn_name),[])
        catch /.*/
            let l:fn_name   = substitute('easyline#themes#' . g:easyline_default_theme . '#get','-','_','g')
            let l:colors    = call(function(l:fn_name),[])
        endtry
        
        let fg  = get(l:colors, 'foreground', '#d0d0d0')
        let mid = get(l:colors, 'middle', '#505050')

        for i in range(1, 7)
            for side in ['Left','Right']
                let bg = get(l:colors, 'item' .side . i, '#808080')
                execute 'highlight EasylineItem' . side . i . ' guifg=' . fg . ' guibg=' . bg
            endfor
        endfor

    catch /.*/
        echohl ErrorMsg
        echo 'Easyline: Error while setting theme: ' . v:exception
        echohl None
    endtry
endfunction

augroup easyline_update
    autocmd!
    autocmd ColorScheme * call easyline#SetTheme('') | call easyline#Update()
    autocmd VimEnter,BufEnter,WinEnter * call easyline#SetTheme('') | call easyline#Update()
    autocmd BufLeave,WinLeave * call easyline#Update()
    autocmd Filetype * call easyline#Update()
    autocmd CursorMoved,CursorMovedI * call easyline#ThrottledUpdate()
augroup END
