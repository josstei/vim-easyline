function! easyline#item#encoding#get()
    return &fileencoding !=# '' ? &fileencoding : &encoding
endfunction
