let s:cache         = {}
let s:cache_timeout = 5000

function! easyline#item#git#cache#Get(key) abort
    let cache_key = getcwd() . ':' . a:key
    if has_key(s:cache, cache_key)
        let entry = s:cache[cache_key]
        if localtime() - entry.timestamp < (g:easyline_git_cache_timeout / 1000)
            return entry.value
        else
            unlet s:cache[cache_key]
        endif
    endif
    return v:null
endfunction

function! easyline#item#git#cache#Set(key, value) abort
    let cache_key           = getcwd() . ':' . a:key
    let s:cache[cache_key]  = { 'value': a:value, 'timestamp': localtime() }
endfunction

function! easyline#item#git#cache#Clear(...) abort
    if a:0 > 0
        let cache_key = getcwd() . ':' . a:1
        if has_key(s:cache, cache_key)
            unlet s:cache[cache_key]
        endif
    else
        let s:cache = {}
    endif
endfunction

function! easyline#item#git#cache#Init() abort
    if !exists('g:easyline_git_cache_timeout')
        let g:easyline_git_cache_timeout = 5000
    endif
endfunction

call easyline#item#git#cache#Init()
