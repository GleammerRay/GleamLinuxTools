set rnu
set scrolloff=9999

" Install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

" Automatically install missing plugs
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

" Plugs
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'
Plug 'xolox/vim-session'
Plug 'xolox/vim-misc'
Plug 'preservim/vim-indent-guides'
Plug 'dyng/ctrlsf.vim'
Plug 'echasnovski/mini.nvim'
Plug 'echasnovski/mini.animate'
Plug 'voldikss/vim-floaterm'
" >> Devdocs dependencies
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
" <<
Plug 'luckasRanarison/nvim-devdocs'
" Themes
Plug 'GGalizzi/cake-vim' " cake - Gleam's favourite light theme
Plug 'vim-scripts/billw.vim' " billw - Gleam's favourite dark theme
Plug 'wolandark/NotePad-Vim' " notepad
Plug 'morhetz/gruvbox' " gruvbox
Plug 'slugbyte/lackluster.nvim' " lackluster
Plug 'nelstrom/vim-blackboard' " blackboard
Plug 'spf13/vim-colors' " fruity ir_black molokai

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

if argc()
  let g:argv0=argv()[0]
  let g:argv0IsDir=isdirectory(expand(g:argv0))
else
  let g:argv0="null"
  let g:argv0IsDir=0
endif

" Default workspace with NERDTree to the left
function! s:OnEnter()
  if g:argv0IsDir
    execute "NERDTree" g:argv0
    execute "cd!" g:argv0
  else
    let parent=fnamemodify(g:argv0, ':h')
    execute "NERDTree" parent
    execute "cd!" parent
  endif
  wincmd l
  " Floaterm
  FloatermNew --title=Floaterm\ 0 --name=float0
  FloatermNew --title=Floaterm\ 9 --name=float9
  FloatermNew --title=Floaterm\ 8 --name=float8
  FloatermNew --title=Floaterm\ 7 --name=float7
  FloatermNew --title=Floaterm\ 6 --name=float6
  FloatermHide
  call feedkeys("\<ESC>")
  " Flutter
  if filereadable(fnamemodify(getcwd(), ':p') .. 'pubspec.yaml')
    call feedkeys(":FlutterTab\<CR>gt")
  endif
endfunction

function! s:CloseDir()
  if g:argv0IsDir
    bd
  endif
endfunction

autocmd VimEnter * call s:OnEnter()
autocmd VimEnter * call s:CloseDir()
autocmd BufWinEnter * NERDTreeMirror

function! s:OnWqa()
  execute "wa"
  execute "qa"
endfunction
command GleamWqa call s:OnWqa()
cnoreabbrev <expr> wqa getcmdtype() == ":" && getcmdline() == 'wqa' ? 'GleamWqa' : 'wqa'

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

" mini.animate
" lua require('mini.animate').setup()

" Floaterm
nmap <C-w>0 :FloatermToggle float0<CR>
nmap <C-w>9 :FloatermToggle float9<CR>
nmap <C-w>8 :FloatermToggle float8<CR>
nmap <C-w>7 :FloatermToggle float7<CR>
nmap <C-w>6 :FloatermToggle float6<CR>
tnoremap <C-w> <C-\><C-n>:FloatermHide!<CR>

" Devdocs
let g:gleam_devdocs_state = 'hidden'
function! g:GleamDevdocsSearch()
  let g:gleam_devdocs_state = 'shown'
  DevdocsOpenFloat
endfunction
lua require('nvim-devdocs').setup()
nmap <C-f> :call GleamDevdocsSearch()<CR>

" Flutter
let g:flutter_autoscroll = 1
