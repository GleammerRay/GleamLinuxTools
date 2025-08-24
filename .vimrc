set rnu
set scrolloff=9999

" #region Plugins

" #region Install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif
" #endregion

" #region Automatically install missing plugs
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif
" #endregion

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
Plug 'tpope/vim-surround'
" #region Devdocs dependencies
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
" #endregion
Plug 'luckasRanarison/nvim-devdocs'
Plug 'pseewald/vim-anyfold' " Cool code folding plugin - use :AnyFoldActivate to enable
Plug 'Exafunction/windsurf.vim'
" #region Themes
Plug 'GGalizzi/cake-vim' " cake - Gleam's favourite light theme
Plug 'vim-scripts/billw.vim' " billw - Gleam's favourite dark theme
Plug 'wolandark/NotePad-Vim' " notepad
Plug 'morhetz/gruvbox' " gruvbox
Plug 'slugbyte/lackluster.nvim' " lackluster
Plug 'nelstrom/vim-blackboard' " blackboard
Plug 'spf13/vim-colors' " fruity ir_black molokai
" https://vimcolorschemes.com/earthbound-themes/vim
Plug 'earthbound-themes/vim' " cave-of-the-past devils-machine dusty-dunes-darker dusty-dunes earthbound-darker earthbound fire-spring-darker fire-spring magicant moonside threed-darker threed
Plug 'timmyha/visitant.vim' " visitant
Plug 'google/vim-colorscheme-primary' " primary - background=light & background=dark
" #endregion

call plug#end()

" #endregion

" #region Theme
let g:colors_name='primary'
set t_Co=256
set background=light
"hi MatchParen guifg=#7a8aff guibg=#ededed guisp=#7a8aff gui=NONE ctermfg=12 ctermbg=255 cterm=NONE
autocmd VimEnter,ColorScheme * hi! link CocFloating CocHintFloat
" #endregion

" #region Syntax highlighting
syntax on
"let g:NERDTreeNodeDelimiter = "\u00a0"
" #endregion

let g:lsc_auto_map = {'defaults': v:true, 'Completion': '<tab>'}

" #region Fixes
" Don't use Ex mode, use Q for formatting
" Revert with ":unmap Q".
map Q gq

" CTRL-U in insert mode deletes a lot. Use CTRL-G to first break undo.
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>
" #endregion

" #region Mouse
if has('mouse')
  set mouse=a
endif
" #endregion

" #region Tabs
set expandtab
set tabstop=2
set shiftwidth=2
command T execute "tabe"
nnoremap H gT
nnoremap L gt
nmap <silent> <c-h> gT
nmap <silent> <c-l> gt
" #endregion

" #region Splits
nmap <silent> <s-k> :wincmd k<CR>
nmap <silent> <s-j> :wincmd j<CR>
nmap <silent> <s-h> :wincmd h<CR>
nmap <silent> <s-l> :wincmd l<CR>
" #endregion

" #region Autocomplete
set wildmode=longest,list,full
set wildmenu
" #endregion

" #region Sessions
function! s:SaveSession()
  "execute "SaveSession!" substitute(getcwd(), '/', '--', 'g')
  execute "SaveSession!" 'default'
endfunction
let g:session_autosave='no'
let g:session_default_to_last=1
" #endregion

" #region Autocommands

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

" #region Default workspace with NERDTree to the left
function! s:OnEnter()
  execute "colorscheme" g:colors_name
  if g:argv0IsDir
    execute "NERDTree" g:argv0
    execute "cd!" g:argv0
  else
    let parent=fnamemodify(g:argv0, ':h')
    execute "NERDTree" parent
    execute "cd!" parent
  endif
  wincmd l
  " #region Floaterm
  FloatermNew --title=Floaterm\ 0 --name=float0
  FloatermNew --title=Floaterm\ 9 --name=float9
  FloatermNew --title=Floaterm\ 8 --name=float8
  FloatermNew --title=Floaterm\ 7 --name=float7
  FloatermNew --title=Floaterm\ 6 --name=float6
  FloatermHide
  " #endregion
  call feedkeys("\<ESC>")
  " #region Flutter
  if filereadable(fnamemodify(getcwd(), ':p') .. 'pubspec.yaml')
    call feedkeys(":FlutterTab\<CR>gt")
  endif
  " #endregion
endfunction
" #endregion

function! s:CloseDir()
  if g:argv0IsDir
    bd
  endif
endfunction

autocmd VimEnter * call s:OnEnter()
autocmd VimEnter * call s:CloseDir()
autocmd BufWinEnter * NERDTreeMirror

