set nocompatible

" ------------------------------------------------------
" Plugins

let g:plug_window = 'enew'

call plug#begin(stdpath('data'))

Plug 'mileszs/ack.vim'
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
Plug 'spf13/vim-colors'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'christoomey/vim-tmux-navigator'
Plug 'rhysd/conflict-marker.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'powerline/fonts'
Plug 'easymotion/vim-easymotion'
Plug 'flazz/vim-colorschemes'
Plug 'mbbill/undotree'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'vim-scripts/restore_view.vim'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-abolish'
Plug 'osyo-manga/vim-over'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'gcmt/wildfire.vim'
Plug 'tpope/vim-fugitive'
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'
Plug 'tpope/vim-commentary'
Plug 'godlygeek/tabular'
Plug 'luochen1990/rainbow'
Plug 'honza/vim-snippets'
Plug 'yssource/python.vim'
Plug 'itchyny/lightline.vim'
Plug 'itchyny/landscape.vim'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-unimpaired'
Plug 'Olical/vim-enmasse'
Plug 'pprovost/vim-ps1'
Plug 'ryanoasis/vim-devicons'
Plug 'will133/vim-dirdiff'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'mfussenegger/nvim-dap'
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}

call plug#end()

" ------------------------------------------------------
" General vim configurations
"
" vim-sensible takes care of most of the really common configuration changes
" for us. These configurations are more personal and to my liking.
"
scriptencoding utf-8

set t_Co=256
set visualbell
silent! colorscheme darkblue
set background=dark
set noshowmode

" Vertical split coloring
highlight VertSplit ctermbg=8 ctermfg=black
set fillchars+=vert:│

" Highlight coloring for cursor line and column
hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=cyan guifg=black
hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=yellow guifg=black
nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>

set number     " Show line numbers
set nowrap     " Don't visually wrap lines
set cursorline " Highlight the current cursor line
set cursorcolumn " Highlight the current cursor column
set hidden     " Allow buffer switching without having to save
set list       " Show non-printable characters
set hlsearch   " Highlight searched text
set ignorecase " Ignore case when searching
set smartcase  " Don't ignore case when using uppercase in a search
set confirm    " Ask for confirmation when closing unsaved files
set nu
set diffopt=iwhite
set errorformat=\ %#%f(%l\\\,%c):\ %m
"set foldmethod=syntax
"set foldlevel=1

" Incremental scrolling
set sidescroll=1
set sidescrolloff=1
set nosol

" Don't autoselect the first entry when doing completion
set completeopt=longest,menuone

" Tab configurations
set smartindent expandtab tabstop=4 shiftwidth=4

