set rnu
set scrolloff=9999

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'
Plug 'xolox/vim-session'
Plug 'xolox/vim-misc'
Plug 'preservim/vim-indent-guides'
Plug 'GGalizzi/cake-vim'
Plug 'dyng/ctrlsf.vim'

call plug#end()

" Theme
colorscheme cake
hi MatchParen guifg=#7a8aff guibg=#ededed guisp=#7a8aff gui=NONE ctermfg=12 ctermbg=255 cterm=NONE
autocmd VimEnter,ColorScheme * hi! link CocFloating CocHintFloat

let g:lsc_auto_map = {'defaults': v:true, 'Completion': '<tab>'}

" Don't use Ex mode, use Q for formatting
" Revert with ":unmap Q".
map Q gq

" CTRL-U in insert mode deletes a lot. Use CTRL-G to first break undo.
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Mouse
if has('mouse')
  set mouse=a
endif

" Tabs
set expandtab
set tabstop=2
set shiftwidth=2
command T execute "tabe"
nnoremap H gT
nnoremap L gt

" Splits
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

" Autocomplete
set wildmode=longest,list,full
set wildmenu

" Sessions
function! s:SaveSession()
  "execute "SaveSession!" substitute(getcwd(), '/', '--', 'g')
  execute "SaveSession!" 'default'
endfunction
let g:session_autosave='no'
let g:session_default_to_last=1

" Autocommands
augroup typescript_save | au!
  autocmd BufWritePost *.dart DartFmt
augroup end

let g:argv0=argv()[0]

function! s:OnEnter()
  if argc()
    if isdirectory(g:argv0)
      execute "NERDTree" g:argv0
      execute "cd!" g:argv0
    else
      let parent=fnamemodify(g:argv0, ':h')
      execute "NERDTree" parent
      execute "cd!" parent
    endif
    wincmd l
  "else
    "let session_file=expand('~/.vim/sessions/' . substitute(getcwd(), '/', '--', 'g') . '.vim')
    "let session_file=expand('~/.vim/sessions/default.vim')
    "if filereadable(session_file)
      "execute "OpenSession!" 'default'
    "endif
  endif
endfunction

function! s:CloseDir()
  if argc()
    if isdirectory(expand(g:argv0))
      bd
    endif
  endif
endfunction

autocmd VimEnter * call s:OnEnter()
autocmd VimEnter * call s:CloseDir()
autocmd BufWinEnter * NERDTreeMirror
"autocmd VimLeave *
"            \   call s:SaveSession()

" coc.nvim
inoremap <silent><expr> <tab> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<TAB>"
inoremap <silent><expr> <cr> "\<c-g>u\<CR>"
nmap <c-space>  <Plug>(coc-codeaction-cursor)

" Indent Guides
let g:indent_guides_enable_on_vim_startup = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=black ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=white ctermbg=4

" User commands
command PassySendApk execute "! /home/gleam/Desktop/kde-send-passy.sh"

" Easier escape
inoremap jj <ESC>

" Aliases
command SaveAll bufdo w 

" CtrlSF
let g:ctrlsf_position = 'right'
let g:ctrlsf_auto_focus = {
    \ "at": "start"
    \ }