" #region Indent Guides
let g:indent_guides_enable_on_vim_startup = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=black ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=white ctermbg=4
" #endregion

" #endregion

function! s:OnWqa(bang)
  FloatermKill!
  if a:bang
    execute "wa!"
    execute "qa!"
  else
    execute "wa"
    execute "qa"
  endif
endfunction
command -bang GleamWqa call s:OnWqa(<bang>0)
cnoreabbrev <expr> wqa getcmdtype() == ":" && getcmdline() == 'wqa' ? 'GleamWqa' : 'wqa'

function! s:OnQa(bang)
  FloatermKill!
  if a:bang
    execute "qa!"
  else
    execute "qa"
  endif
endfunction
command -bang GleamQa call s:OnQa(<bang>0)
cnoreabbrev <expr> qa getcmdtype() == ":" && getcmdline() == 'qa' ? 'GleamQa' : 'qa'

" #region coc.nvim

inoremap <silent><expr> <tab> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<TAB>"
inoremap <silent><expr> <cr> "\<c-g>u\<CR>"
nmap <c-space>  <Plug>(coc-codeaction-cursor)

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [j <Plug>(coc-diagnostic-prev)
nmap <silent> [k <Plug>(coc-diagnostic-next)

" #endregion

" #region User commands
command PassySendApk execute "! /home/gleam/Desktop/kde-send-passy.sh"
" #endregion

" #region Easier escape
inoremap jj <ESC>
" #endregion

" #region Aliases
command SaveAll bufdo w 
" #endregion

" #region CtrlSF
let g:ctrlsf_position = 'right'
let g:ctrlsf_auto_focus = {
    \ "at": "start"
    \ }
" #endregion

" mini.animate
" lua require('mini.animate').setup()

" #region Floaterm
nmap <C-w>0 :FloatermToggle float0<CR>
nmap <C-w>9 :FloatermToggle float9<CR>
nmap <C-w>8 :FloatermToggle float8<CR>
nmap <C-w>7 :FloatermToggle float7<CR>
nmap <C-w>6 :FloatermToggle float6<CR>
tnoremap <C-w> <C-\><C-n>:FloatermHide!<CR>
" #endregion

" #region Devdocs
let g:gleam_devdocs_state = 'hidden'
function! g:GleamDevdocsSearch()
  let g:gleam_devdocs_state = 'shown'
  DevdocsOpenFloat
endfunction
lua require('nvim-devdocs').setup()
nmap <C-f> :call GleamDevdocsSearch()<CR>
" #endregion

" #region Flutter
let g:flutter_autoscroll = 1
function! s:GleamFlutter(...)
  let s:fluttercommand = 'echo "GleamFlutter: No such command"'
  let s:firstread = 0
  for s in a:000
    if s:firstread
      let s:fluttercommand = s:fluttercommand .. ' ' .. s
    else
      if s == 'devices'
        let s:fluttercommand = 'FlutterDevices'
      elseif s == 'run'
        let s:fluttercommand = 'FlutterRun'
      elseif s == 'split'
        let s:fluttercommand = 'FlutterSplit'
      elseif s == 'vsplit'
        let s:fluttercommand = 'FlutterVSplit'
      elseif s == 'attach'
        let s:fluttercommand = 'FlutterAttach'
      elseif s == 'emulators'
        let s:fluttercommand = 'FlutterEmulators'
      elseif s == 'quit'
        let s:fluttercommand = 'FlutterQuit'
      elseif s == 'stop'
        let s:fluttercommand = 'FlutterQuit'
      elseif s == 'screenshot'
        let s:fluttercommand = 'FlutterScreenshot'
      elseif s == 'tab'
        let s:fluttercommand = 'FlutterTab'
      elseif s == 'devices'
        let s:fluttercommand = 'FlutterDevices'
      elseif s == 'reload'
        let s:fluttercommand = 'FlutterHotReload'
      elseif s == 'restart'
        let s:fluttercommand = 'FlutterHotRestart'
      endif
      let s:firstread = 1
    endif
  endfor
  execute s:fluttercommand
endfunction
command -nargs=* Flutter call s:GleamFlutter(<f-args>)
cnoreabbrev <expr> flutter getcmdtype() == ":" && getcmdline() == 'flutter' ? 'Flutter' : 'flutter'
" #endregion

" #region C# style comment folding - use zc to fold, zo to open and zM to fold all
set foldmarker=\#region,\#endregion
set foldmethod=marker
" #endregion