" Ignore cache type files
set wildignore+=*/cache/*,*.sassc

" Better list characters
set listchars=tab:\›\ ,trail:-
highlight SpecialKey ctermbg=8 ctermfg=10

" Clear the background of the sign column (guter)
highlight clear SignColumn

if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8
  "setglobal bomb
  set fileencodings=ucs-bom,utf-8,latin1
endif

" Lightline plugin configuration
" ----------------------------
let g:lightline = {
      \ 'colorscheme': 'ayu_mirage',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype', 'gitbranch' ] ]
      \ },
      \ 'inactive': {
      \   'left': [ [ 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'gitbranch' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

" Open help windows on the right in a vertical split
augroup help_win
  au!
  au FileType help wincmd L
augroup END


" Mason
" ----------------------------
lua << EOF
require("mason").setup()
EOF

" CoQ (autocomplete engine)
" ----------------------------
let g:coq_settings = { 'auto_start': 'shut-up', 'xdg': v:true, 'keymap.jump_to_mark': '<c-m>' }

lua << EOF
require("coq_3p") {
  { src = "nvimlua", short_name = "nLUA" },
  { src = "dap", short_name = "dbug" },
  { src = "repl", sh = "zsh", shell = { p = "python3", n = "node" }, max_lines = 99, deadline = 500, unsafe = { "rm", "poweroff", "mv" } }
}
EOF

" Language Servers
" ---------------------------
lua << EOF
require'lspconfig'.pylsp.setup{
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {'W391'},
          maxLineLength = 100
        }
      }
    }
  }
}
require'lspconfig'.tsserver.setup{}
EOF

" Vim-Ack configuration
" -----------------------
if executable('rg')
  let g:ackprg = 'rg --vimgrep'
  let g:ctrlp_user_command = 'rg %s -l --files --color never -g ""'
elseif executable('ag')
  let g:ackprg = 'ag --vimgrep'
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" Neoformat configuration
" -----------------------
"let g:neoformat_run_all_formatters = 1
"let g:neoformat_enabled_python = ['autopep8']
"let g:neoformat_enabled_javascript = ['eslint', 'prettier']
"let g:neoformat_enabled_yaml = []

" format on save.
" Silence E790: https://vi.stackexchange.com/a/13401/1787
"if match(&runtimepath, 'neoformat') != -1
"  augroup fmt
"    au!
"    au BufWritePre * try | undojoin | catch /^Vim\%((\a\+)\)\=:E790/ | finally | Neoformat | endtry
"  augroup END
"endif
"

" CtrlP configuration
" -----------------------
"let g:ctrlp_working_path_mode = 'ra'
"let g:ctrlp_clear_cache_on_exit = 0
"let g:ctrlp_match_window = 'bottom,order:ttb'
"let g:ctrlp_switch_buffer = 0
"let g:ctrlp_dont_split = 'NERD'
"noremap <C-a> :CtrlP $HOME/../../Git/<CR>

" CHADTree configuration
" -----------------------
let g:chadtree_settings = { 'keymap.primary': ["o"], 'keymap.secondary': ["<enter>"], 'keymap.change_focus_up': ['u'], 'keymap.toggle_follow': ['U'], 'keymap.quit': ["<F4>"], 'keymap.v_split': ['s'], 'keymap.h_split': ['i'], 'keymap.delete': ["D"], 'keymap.change_focus': ["d"], 'theme.text_colour_set': "nord" }

" EasyMotion configuration
" -----------------------
hi EasyMotionTarget ctermbg=red ctermfg=black
hi EasyMotionTarget2First ctermbg=red ctermfg=black
hi EasyMotionTarget2Second ctermbg=red ctermfg=black
hi EasyMotionShade ctermbg=none ctermfg=blue

if !has("gui_running")
    set t_Co=256
endif

" Toggle whitespace to be ignored in vimdiff with gs
" ----------------------------------------
 if &diff
     map gs :call IwhiteToggle()<CR>
     function! IwhiteToggle()
       if &diffopt =~ 'iwhite'
         set diffopt-=iwhite
       else
         set diffopt+=iwhite
       endif
     endfunction
 endif

" ------------------------------------------------------
"  Mappings

map <f1> :CHADopen<CR>
map <f2> :copen<CR>
map <f3> :cclose<CR>
"map <f4> :NERDTreeMirrorToggle<CR>

"map <f5> :lcd %:p:h<CR>:!buildThis<CR>
"
"<f6> and <f7> used in gvim (gui.vim) only - open for console vim
"
map <f8> :TagbarToggle<CR>
"let g:spf13_edit_config_mapping='<f9>'
map <f10> :windo diffthis<CR>
map <f11> :windo diffoff<CR>
"let g:spf13_apply_config_mapping='<f12>'
"
nnoremap <A--> :NERDTreeFind<CR>
nnoremap <space>gxa :Git add %:p<CR><CR>
nnoremap <space>gxs :Gstatus<CR>
nnoremap <space>gxc :Gcommit<CR>
nnoremap <space>gxd :Gdiff<CR>
nnoremap <leader>vh :vsp %:r.h*<CR>
nnoremap <leader>vc :vsp %:r.c*<CR>
nnoremap <leader>sh :sp %:r.h*<CR>
nnoremap <leader>sc :sp %:r.c*<CR>
nnoremap <leader>ec :e ++enc=cp1252<CR>
nnoremap <leader>cn :cnext<CR>
nnoremap <leader>cp :cprev<CR>
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
nnoremap <space><C-S-h> <nop>
noremap <Right> <nop>
nnoremap <space><C-S-l> <nop>

map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)
cabbrev vb vert sb

" ------------------------------------------------------
" File type specific configurations
" Mostly consisting of Auto commands applied when matching files are opened

autocmd BufReadPost fugitive://* set bufhidden=delete

" Return to last edit position when opening files
" (https://rogin.xyz/blog/sensible-neovim)
" -----------------------
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

autocmd User fugitive 
  \ if get(b:, 'fugitive_type', '') =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif

augroup my_fts
  au BufRead,BufNewFile *.md        set filetype=markdown
  au BufRead,BufNewFile *.rt        set filetype=html
  au BufRead,BufNewFile *.raml      set filetype=yaml
  au BufRead,BufNewFile *Jenkinsfile set syntax=groovy
augroup END


if has("gui_running")
  scriptencoding utf-8

  set guioptions -=mrLT
  "set guifont=Source_Code_Pro_for_Powerline:h9:cANSI:qDRAFT
  "set guifont=Space_Mono_for_Powerline:h7:cANSI:qDRAFT
  "set guifont=@D2Coding_ligature:h10:cANSI
  "set guifont=Hack_NF:h9:cANSI:qDRAFT
" set guifont=CaskaydiaCove_NF:h11:cANSI:qDRAFT
set guifont=Iosevka_Nerd_Font_Mono:h11:cANSI:qDRAFT
  colorscheme darkblue
endif
