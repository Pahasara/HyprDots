" github.com/pahasara


" REQUIRED {{{
set nocompatible
filetype off			" required
syntax enable
" }}}

" PLUGINS {{{
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'	" Required to work properly
Plugin 'tpope/vim-commentary'	
Plugin 'neoclide/coc.nvim', {'branch': 'master', 'do': 'npm ci'}
Plugin 'junegunn/fzf.vim'
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'jiangmiao/auto-pairs'   " Auto Pairs
Plugin 'preservim/nerdtree'		" NERDTree
Plugin 'farmergreg/vim-lastplace'	" Remember cursor place of a file
Plugin 'christoomey/vim-tmux-navigator'  " Enable tmux-<Ctrl><h-j-k-l>

" Fancy stuffs
Plugin 'sheerun/vim-polyglot'
Plugin 'uiiaoo/java-syntax.vim'  " Better syntax highlighting for java
"Plugin 'mhinz/vim-startify'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'ryanoasis/vim-devicons' " Will required nerd fonts to work
Plugin 'dracula/vim', {'name' : 'dracula'}
Plugin 'vim-autoformat/vim-autoformat'

call vundle#end()			" required

filetype plugin indent on	" required
" }}}

" BASIC CONFIGURATION {{{
set number relativenumber
set smartindent			" Enable sameindent as the line above it
set mouse=a             " Enabling mouse in vim
set path+=**
set wildmode=longest,list,full
set encoding=UTF-8
set cursorline
set showmatch			" Showing matching brackets
set ignorecase			" Do case insensitive matching
set smartcase			" Do smart case matching
set hlsearch			" Use highlighting when doing a search.
set clipboard=unnamedplus		   "Use system clipboard. If 'unnamedplus' doesn't work, try 'unnamed'.
set foldenable
set foldmethod=marker          " Default value: syntax
set foldmarker={{{,}}}
set tabstop=4
set shiftwidth=4
set softtabstop=4
set spelllang=en_us		" Default language for spell checkers.
set fillchars+=eob:-
set scrolloff=10
set scrolloff=10
" }}}

" BASIC STYLING {{{
colorscheme dracula

hi Normal ctermbg=NONE
hi Folded cterm=bold ctermbg=NONE ctermfg=135
hi Comment cterm=italic

" CursorLine configuration
hi CursorLine ctermbg=NONE cterm=NONE
hi CursorLineNr ctermbg=NONE cterm=Bold ctermfg=252 " Defaults: cterm=bold ctermfg=green"
hi LineNr ctermbg=NONE ctermfg=245
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

hi SpellBad ctermbg=Red ctermfg=White
hi SpellCap cterm=NONE ctermbg=NONE
hi SpellRare cterm=NONE ctermbg=NONE
hi SpellLocal cterm=Underline cterm=NONE
" }}}

" BASIC KEY BINDING {{{

" Remap Esc Key
inoremap    ''     <Esc>

" Map leader key
let mapleader=";"

" NERDTree
nmap        <F2>      :NERDTreeToggle<CR>

" Unsets the last search pattern 
nnoremap <Esc> :noh<CR><CR> 

" Swap current line with lower line.
map <leader>x ddp

" Toggle spellchecker
map <leader>s :setlocal spell!<CR>

" Enable and disable auto indent
map <leader>a :setlocal autoindent<CR>
map <leader>A :setlocal noautoindent<CR>

" Enable and disable auto comment
map <leader>c :setlocal formatoptions-=cro<CR>
map <leader>C :setlocal formatoptions=cro<CR>
" }}}

" COC CONFIG {{{

" https://raw.githubusercontent.com/neoclide/coc.nvim/master/doc/coc-example-config.vim

" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
set encoding=utf-8
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=auto

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
" }}}

"  VIM AIRLINE CONFIG {{{
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='dracula'
" }}}

" FCF CONFIG {{{
let g:fzf_preview_window = ['right:50%', 'ctrl-/']
let g:fzf_preview_window = ['up:40%:hidden', 'ctrl-/']
let g:fzf_preview_window = []

map <leader>e :History<CR>
map <leader>f :Files<CR>
" }}}

" TAB AND SPLIT {{{

noremap <Tab> gt
noremap <S-Tab> gT
noremap <C-n> :tabnew<CR>
nmap <silent> <A-w> :q<CR>
noremap <silent> <C-,> :tabmove -<CR>
noremap <silent> <C-.> :tabmove +<CR>
nnoremap <C-h> :tabprevious<CR>
nnoremap <C-l> :tabnext<CR>


set splitbelow splitright

" Open terminal in splits
nnoremap <leader>st :sp<Space>\|<Space>terminal<CR>
nnoremap <leader>vt :vs<space>\|<space>terminal<CR>

" Change orientation of splits.
map <leader>th <C-w>t<C-w>H
map <leader>tk <C-w>t<C-w>K

" Split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resizing splits
noremap <silent> <A-l> :vertical resize +2<CR>
noremap <silent> <A-h> :vertical resize -2<CR>
noremap <silent> <A-k> :resize +2<CR>
noremap <silent> <A-j> :resize -2<CR>
" }}}

" NERDTree CONFIG {{{
let NERDTreeShowBookmarks = 1
let NERDTreeShowHidden = 1
let NERDTreeShowLineNumbers = 0
let NERDTreeMinimalMenu = 1
let NERDTreeWinPos = "left"
let NERDTreeWinSize = 31

" auto-close NERTree when vim closing
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" }}}
