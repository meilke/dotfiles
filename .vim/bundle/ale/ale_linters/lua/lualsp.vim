call ale#Set('lua_lua_lsp_executable', 'lua-lsp')

function! ale_linters#lua#lualsp#FindProjectRoot(buffer) abort
    let l:dotgit = ale#path#FindNearestDirectory(a:buffer, '.git')

    if !empty(l:dotgit)
        return fnamemodify(l:dotgit, ':h')
    endif

    return ''
endfunction

call ale#linter#Define('lua', {
\   'name': 'lualsp',
\   'lsp': 'stdio',
\   'executable': {b -> ale#Var(b, 'lua_lua_lsp_executable')},
\   'command': '%e',
\   'project_root': function('ale_linters#lua#lualsp#FindProjectRoot'),
\})
