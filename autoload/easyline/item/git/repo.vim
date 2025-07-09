let s:repo_cache = {}

function! easyline#item#git#repo#Get() abort
    let cwd = getcwd()
    
    if has_key(s:repo_cache, cwd)
        let entry = s:repo_cache[cwd]
        if localtime() - entry.timestamp < 30
            return entry.path
        endif
    endif
    
    let git_dir             = finddir('.git', expand('%:p:h') . ';')
    let repo_path           = !empty(git_dir) ? fnamemodify(git_dir, ':h') : ''
    let s:repo_cache[cwd]   = { 'path': repo_path, 'timestamp': localtime() }
    
    return repo_path
endfunction

function! easyline#item#git#repo#ClearCache() abort
    let s:repo_cache = {}
endfunction
