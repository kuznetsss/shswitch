let g:shswitch_source_extensions = get(g:, 'shswitch_source_extensions', ['c', 'cpp'])
let g:shswitch_header_extensions = get(g:, 'shswitch_header_extensions', ['h', 'hpp'])
let g:shswitch_root_flags = get(g:, 'shswitch_root_flags', ['CMakeLists.txt'])

function! FindFile(start_directory, filenames)
    " Check local files
    for f in a:filenames
        if filereadable(f)
            return a:start_directory . '/' . f
        endif
    endfor

    " Find project root
    for flag in g:shswitch_root_flags
        let l:root_flag = findfile(flag, a:start_directory . ';')
        if strlen(l:root_flag) != 0
            break
        endif
    endfor
    if strlen(l:root_flag) == 0
        echo "SHSwitch: Can't find project root. Check that 'g:shswitch_root_flags' is correct."
        return 'None'
    endif

    let l:root_path = fnamemodify(l:root_flag, ':h')

    for f in a:filenames
        let l:result = findfile(f, l:root_path . '**')
        if strlen(l:result) != 0
            return l:result
        endif
    endfor

    return 'None'
endfunction

function! g:SHSwitch()
    let l:current_file_ext = expand('%:e')
    let l:current_file_name = fnamemodify(expand("%:r"), ":t")
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

    if &autowrite
        write
    endif

    if &modified
        exe 'split ' . l:result
    else
        exe 'edit ' . l:result
    endif
endfunction

command! SHSwitch call SHSwitch()
