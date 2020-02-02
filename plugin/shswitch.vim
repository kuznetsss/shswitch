let g:shswitch_source_extensions = get(g:, 'shswitch_source_extensions', ['c', 'cpp'])
let g:shswitch_header_extensions = get(g:, 'shswitch_header_extensions', ['h', 'hpp'])
let g:shswitch_root_flags = get(g:, 'shswitch_root_flags', ['CMakeLists.txt'])

function! CheckRoot(directory) 
    for flag in g:shswitch_root_flags
        if filereadable(a:directory . '/' . flag)
            return 1
        endif
    endfor
    return 0
endfunction

function! FindFile(start_directory, filenames)
    " Check local files
    for f in a:filenames
        if filereadable(f)
            return a:start_directory . '/' . f
        endif
    endfor

    let l:directory = a:start_directory
    
    while !CheckRoot(l:directory) && l:directory != '/'
        let l:directory = fnamemodify(l:directory, ':h')
    endwhile

    for f in a:filenames
        let l:result = system('find ' . l:directory . ' -type f -name ' . f . 
                    \ ' 2>/dev/null | head -n 1')
        if l:result != ''
            return l:result
        endif
    endfor

    return 'None'
endfunction

function! g:SHSwitch()
    let l:current_file_ext = expand('%:e')
    let l:current_file_name = expand("%:r")
    let l:target_extensions = []
    let l:target_file_variants = []

    if index(g:shswitch_header_extensions, l:current_file_ext) >=0
        " Current file is header
        let l:target_extensions = g:shswitch_source_extensions
    elseif index(g:shswitch_source_extensions, l:current_file_ext) >=0
        " Current file is source file
        let l:target_extensions = g:shswitch_header_extensions
    else
        echo 'SHSwitch: Unknown file extension "' . l:current_file_ext . '"'
        return
    endif

    for e in l:target_extensions
        call add(l:target_file_variants, l:current_file_name . '.' . e)
    endfor

    let l:result = FindFile(expand('%:p:h'), l:target_file_variants)
    if l:result == 'None'
        echo "SHSwitch: Can't find relative file"
        return
    endif
    exe 'edit ' . l:result
endfunction

command! SHSwitch call SHSwitch()
