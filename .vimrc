" Begin .vimrc


filetype plugin on

" set language of messages to C
lang mes C
"
"-------------------------------------------------------------------------------
" include functions
"-------------------------------------------------------------------------------
source ~/.vim/vim-functions

"-----------------------------------------------------------------------------
" taglist.vim : toggle the taglist window
" taglist.vim : define the title texts for Perl
"-----------------------------------------------------------------------------
noremap <silent> <F11>  <Esc><Esc>:Tlist<CR>
inoremap <silent> <F11>  <Esc><Esc>:Tlist<CR>
let Tlist_Inc_Winwidth=0
let Tlist_Exit_OnlyWindow=1
let Tlist_Auto_Update=1
let Tlist_Compact_Format = 1
let tlist_perl_settings  = 'perl;c:constants;l:labels;p:package;s:subroutines;d:POD;a:attribute'
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Use_SingleClick = 1

"-------------------------------------------------------------------------------
" Filename completion
"
"   wildmenu : command-line completion operates in an enhanced mode
" wildignore : A file that matches with one of these
"              patterns is ignored when completing file or directory names.
"-------------------------------------------------------------------------------
set wildmenu
set wildignore=*.bak,*.o,*.e,*~


"-------------------------------------------------------------------------------
" print options  (pc = percentage of the media size)
"-------------------------------------------------------------------------------
set printoptions=left:8pc,right:3pc

"-------------------------------------------------------------------------------
" syntax highlighting
"-------------------------------------------------------------------------------

syntax on
au BufRead,BufNewFile *.yapp           setfiletype eyapp
au BufRead,BufNewFile *.yp           setfiletype eyapp
au BufRead,BufNewFile *.eyp         setfiletype eyapp 
au Bufenter shell* 					so ~/.vim/APos-support/run_shell.vim

autocmd BufNewFile,BufRead *.p? compiler perl
autocmd BufNewFile,BufRead *.p? map <F1> :Perldoc <cword><CR>
autocmd BufNewFile,BufRead *.p? setf perl
autocmd BufNewFile,BufRead *.p? let g:perldoc_program="/home/neo/perl5/perlbrew/perls/perl-5.12.5/bin/perldoc"
autocmd BufNewFile,BufRead *.p? source /home/neo/.vim/ftplugin/perl_doc.vim


source ~/.vimrc-user


"-------------------------------------------------------------------------------
" read write autocommands
"-------------------------------------------------------------------------------
au  BufWritePre *.t  so ~/.vim/APos-support/Perl_ACR_write.vim
au  BufWritePre *.pm  so ~/.vim/APos-support/Perl_ACR_write.vim
au  BufWritePre *.pl  so ~/.vim/APos-support/Perl_ACR_write.vim
au  BufWritePre *.cgi  so ~/.vim/APos-support/Perl_ACR_write.vim



"-------------------------------------------------------------------------------
" vim options
"-------------------------------------------------------------------------------

set nocompatible
set bs=2
set background=dark
set shiftwidth=3
set tabstop=3
" no line break after whitespace on long lines 
set textwidth=0
set nobk
set ruler
set noexpandtab
set showmode
set autoindent
set incsearch
set nowrap
set dictionary=~/.vim/dict/sql-dict
set complete=.,w,k,t
set nohlsearch
" case insensitive if ^[a-z]$ overwise case sensitive
set smartcase
set virtualedit=all
" perl support leader
"let mapleader="\"

"-------------------------------------------------------------------------------
" vim options - status line
"-------------------------------------------------------------------------------

set laststatus=2
set statusline=
set statusline+=%-3.3n\                      " buffer number
set statusline+=%f\                          " file name
set statusline+=%h%m%r%w                     " flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{&encoding},                " encoding
set statusline+=%{&fileformat}]              " file format
set statusline+=%=                           " right align
set statusline+=%#perlInfo#%{CurrentFunction()}%*
set statusline+=\ \ \  	      
set statusline+=0x%B/%-8b\                      " current char
set statusline+=(%v)
set statusline+=%(%l/%L%)
"set statusline+=%-14.(%l/%L%)
"set statusline+=%-14.(%l,%c%V%)\ %<%L




"-------------------------------------------------------------------------------
" (i)maps
"-------------------------------------------------------------------------------

"map <F2> V$%zfzaza

" ---------------------------------------- perl help
"imap <F1> <ESC>:call PerlHelp()<ENTER>
"imap <F1> <ESC>:call PerlHelp()<ENTER>

"----------------------------------------- function Zwin
imap <F2> <ESC>:call RollUp()<ENTER>i
map <F2> :call RollUp()<ENTER>

"----------------------------------------- function NewFunction and NewFunctionParam
map <F3> :WMToggle<CR>
let Tlist_Inc_Winwidth = 0
map <F4> :TlistToggle<CR>

"----------------------------------------- function RecordDumper
inoremap <F12> <C-R>=RecordDumper()<CR>
map <F12> :call RecordDumper()<CR>

"----------------------------------------- function CleverTab
inoremap <Tab> <C-R>=CleverTab()<CR>
inoremap <C-F> <C-X><C-I>

