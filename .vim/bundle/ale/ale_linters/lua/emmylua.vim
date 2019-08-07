function! ale_linters#lua#emmylua#GetExecutable(buffer) abort
    return 'java'
endfunction

function! ale_linters#lua#emmylua#GetCommand(buffer) abort
    return 'java -cp /home/corp.cyren.com/cmeilke/sources/EmmyLua-LanguageServer/EmmyLua-LS/build/libs/EmmyLua-LS-all.jar com.tang.vscode.MainKt'
endfunction

function! ale_linters#lua#emmylua#FindProjectRoot(buffer) abort
    let l:dotgit = ale#path#FindNearestDirectory(a:buffer, '.git')

    if !empty(l:dotgit)
        return fnamemodify(l:dotgit, ':h')
    endif

    return ''
endfunction

call ale#linter#Define('lua', {
\   'name': 'emmylua',
\   'lsp': 'stdio',
\   'executable': function('ale_linters#lua#emmylua#GetExecutable'),
\   'command': function('ale_linters#lua#emmylua#GetCommand'),
\   'project_root': function('ale_linters#lua#emmylua#FindProjectRoot'),
\})
