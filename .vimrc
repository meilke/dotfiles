set nocompatible
set number
execute pathogen#infect()
execute pathogen#helptags()
syntax on
filetype plugin indent on
colorscheme molokai

let loaded_matchparen = 1

"let g:molokai_original = 1
"let g:rehash256 = 1

autocmd QuickFixCmdPost *grep* cwindow

set backupcopy=yes

command GdiffInTab tabedit %|Gdiff

let g:pymode_lint = 0
let g:pymode_lint_ignore = "E221"
let g:pymode_lint_on_fly = 1
let g:pymode_folding = 0

let g:ale_emit_conflict_warnings = 1
let g:ale_javascript_eslint_executable = $HOME . "/.nvm/versions/node/v7.8.0/bin/eslint"
let g:ale_python_pylint_executable = $HOME . "/.pyenv/versions/tox/bin/pylint"
let g:ale_lua_luacheck_executable = $HOME . "/LuaDist/luacheck/bin/luacheck"
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 0
let g:ale_linters = {'go': ['go vet']}
let g:ale_fixers = {'go': ['gofmt']}
let g:ale_fix_on_save = 1
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
nmap <F8> <Plug>(ale_fix)

let NERDTreeIgnore = ['\.pyc$']

set completeopt-=preview

nmap <Leader>s <Plug>(easymotion-sn)

autocmd FileType python nnoremap <Leader>= :0,$!yapf<CR>
nmap <Leader>ne :NERDTreeToggle<cr>
nmap <Leader>nf :NERDTreeFind<cr>

nmap <Leader>l :lclose<cr>
nmap <Leader>ll :ccl<cr>
nnoremap <expr> <leader>c tabpagenr('$') > 1 ? ':tabclose<CR>' : ':q<CR>'

nmap <Leader>pr :SidewaysRight<cr>
nmap <Leader>pl :SidewaysLeft<cr>
nmap <Leader>== :Tabularize /^[^=]*\zs=/l1c1l1<cr>

"
" vimrc file for following the coding standards specified in PEP 7 & 8.
"
" To use this file, source it in your own personal .vimrc file (``source
" <filename>``) or, if you don't have a .vimrc file, you can just symlink to it
" (``ln -s <this file> ~/.vimrc``).  All options are protected by autocmds
" (read below for an explanation of the command) so blind sourcing of this file
" is safe and will not affect your settings for non-Python or non-C files.
"
"
" All setting are protected by 'au' ('autocmd') statements.  Only files ending
" in .py or .pyw will trigger the Python settings while files ending in *.c or
" *.h will trigger the C settings.  This makes the file "safe" in terms of only
" adjusting settings for Python and C files.
"
" Only basic settings needed to enforce the style guidelines are set.
" Some suggested options are listed but commented out at the end of this file.

" Number of spaces that a pre-existing tab is equal to.
" For the amount of space used for a new tab use shiftwidth.
au BufRead,BufNewFile *py,*pyw,*.c,*.h set tabstop=8

" What to use for an indent.
" This will affect Ctrl-T and 'autoindent'.
" Python: 4 spaces
" C: tabs (pre-existing files) or 4 spaces (new files)
au BufRead,BufNewFile *.py,*pyw set shiftwidth=4
au BufRead,BufNewFile *.py,*.pyw set expandtab
fu Select_c_style()
    if search('^\t', 'n', 150)
        set shiftwidth=8
        set noexpandtab
    el 
        set shiftwidth=4
        set expandtab
    en
endf
au BufRead,BufNewFile *.c,*.h call Select_c_style()
au BufRead,BufNewFile Makefile* set noexpandtab

" Use the below highlight group when displaying bad whitespace is desired.
highlight BadWhitespace ctermbg=red guibg=red

" Display tabs at the beginning of a line in Python mode as bad.
au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
" Make trailing whitespace be flagged as bad.
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" Turn off settings in 'formatoptions' relating to comment formatting.
" - c : do not automatically insert the comment leader when wrapping based on
"    'textwidth'
" - o : do not insert the comment leader when using 'o' or 'O' from command mode
" - r : do not insert the comment leader when hitting <Enter> in insert mode
" Python: not needed
" C: prevents insertion of '*' at the beginning of every line in a comment
au BufRead,BufNewFile *.c,*.h set formatoptions-=c formatoptions-=o formatoptions-=r

" Use UNIX (\n) line endings.
" Only used for new files so as to not force existing files to change their
" line endings.
" Python: yes
" C: yes
au BufNewFile *.py,*.pyw,*.c,*.h set fileformat=unix


" ----------------------------------------------------------------------------
" The following section contains suggested settings.  While in no way required
" to meet coding standards, they are helpful.

" Set the default file encoding to UTF-8: ``set encoding=utf-8``

" Puts a marker at the beginning of the file to differentiate between UTF and
" UCS encoding (WARNING: can trick shells into thinking a text file is actually
" a binary file when executing the text file): ``set bomb``

" For full syntax highlighting:
"``let python_highlight_all=1``
"``syntax on``

" Automatically indent based on file type: ``filetype indent on``
" Keep indentation level from previous line: ``set autoindent``

" Folding based on indentation: ``set foldmethod=indent``
"
au BufRead,BufNewFile *.json,*.js,*.jsx set tabstop=8
au BufRead,BufNewFile *.json,*.js,*.jsx set shiftwidth=2
au BufRead,BufNewFile *.json,*.js,*.jsx set expandtab

au BufRead,BufNewFile *.yml,*.yaml set tabstop=8
au BufRead,BufNewFile *.yml,*.yaml set shiftwidth=2
au BufRead,BufNewFile *.yml,*.yaml set expandtab

au BufRead,BufNewFile *.rb set tabstop=4
au BufRead,BufNewFile *.rb set shiftwidth=4
au BufRead,BufNewFile *.rb set expandtab

au BufRead,BufNewFile *.go set tabstop=4
au BufRead,BufNewFile *.go set shiftwidth=4

au BufRead,BufNewFile *.hs set shiftwidth=4
au BufRead,BufNewFile *.hs set expandtab

au BufRead,BufNewFile *.proto set shiftwidth=4
au BufRead,BufNewFile *.proto set expandtab

au BufRead,BufNewFile *.lua set shiftwidth=4
au BufRead,BufNewFile *.lua set expandtab