inoremap <Leader>J <C-R>=JiraRefLink()<CR>

"----------------------------------------- LaTeX
map <F9> :w<ENTER>:!pdflatex %<ENTER>:!xpdf <C-R>=expand("%:t:r")<CR>.pdf<ENTER>
"map <F10> :!kprinter <C-R>=expand("%:t:r")<CR>.pdf<ENTER>

map <F10> <ESC>:%!xmllint --format -<CR>:set ro<CR>

"----------------------------------------- function PVcalc
imap <C-L> <ESC>:call PVcalc()<CR>ja
imap <C-D> <ESC>?#\s*p<CR>:call PVcalc()<CR>j<CR>

"----------------------------------------- function Pmysql
imap <C-S> <ESC>yy:call Pmysql()<CR>j:s/\r/\r/g<CR>
imap <C-K> <ESC>yy:call Pmysql()<CR>j:s/\r/\r/g<CR>

"----------------------------------------- perlsupport
" run script
map <S-F5> <Leader>rc
map <F5> <Leader>rr
" syntax check
map <F6> <Leader>rs
nnoremap <silent> <Leader>ts :ExtsSelectToggle<CR>
nnoremap <silent> <Leader>tt :ExtsStackToggle<CR>
map <silent> <Leader>] :ExtsGoDirectly<CR>
map <silent> <Leader>[ :PopTagStack<CR>
let g:exTS_backto_editbuf = 0
let g:exTS_close_when_selected = 1

" open project window
nmap <silent> <F8> <Plug>ToggleProject


noremap A :cp<CR>
noremap S :cn<CR>

" perl-support extensions
"noremap <F7> :call OpenBrother()<CR>
noremap <Leader>id iprint Data::Dumper::Dumper(); # FIXME inline debug<ESC>22ha

" --- neo77 perl extensions ----
"
set tabstop=4
set expandtab
set shiftwidth=4
set shiftround
" tab and backspace as 4 spaces
set softtabstop=4   

" mouse paste
"set mouse=iv

"abbreviations
iab xfo <ESC>:call Perl_InsertTemplate("statements.foreach")<CR>
iab xif <ESC>:call Perl_InsertTemplate("statements.if")<CR>
iab xel <ESC>:call Perl_InsertTemplate("statements.else")<CR>
iab xei <ESC>:call Perl_InsertTemplate("statements.elsif")<CR>
iab xie <ESC>:call Perl_InsertTemplate("statements.if-else")<CR>
iab xwh <ESC>:call Perl_InsertTemplate("statements.while")<CR>
iab xdw <ESC>:call Perl_InsertTemplate("statements.do-while")<CR>
iab xew <ESC>:call Perl_InsertTemplate("statements.each-while")<CR>
iab __@_;  my $self = __@_;<ESC>o
iab sss  $self->
imap ~d <ESC>^iwarn Data::Dumper->Dump([\<ESC>llyw$a], ['<ESC>pa']);<ESC>
imap ~v <ESC>v?><CR>ly?\$<CR>imy $o_<ESC>pa = <ESC>$a;<CR>
imap ~c <ESC>lvbdimy $o_<ESC>pi = $self-><ESC>pi;<CR>


vmap <tab>      >gv
vmap <bs>       <gv
nmap <tab>      I<tab><esc>
nmap <bs>    ^i<bs><esc>

set pastetoggle=<Ins>

vmap _c :s/^/# /gi<Enter>
vmap _C :s/^# //gi<Enter>

vnoremap <silent> !t :!perltidy -ce -fs --continuation-indentation=4   -cti=0 -cpi=0 -l=350 --line-up-parentheses -pt=0 -sbt=1 -bt=0 -bbt=0 -nsbl -vt=0 -vtc=0 -sot -isbc -nolq -msc=4 -hsc -csc -csci=1 -cscp="+ end of:" -cscb -fs -bbs<CR> :'<,'>s/__ @_/__@_/g<CR>


"
"

"------------------------------------------ Online Help (require konqueror)
" perl/ruby/cpp doc online
map <Leader><F1> :call OnlineDoc()<CR>
" wikipedia online
map <Leader>w :call WikiDoc()<CR>
" google online (doest work correctly yet)
map <Leader>g :call GoogleDoc()<CR>
"

"-------------------------------------------------------------------------------
" exprerimental - live
"-------------------------------------------------------------------------------

let g:miniBufExplTabWrap = 5
noremap <silent> <F11> :cal VimCommanderToggle()<CR>

set tags=./tags,tags,$TOPDIR/tags 
"-------------------------------------------------------------------------------
" include user file
"-------------------------------------------------------------------------------

let g:dup = 0
nmap dup k:call Dup()<CR>
nmap cdup :let g:dup = 0<CR>:%s/warn.*DEBUG-VIM\n//<CR>


if has("gui_running")
	colorscheme pablo
endif

nnoremap ,/ :M/
nnoremap ,? :M?
"inoremap <ENTER> <C-R>=Comment()<CR>



" End .vimrc


