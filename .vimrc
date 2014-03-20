"---------------------------------------------------------------------------------------"
" Vimrc By mopp :)
" __      __  _                              ____             __  __
" \ \    / / (_)                            |  _ \           |  \/  |
"  \ \  / /   _   _ __ ___    _ __    ___   | |_) |  _   _   | \  / | ___  _ __  _ __
"   \ \/ /   | | | '_ ` _ \  | '__|  / __|  |  _ <  | | | |  | |\/| |/ _ \| '_ \| '_ \
"    \  /    | | | | | | | | | |    | (__   | |_) | | |_| |  | |  | | (_) | |_) | |_) |
"     \/     |_| |_| |_| |_| |_|     \___|  |____/   \__, |  |_|  |_|\___/| .__/| .__/
"                                                     __/ |               | |   | |
"                                                    |___/                |_|   |_|
"---------------------------------------------------------------------------------------"

" バックアップファイルと一時ファイル設定
if isdirectory(expand('~/.vim/backup'))
    set backupdir=~/.vim/backup
    set directory=~/.vim/backup
endif
set backup
set writebackup     " 上書き前にバックアップ作成
set swapfile

" インデント設定
set backspace=2      " Backspaceの動作
set autoindent
set smartindent
set expandtab        " <Tab>の代わりに空白
set shiftwidth=4     " 自動インデントなどでずれる幅
set smarttab         " 行頭に<Tab>でshiftwidth分インデント
set softtabstop=4    " <Tab>, <BS>が対応する空白の数
set tabstop=4        " 画面上で<Tab>文字が占める幅
set formatoptions+=j " 行連結の時自動でコメント解除して連結

" エンコーディング関連
set encoding=utf-8                          " vim内部で通常使用する文字エンコーディング
set fileencodings=utf-8,sjis,cp932,euc-jp   " 既存ファイルを開く際の文字コード自動判別
set fileformats=unix,mac,dos                " 改行文字設定

" 検索と補完
set hlsearch            " 検索結果強調-:nohで解除
set incsearch           " インクリメンタルサーチを有効
set ignorecase          " 大文字小文字無視
set smartcase           " 大文字があれば通常の検索
set completeopt=menu    " 挿入モードでの補完設定
set wildmenu            " コマンドの補完候補を表示
let c = substitute($PWD, '[\r\|\n].*', '', 'g')
let &path = c . '/,' . c . '/include/,' . substitute($PATH, '/[a-zA-Z]*bin:', '/include/,', 'g')
unlet c

" 折りたたみ
set foldenable
set foldcolumn=3            " 左側に折りたたみガイド表示
set foldmethod=indent       " 折畳の判別
set foldtext=Mopp_fold()  " 折りたたみ時の表示設定
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo " fold内に移動すれば自動で開く

" 履歴など
set history=500                 " コマンドの保存履歴数
set viminfo='1000,<500,f1       " viminfoへの保存設定
set tags=./tags,tags            " タグが検索されるファイル
set viewoptions=cursor,folds    " :mkviewで保存する設定
if isdirectory(expand('~/.vim/undo'))
    set undodir=~/.vim/undo
    set undofile
endif

" その他
set helplang=ja                 " ヘルプ検索で日本語を優先
set whichwrap=b,s,h,l,<,>,[,]   " カーソルを行頭、行末で止まらないようにする
set timeout                     " マッピングのタイムアウト有効
set timeoutlen=1000             " マッピングのタイムアウト時間
set ttimeoutlen=0               " キーコードのタイムアウト時間
set matchpairs+=<:>             " 括弧のハイライト追加
if !has('gui_running')
    set spelllang+=cjk              " 日本語などの文字をスペルミスとしない
endif
" set spell
let g:loaded_netrwPlugin = 1    " 標準Pluginを読み込まない
let g:loaded_tar = 1
let g:loaded_tarPlugin= 1
let g:loaded_vimballPlugin = 1
let g:loaded_zip = 1
let g:loaded_zipPlugin = 1

" 外観設定
set ambiwidth=double    " マルチバイト文字や記号でずれないようにする
set cmdheight=2         " コマンドラインの行数
set cursorline          " 現在行に下線表示
set laststatus=2        " ステータスラインを表示する時
set list
set listchars=tab:>\ ,trail:\|,extends:<,precedes:<
set nowrap              " はみ出しの折り返し設定
set number              " 行番号表示
set ruler               " カーソルの現在地表示
set showcmd             " 入力中のコマンド表示
set showmatch           " 括弧強調
set showtabline=2       " タブバーを常に表示
set t_Co=256
set statusline=%<%F\ %m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).']['.&fileformat.']'}%=%l/%L,%c%V%8P
let g:lisp_rainbow = 1
let g:lisp_instring = 1
let g:lispsyntax_clisp = 1


"-------------------------------------------------------------------------------"
" Functions
"-------------------------------------------------------------------------------"
function! Mopp_fold()
    let line = ' ' . substitute(getline(v:foldstart), '^\s*', '', '')
    for i in range(&shiftwidth * v:foldlevel - 2)
        let line = '-' . line
    endfor
    let line = '+' . line

    let tail = printf('[ %2d Lines Lv%02d ] --- ', (v:foldend - v:foldstart + 1), v:foldlevel)

    let space_size = (winwidth(0) - &foldcolumn - strdisplaywidth(line . tail) - 1) - ((&number) ? max([&numberwidth, len(line('$'))]) : 0)

    return printf('%s%' . space_size . 'S%s', line, '', tail)
endfunction

function! Mopp_paste(register, paste_type, paste_cmd)
    let reg_type = getregtype(a:register)
    let store = getreg(a:register)
    call setreg(a:register, store, a:paste_type)
    exe 'normal "' . a:register . a:paste_cmd
    call setreg(a:register, store, reg_type)
endfunction


"-----------------------------------------------------------------------------------"
" Mappings                                                                          |
"-----------------------------------------------------------------------------------"
" コマンド        | ノーマル | 挿入 | コマンドライン | ビジュアル | 選択 | 演算待ち |
" map  / noremap  |    @     |  -   |       -        |     @      |  @   |    @     |
" nmap / nnoremap |    @     |  -   |       -        |     -      |  -   |    -     |
" vmap / vnoremap |    -     |  -   |       -        |     @      |  @   |    -     |
" omap / onoremap |    -     |  -   |       -        |     -      |  -   |    @     |
" xmap / xnoremap |    -     |  -   |       -        |     @      |  -   |    -     |
" smap / snoremap |    -     |  -   |       -        |     -      |  @   |    -     |
" map! / noremap! |    -     |  @   |       @        |     -      |  -   |    -     |
" imap / inoremap |    -     |  @   |       -        |     -      |  -   |    -     |
" cmap / cnoremap |    -     |  -   |       @        |     -      |  -   |    -     |
"-----------------------------------------------------------------------------------"

" Metaキーを有効化 Reference from http://d.hatena.ne.jp/thinca/20101215/1292340358
" if has('mac') && !has('gui_running')
"     for i in map( range(char2nr('a'), char2nr('z')) + range(char2nr('A'), char2nr('Z')) + range(char2nr('0'), char2nr('9')) , 'nr2char(v:val)')
"         execute 'set <M-'.i.'>='.i
"     endfor
" endif

let g:mapleader = ' '

" 矯正
inoremap <BS> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
noremap <BS> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
noremap <Up> <Nop>
noremap <Down> <Nop>

" 移動
noremap! <C-A> <Home>
noremap! <C-E> <End>
noremap! <C-F> <Right>
noremap! <C-B> <Left>
noremap! <C-D> <Del>
noremap! <M-f> <S-Right>
noremap! <M-b> <S-Left>
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>
noremap <C-J> G
noremap <C-K> gg
noremap <C-H> ^
noremap <C-L> $

" バッファ操作
noremap <silent> [B :<C-U>bfirst<CR>
noremap <silent> ]B :<C-U>blast<CR>
noremap <silent> [b :<C-U>bprevious<CR>
noremap <silent> ]b :<C-U>bnext<CR>

" Tab操作
noremap <Leader>to :tabnew<Space>
noremap <Leader>tc :tabclose<CR>
noremap <Leader>j gT
noremap <Leader>k gt
" 現在バッファをTabで開く
noremap <Leader>tsp :tab split<CR>

" 画面分割
noremap <Leader>sp :split<Space>
noremap <Leader>vsp :vsplit<Space>

" ロケーションリスト移動
nnoremap <silent> [o :cprevious<CR>
nnoremap <silent> ]o :cnext<CR>
nnoremap <silent> [O :<C-u>cfirst<CR>
nnoremap <silent> ]O :<C-u>clast<CR>

" Windowサイズ変更
noremap <silent> <S-Left> :<C-U>wincmd <<CR>
noremap <silent> <S-Right> :<C-U>wincmd ><CR>
noremap <silent> <S-Up> :<C-U>wincmd -<CR>
noremap <silent> <S-Down> :<C-U>wincmd +<CR>

" <C-Space> で <NUL> が来るため
map <NUL> <C-Space>
map! <NUL> <C-Space>

" Yank & Paste
nnoremap Y y$
nnoremap <silent> <Leader>pp :set paste!<CR>
xnoremap <C-Space> "+yy
nnoremap <silent> <Leader>lp :call Mopp_paste(v:register, 'l', 'p')<CR>
nnoremap <silent> <Leader>lP :call Mopp_paste(v:register, 'l', 'P')<CR>
nnoremap <silent> <Leader>cp :call Mopp_paste(v:register, 'c', 'p')<CR>
nnoremap <silent> <Leader>cP :call Mopp_paste(v:register, 'c', 'P')<CR>
nnoremap <silent> mlp :call Mopp_paste('+', 'l', 'p')<CR>
nnoremap <silent> mlP :call Mopp_paste('+', 'l', 'P')<CR>
nnoremap <silent> mcp :call Mopp_paste('+', 'c', 'p')<CR>
nnoremap <silent> mcP :call Mopp_paste('+', 'c', 'P')<CR>
nnoremap <silent> mp  :call Mopp_paste('+', 'l', 'p')<CR>

" 入れ替え
noremap ; :
noremap : ;

" カーソル下のwordをhelpする
" nnoremap <silent> <Leader>h :vertical aboveleft help <C-R><C-W><CR>
nnoremap <silent> <Leader>h :help <C-R><C-W><CR>
nnoremap <silent> <Leader>ht :tab help <C-R><C-W><CR>

" カレントウィンドウのカレントディレクトリを変更
nnoremap <Leader>cd :lcd %:p:h<CR>

" 検索ハイライト消去
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

" 空行を追加
nnoremap <silent> <CR> :<C-u>for i in range(1, v:count1) \| call append(line('.'),   '') \| endfor \| silent! call repeat#set("<CR>", v:count1)<CR>
" nnoremap <silent> <Leader>O   :<C-u>for i in range(1, v:count1) \| call append(line('.')-1, '') \| endfor \| silent! call repeat#set("<Space>O", v:count1)<CR>

" Tagが複数あればリスト表示
nnoremap <C-]> g<C-]>zz

" マクロ
noremap Q @@

" http://vim-users.jp/2011/04/hack214/
onoremap ( t(
onoremap ) t)
onoremap ; t;
onoremap < t<
onoremap > t>
onoremap [ t[
onoremap ] t]


"-------------------------------------------------------------------------------"
" Commands
"-------------------------------------------------------------------------------"
" カーソル位置のハイライト情報表示
command! -nargs=0 EchoHiID echomsg synIDattr(synID(line('.'), col('.'), 1), 'name')

if has('mac')
    " 引数に渡したワードを検索
    command! -nargs=1 MacDict      call system('open '.shellescape('dict://'.<q-args>))
    " カーソル下のワードを検索
    command! -nargs=0 MacDictCWord call system('open '.shellescape('dict://'.shellescape(expand('<cword>'))))
    " 辞書.app を閉じる
    command! -nargs=0 MacDictClose call system("osascript -e 'tell application \"Dictionary\" to quit'")
    " 辞書にフォーカスを当てる
    command! -nargs=0 MacDictFocus call system("osascript -e 'tell application \"Dictionary\" to activate'")
    " キーマッピング
    nnoremap <silent><Leader>do :<C-u>MacDictCWord<CR>
    vnoremap <silent><Leader>do y:<C-u>MacDict<Space><C-r>*<CR>
    nnoremap <silent><Leader>dc :<C-u>MacDictClose<CR>
    nnoremap <silent><Leader>df :<C-u>MacDictFocus<CR>
endif


"-------------------------------------------------------------------------------"
" GUI
"-------------------------------------------------------------------------------"
if has('gui_running')
    " gm
    set guioptions-=e
    set guioptions-=m
    set guioptions-=T
    set guioptions-=r
    set guioptions-=l
    set guioptions-=L

    let no_buffers_menu = 1

    set mousehide
    set vb
    set t_vb=

    if has('mac')
        set macmeta
        set guifont=Ricty-Regular:h13
    else
        set guifont=Ricty\ 12
        set lines=40
        set columns=120
    endif
endif


"-------------------------------------------------------------------------------"
" Plugin
"-------------------------------------------------------------------------------"
" neobundleが存在しない場合これ以降を読み込まない
if !isdirectory(expand('~/.vim/bundle/neobundle.vim'))
    echoerr 'No NeoBundle !'
    syntax enable
    colorscheme desert
    finish
endif

" neobundle
if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim
endif
call neobundle#rc()

NeoBundleFetch 'Shougo/neobundle.vim'

let g:neobundle#default_options = { 'loadInsert' : { 'autoload' : { 'insert' : '1' } } }

NeoBundle 'LeafCage/yankround.vim'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'Shougo/vimproc.vim', { 'build' : { 'mac' : 'make -f make_mac.mak', 'unix' : 'make -f make_unix.mak' } }
NeoBundle 'fholgado/minibufexpl.vim'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'luochen1990/rainbow'
NeoBundle 'mopp/DoxyDoc.vim'
NeoBundle 'mopp/autodirmake.vim'
NeoBundle 'mopp/mopkai.vim'
NeoBundle 'mopp/tailCleaner.vim'
NeoBundle 'osyo-manga/shabadou.vim'
NeoBundle 'osyo-manga/vim-reunions'
NeoBundle 'sudo.vim'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'thinca/vim-visualstar'
NeoBundle 'tpope/vim-repeat'
NeoBundleLazy 'Mizuchi/STL-Syntax', { 'autoload' : { 'filetypes' : [ 'c', 'cpp' ] } }
NeoBundleLazy 'Shougo/context_filetype.vim', { 'autoload' : { 'function_prefix' : 'context_filetype' } }
NeoBundleLazy 'Shougo/neocomplete.vim', { 'depends' : 'Shougo/context_filetype.vim',  'autoload' : { 'insert' : '1' }, 'disabled' : (!has('lua')), 'vim_version' : '7.3.885' }
NeoBundleLazy 'Shougo/neosnippet', { 'depends' : ['honza/vim-snippets', 'Shougo/neosnippet-snippets'], 'autoload' : { 'insert' : '1', 'unite_sources' : ['neosnippet/runtime', 'neosnippet/user', 'snippet']} }
NeoBundleLazy 'Shougo/neosnippet-snippets'
NeoBundleLazy 'Shougo/vimfiler', { 'depends' : 'Shougo/unite.vim', 'autoload' : { 'commands' : [ { 'name' : 'VimFiler', 'complete' : 'customlist,vimfiler#complete'}, 'VimFiler', 'VimFilerTab', 'VimFilerBufferDir', 'VimFilerCreate'], 'explorer' : 1,} }
NeoBundleLazy 'Shougo/vinarise', { 'autoload' : { 'commands' : 'Vinarise'} }
NeoBundleLazy 'deris/vim-rengbang', { 'autoload' : { 'commands' : ['RengBang', 'RengBangUsePrev']} }
NeoBundleLazy 'elzr/vim-json', { 'autoload' : { 'filetypes' : 'json' } }
NeoBundleLazy 'gregsexton/gitv', { 'depends' : 'tpope/vim-fugitive', 'autoload' : {'commands' : 'Gitv'} }
NeoBundleLazy 'honza/vim-snippets'
NeoBundleLazy 'info.vim', { 'autoload' : { 'commands' : 'Info'} }
NeoBundleLazy 'itchyny/dictionary.vim', { 'autoload' : { 'commands' : 'Dictionary'}, 'disabled' : (!has('mac')) }
NeoBundleLazy 'itchyny/thumbnail.vim', { 'autoload' : {'commands' : 'Thumbnail'} }
NeoBundleLazy 'kana/vim-niceblock', { 'autoload' : { 'mappings' : [['v', 'I'], ['v', 'A']] }}
NeoBundleLazy 'kana/vim-smartchr', '', 'loadInsert'
NeoBundleLazy 'kana/vim-smartinput', '', 'loadInsert'
NeoBundleLazy 'kannokanno/previm', { 'depends' : 'tyru/open-browser.vim', 'autoload' : { 'commands' : 'PrevimOpen', 'filetypes' : 'markdown' } }
NeoBundleLazy 'koron/codic-vim', { 'autoload' : { 'commands' : ['Codic'] } }
NeoBundleLazy 'koron/nyancat-vim', { 'autoload' : { 'commands' : [ 'Nyancat', 'Nyancat2',], } }
NeoBundleLazy 'majutsushi/tagbar', { 'autoload' : { 'commands'  : 'TagbarToggle' } }
NeoBundleLazy 'mattn/benchvimrc-vim', { 'autoload' : {'commands' : 'BenchVimrc'} }
NeoBundleLazy 'mattn/gist-vim', { 'depends' : 'mattn/webapi-vim', 'autoload' : {'commands' : 'Gist'} }
NeoBundleLazy 'mattn/learn-vimscript', { 'autoload' : { 'mappings'  : [ '<Leader>lv' ] } }
NeoBundleLazy 'mattn/sonictemplate-vim', { 'autoload' : { 'commands' : [ { 'name' : 'Template', 'complete' : 'customlist,sonictemplate#complete' } ], 'function_prefix' : 'sonictemplate' } }
NeoBundleLazy 'mopp/layoutplugin.vim', { 'autoload' : { 'commands' : 'LayoutPlugin'} }
NeoBundleLazy 'mopp/makecomp.vim', { 'autoload' : { 'commands' : [ { 'name' : 'Make', 'complete' : 'customlist,makecomp#get_make_argument' } ] } }
NeoBundleLazy 'mopp/next-alter.vim', { 'autoload' : { 'commands' : 'OpenNAlter', 'mappings'  : [ [ 'n', '<Plug>(next-alter-open)' ] ] } }
NeoBundleLazy 'mopp/openvimrc.vim' , { 'autoload' : { 'mappings'  : [ '<Plug>(openvimrc-open)' ] } }
NeoBundleLazy 'osyo-manga/vim-anzu', { 'autoload' : { 'mappings' : [ ['n', '<Plug>(anzu-' ] ] } }
NeoBundleLazy 'osyo-manga/vim-marching'
NeoBundleLazy 'osyo-manga/vim-over', { 'autoload' : { 'commands' : 'OverCommandLine' } }
NeoBundleLazy 'osyo-manga/vim-snowdrop'
NeoBundleLazy 'osyo-manga/vim-stargate', { 'autoload' : { 'commands' : [ { 'name' : 'StargateInclude', 'complete' : 'customlist,stargate#command_complete' } ] } }
NeoBundleLazy 'plasticboy/vim-markdown', { 'autoload' : { 'filetypes' : 'markdown' } }
NeoBundleLazy 'rhysd/vim-clang-format', { 'autoload' : { 'commands' : [ 'ClangFormat', 'ClangFormatEchoFormattedCode' ] } }
NeoBundleLazy 'rosenfeld/conque-term', { 'autoload' : { 'commands' : ['ConqueTerm', 'ConqueTermSplit', 'ConqueTermTab', 'ConqueTermVSplit'] } }
NeoBundleLazy 'scrooloose/nerdcommenter', { 'autoload' : { 'mappings' : [ [ 'nx', '<Plug>NERDCommenter' ] ] } }
NeoBundleLazy 'scrooloose/syntastic', '', 'loadInsert'
NeoBundleLazy 'sk1418/blockit', { 'autoload' : { 'commands' : 'Block', 'mappings' : [ [ 'v', '<Plug>BlockitVisual' ] ] } }
NeoBundleLazy 't9md/vim-smalls', { 'autoload' : { 'mappings'  : [ '<Plug>(smalls)' ] } }
NeoBundleLazy 'taichouchou2/alpaca_english', { 'disabled' : (!has('ruby')), 'build' : { 'mac' : 'bundle', }, 'autoload' : { 'unite_sources' : [ 'english_dictionary', 'english_example', 'english_thesaurus' ], } }
NeoBundleLazy 'taku-o/vim-copypath', { 'autoload' : { 'commands'  : ['CopyFileName', 'CopyPath'] } }
NeoBundleLazy 'thinca/vim-ft-help_fold', { 'autoload' : {'commands' : 'help'} }
NeoBundleLazy 'thinca/vim-painter'
NeoBundleLazy 'thinca/vim-ref', { 'autoload' : { 'commands' : [ { 'name' : 'Ref', 'complete' : 'customlist,ref#complete' } ], 'mappings'  : [ '<Plug>(ref-keyword)' ] } }
NeoBundleLazy 'thinca/vim-scouter'
NeoBundleLazy 'tpope/vim-fugitive', { 'external_commands' : [ 'git' ], 'disabled' : (!executable('git')), 'autoload' : { 'commands' : [ 'Gstatus', 'Gcommit', 'Gwrite', 'Gdiff', 'Gblame', 'Git', 'Ggrep' ] } }
NeoBundleLazy 'ujihisa/neco-look', { 'disabled' : (has('ruby')) }
NeoBundleLazy 'vim-jp/cpp-vim', { 'autoload' : { 'filetypes' : 'cpp' } }
NeoBundleLazy 'vim-jp/vimdoc-ja'
NeoBundleLazy 'vim-jp/vital.vim'
NeoBundleLazy 'vim-scripts/Arduino-syntax-file', { 'autoload' : { 'filetypes' : 'arduino' } }
NeoBundleLazy 'vim-scripts/sh.vim--Cla', { 'autoload' : { 'filetypes' : [ 'zsh', 'sh' ] } }
NeoBundleLazy 'yuratomo/java-api-complete', { 'autoload' : { 'filetypes' : 'java' } }

NeoBundleLazy 'rhysd/vim-operator-surround', { 'autoload' : { 'mappings' : [ [ 'n', '<Plug>(operator-surround-' ] ] } }
NeoBundleLazy 'kana/vim-operator-replace', { 'autoload' : { 'mappings'  : [ [ 'nv', '<Plug>(operator-replace)' ] ] } }
NeoBundleLazy 'kana/vim-operator-user', { 'autoload' : { 'function_prefix' : 'operator' } }
NeoBundleLazy 'tyru/operator-reverse.vim', { 'autoload' : { 'mappings'  : [ [ 'n', '<Plug>(operator-reverse-' ] ], 'commands' : 'OperatorReverseLines' } }
NeoBundleLazy 'yomi322/vim-operator-suddendeath', { 'depends' : 'kana/vim-operator-user', 'autoload' : {'mappings' : [ [ 'v', '<Plug>(operator-suddendeath)' ] ] } }

NeoBundleLazy 'h1mesuke/textobj-wiw', { 'autoload' : { 'mappings' : [ [ 'nov', '<Plug>(textobj-wiw-' ] ] } }
NeoBundleLazy 'kana/vim-textobj-function', { 'autoload' : { 'mappings' : [ [ 'ov', '<Plug>(textobj-function-' ] ] } }
NeoBundleLazy 'kana/vim-textobj-indent', { 'autoload' : { 'mappings' : [ [ 'ov', 'ai' ], [ 'ov', 'ii' ], [ 'ov', 'aI' ], [ 'ov', 'iI' ] ] } }
NeoBundleLazy 'kana/vim-textobj-line', { 'autoload' : { 'mappings' : [ [ 'ov', '<Plug>(textobj-line-' ] ] } }
NeoBundleLazy 'kana/vim-textobj-user', { 'autoload' : { 'function_prefix' : 'textobj' } }
NeoBundleLazy 'osyo-manga/vim-textobj-multiblock', { 'autoload' : { 'mappings' : [ [ 'ov', '<Plug>(textobj-multiblock-' ] ] } }
NeoBundleLazy 'osyo-manga/vim-textobj-multitextobj', { 'autoload' : { 'mappings' : [ [ 'ov', '<Plug>(textobj-multitextobj-A' ], [ 'ov', '<Plug>(textobj-multitextobj-B' ], [ 'ov', '<Plug>(textobj-multitextobj-C' ], [ 'ov', '<Plug>(textobj-multitextobj-D' ], [ 'ov', '<Plug>(textobj-multitextobj-E' ] ] } }
NeoBundleLazy 'rhysd/vim-textobj-word-column', { 'autoload' : { 'mappings' : [ [ 'ov', 'av' ], [ 'ov', 'iv' ] ] } }
NeoBundleLazy 'sgur/vim-textobj-parameter', { 'autoload' : { 'mappings' : [ [ 'ov', '<Plug>(textobj-parameter-' ] ] } }
NeoBundleLazy 'terryma/vim-expand-region', { 'autoload' : { 'mappings' : [ [ 'ov', '<Plug>(expand_region_' ] ] } }

NeoBundleLazy 'Shougo/unite.vim', { 'autoload' : { 'commands' : [{ 'name' : 'Unite', 'complete' : 'customlist,unite#complete_source'}], 'function_prefix' : 'unite' }}
NeoBundleLazy 'Shougo/unite-help', { 'autoload' : { 'unite_sources' : ['help'],} }
NeoBundleLazy 'Shougo/unite-outline', { 'autoload' : { 'unite_sources' : ['outline'],} }
NeoBundleLazy 'Shougo/unite-ssh', { 'autoload' : { 'unite_sources' : ['ssh'],} }
NeoBundleLazy 'Shougo/neomru.vim', { 'autoload' : { 'unite_sources' : ['file_mru'],} }
NeoBundleLazy 'osyo-manga/vim-reanimate', { 'autoload' : { 'unite_sources' : ['Reanimate'], 'commands' : ['ReanimateLoad', 'ReanimateSave']} }
NeoBundleLazy 'osyo-manga/unite-quickfix', { 'autoload' : { 'unite_sources' : ['quickfix'],} }
NeoBundleLazy 'thinca/vim-unite-history', { 'autoload' : { 'unite_sources' : ['history/command', 'history/yank', 'history/search'],} }
NeoBundleLazy 'rhysd/unite-codic.vim', { 'depends' : 'koron/codic-vim', 'autoload' : { 'unite_sources' : ['codic'] } }

NeoBundleLazy 'mattn/webapi-vim', { 'autoload' : { 'function_prefix' : 'webapi' } }
NeoBundleLazy 'tyru/open-browser.vim', { 'autoload' : { 'mappings'  : ['<Plug>(openbrowser-open)'], 'function_prefix' : 'openbrowser' } }

filetype plugin indent on

if !has('vim_starting')
    call neobundle#call_hook('on_source')
endif

" Unite
let g:unite_data_directory = expand('~/.vim/unite')
let g:unite_source_file_mru_limit = 50
let g:unite_cursor_line_highlight = 'TabLineSel'
let g:unite_enable_short_source_names = 1
let g:unite_source_history_yank_enable = 1
let g:unite_force_overwrite_statusline = 0
let g:unite_source_bookmark_directory = expand('~/.vim/bookmark')
if executable('ag')
    " for the silver searcher
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '--nocolor --nogroup'
    let g:unite_source_grep_max_candidates = 200
endif
nmap f [Unite]
nnoremap [Unite] <Nop>
nnoremap [Unite] f
nnoremap <silent> [Unite]re :<C-u>UniteResume<CR>
nnoremap <silent> [Unite]b  :<C-u>Unite -buffer-name=Buffers buffer:!<CR>
nnoremap <silent> [Unite]k  :<C-u>Unite -buffer-name=Bookmark bookmark -default-action=vimfiler<CR>
nnoremap <silent> [Unite]s  :<C-u>Unite -buffer-name=Files file_mru<CR>
nnoremap <silent> [Unite]d  :<C-u>Unite -buffer-name=Directory -default-action=tabopen directory directory_mru<CR>
nnoremap <silent> [Unite]f  :<C-u>Unite -buffer-name=Sources source<CR>
nnoremap <silent> [Unite]g  :<C-u>Unite -buffer-name=ag grep -keep-focus -no-quit<CR>
nnoremap <silent> [Unite]hc :<C-u>Unite -buffer-name=History history/command<CR>
nnoremap <silent> [Unite]hy :<C-u>Unite -buffer-name=History history/yank<CR>
nnoremap <silent> [Unite]hs :<C-u>Unite -buffer-name=History history/search<CR>
nnoremap <silent> [Unite]hl :<C-u>Unite -buffer-name=Help help<CR>
nnoremap <silent> [Unite]ma :<C-u>Unite -buffer-name=Mappings mapping<CR>
nnoremap <silent> [Unite]me :<C-u>Unite -buffer-name=Messages output:message<CR>
nnoremap <silent> [Unite]o  :<C-u>Unite -buffer-name=Outlines outline<CR>
nnoremap <silent> [Unite]l  :<C-u>Unite -buffer-name=Line line:all -no-quit<CR>
nnoremap <silent> [Unite]r  :<C-u>Unite -buffer-name=Ref/man ref/man<CR>
nnoremap <silent> [Unite]ta :<C-u>Unite -buffer-name=Tags tag tag/file<CR>
nnoremap <silent> [Unite]n  :<C-u>Unite -buffer-name=Snippet snippet<CR>
nnoremap <silent> [Unite]tb :<C-u>Unite -buffer-name=Tab tab<CR>
nnoremap <silent> [Unite]q  :<C-u>Unite -buffer-name=QuickFix quickfix -no-quit -direction=botright<CR>
nnoremap <silent> [Unite]a  :<C-u>Unite -buffer-name=Reanimate Reanimate<CR>
let g:unite_quickfix_is_multiline=0
function! s:config_unite()
    " コンバータに converter_quickfix_highlight を設定
    call unite#custom_source('quickfix', 'converters', 'converter_quickfix_highlight')
    call unite#custom_source('location_list', 'converters', 'converter_quickfix_highlight')
    imap <buffer> <TAB> <Plug>(unite_select_next_line)
    imap <buffer> jj <Plug>(unite_insert_leave)
    nmap <buffer> ' <Plug>(unite_quick_match_default_action)
    nmap <buffer> x <Plug>(unite_quick_match_choose_action)
    nnoremap <buffer><expr> l unite#smart_map('l', unite#do_action('default'))
    nnoremap <buffer><expr> t unite#do_action('tabopen')
endfunction

" neocomplete
let s:bundle = neobundle#get('neocomplete.vim')
function! s:bundle.hooks.on_source(bundle)
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#enable_auto_delimiter = 1
    let g:neocomplete#min_keyword_length = 3
    let g:neocomplete#enable_prefetch = 1
    let g:neocomplete#enable_auto_delimiter = 1
    let g:neocomplete#data_directory = expand('~/.vim/neocomplete')
    let g:neocomplete#skip_auto_completion_time = ''    "オムニ補完と相性が悪いかもしれない

    " 英単語補完用に以下のfiletypeをtextと同様に扱う
    if !exists('g:neocomplete#text_mode_filetypes')
        let g:neocomplete#text_mode_filetypes = {}
    endif
    let g:neocomplete#text_mode_filetypes.markdown = 1
    let g:neocomplete#text_mode_filetypes.gitcommit = 1
    let g:neocomplete#text_mode_filetypes.text = 1
    let g:neocomplete#text_mode_filetypes.txt = 1

    " 補完時に他のfiletypeの候補も参照する
    if !exists('g:neocomplete#same_filetypes')
        let g:neocomplete#same_filetypes = {}
    endif
    let g:neocomplete#same_filetypes._ = '_'

    if !exists('g:neocomplete#delimiter_patterns')
        let g:neocomplete#delimiter_patterns= {}
    endif
    let g:neocomplete#delimiter_patterns.vim = ['#', '.']
    let g:neocomplete#delimiter_patterns.cpp = [' ::', '.']
    let g:neocomplete#delimiter_patterns.c = ['.', '->']
    let g:neocomplete#delimiter_patterns.java = ['.']

    " 外部オムニ補完関数を直接呼び出す
    if !exists('g:neocomplete#force_omni_input_patterns')
        let g:neocomplete#force_omni_input_patterns = {}
    endif
    let g:neocomplete#force_overwrite_completefunc = 1
    let g:neocomplete#force_omni_input_patterns.java = '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplete#force_omni_input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
    let g:neocomplete#force_omni_input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
    let g:neocomplete#force_omni_input_patterns.objc = '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplete#force_omni_input_patterns.objcpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
    " 数字記号類以外の後に.か->が来た場合に補完実行する

    " syntaxファイル内での候補に使われる最小文字数
    let g:neocomplete#sources#syntax#min_keyword_length = 3

    " neocompleteが呼び出すオムニ補完関数名
    if !exists('g:neocomplete#sources#omni#functions')
        let g:neocomplete#sources#omni#functions = {}
    endif
    let g:neocomplete#sources#omni#functions.java = 'javaapi#complete'

    " オムニ補完関数呼び出し時の条件
    if !exists('g:neocomplete#sources#omni#input_patterns')
        let g:neocomplete#sources#omni#input_patterns = {}
    endif
    let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
    " let g:neocomplete#sources#omni#input_patterns.java = '[^.[:digit:] *\t]\.\%(\h\w*\)\?\|[a-zA-Z].*'

    if !exists('g:neocomplete#sources#vim#complete_functions')
        let g:neocomplete#sources#vim#complete_functions = {}
    endif
    let g:neocomplete#sources#vim#complete_functions.Ref = 'ref#complete'
    let g:neocomplete#sources#vim#complete_functions.Unite = 'unite#complete_source'
    let g:neocomplete#sources#vim#complete_functions.VimFiler = 'vimfiler#complete'
    let g:neocomplete#sources#vim#complete_functions.Vinarise = 'vinarise#complete'

    let g:neocomplete#lock_buffer_name_pattern = '^zsh.*'

    inoremap <expr> <C-l> neocomplete#complete_common_string()
    imap <C-q>  <Plug>(neocomplete_start_unite_quick_match)
endfunction

function! s:bundle.hooks.on_post_source(bundle)
    if &filetype =~? 'c\|cpp'
        NeoBundleSource vim-marching
    endif

    if has('ruby')
        NeoBundleSource alpaca_english
    else
        NeoBundleSource neco-look
    endif
endfunction
unlet s:bundle

function! s:check_clang()
    for t in ['clang-3.5', 'clang-3.4', 'clang']
        if executable(t)
            return t
        endif
    endfor

    echomsg 'Clang is NOT found.'
    return ''
endfunction

" marching
let s:bundle = neobundle#get('vim-marching')
function! s:bundle.hooks.on_source(bundle)
    let clang_exe = s:check_clang()
    if clang_exe == ''
        return
    endif

    " systemの戻り値に注意
    let g:marching_clang_command = substitute(system('where '.clang_exe), '[\r\|\n].*', '', 'g')
    let g:marching_clang_command_option = ''
    let g:marching_enable_neocomplete = 1
    let g:marching_debug = 1
    let g:marching_include_paths = split(&path, ',')
    let g:marching#clang_command#options = { 'cpp' : '-Wall -std=gnu++1y', 'c' : '-Wall -std=c11' }

    set updatetime=500
endfunction
unlet s:bundle

" snowdrop
let g:snowdrop#libclang_path = has('mac') ? '/Library/Developer/CommandLineTools/usr/lib' : '/usr/local/lib'
let g:snowdrop#command_options = { 'cpp' : '-std=c++1y', }

" clang-format
let s:bundle = neobundle#get('vim-clang-format')
function! s:bundle.hooks.on_source(bundle)
    let g:clang_format#style_options = {
                \ 'AccessModifierOffset' : -4,
                \ 'AlignTrailingComments' : 'true',
                \ 'AllowShortFunctionsOnASingleLine' : 'false',
                \ 'AllowShortIfStatementsOnASingleLine' : 'false',
                \ 'AllowShortLoopsOnASingleLine' : 'false',
                \ 'AlwaysBreakTemplateDeclarations' : 'true',
                \ 'BinPackParameters' : 'false',
                \ 'BreakBeforeBraces' : 'Attach',
                \ 'ColumnLimit' : '9999',
                \ 'MaxEmptyLinesToKeep' : '3',
                \ 'PointerBindsToType' : 'true',
                \ 'Standard' : "Auto"
                \ }

    for t in [ 'clang-format-3.5', 'clang-format-3.4', 'clang-format' ]
        if executable(t)
            let g:clang_format#command = t
            break
        endif
    endfor
endfunction
unlet s:bundle

" neosnippet
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
imap <C-l> <Plug>(neosnippet_start_unite_snippet)
set conceallevel=2 concealcursor=i
let g:neosnippet#snippets_directory = '~/.vim/bundle/neosnippet-snippets/neosnippets/,~/.vim/bundle/vim-snippets/snippets'

" easymotion
let g:EasyMotion_leader_key = '<Leader>e'

" NERDCommenter
let g:NERDSpaceDelims = 1
nmap <Leader><Leader> <Plug>NERDCommenterToggle
vmap <Leader><Leader> <Plug>NERDCommenterNested
nmap <Leader>cs <plug>NERDCommenterSexy
let s:bundle = neobundle#get('nerdcommenter')
function! s:bundle.hooks.on_post_source(bundle)
    doautocmd NERDCommenter BufEnter
endfunction
unlet s:bundle

" VimFiler
nnoremap <silent> fvs :VimFiler -explorer<CR>
nnoremap <silent> fvb :VimFilerBufferDir -explorer<CR>
nnoremap <silent> fvo :VimFilerTab -status<CR>
let g:vimfiler_data_directory = expand('~/.vim/vimfiler')
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_tree_closed_icon = '▸'
let g:vimfiler_tree_opened_icon = '▾'
let g:vimfiler_directory_display_top = 1
let g:vimfiler_preview_action = 'below'
let g:vimfiler_split_action = 'right'
let g:vimfiler_enable_auto_cd = 0
let g:vimfiler_force_overwrite_statusline = 0
function! s:config_vimfiler()
    nmap <buffer> : <Plug>(vimfiler_toggle_mark_current_line)
    nmap <buffer> <C-H> <Plug>(vimfiler_switch_to_parent_directory)
    vmap <buffer> : <Plug>(vimfiler_toggle_mark_selected_lines)
    nnoremap <silent><buffer><expr> <C-t> vimfiler#do_action('tabopen')
    nnoremap <silent><buffer><expr> <C-b> vimfiler#do_action('bookmark')
endfunction

" TagBar
let g:tagbar_width = 35
let g:tagbar_autoshowtag = 1
let g:tagbar_autofocus = 1
let g:tagbar_sort = 0
let g:tagbar_compact = 1
nnoremap <silent> tb :<C-U>TagbarToggle<CR>

" Ref-vim
let g:ref_open = 'split'
let g:ref_source_webdict_cmd = 'w3m -t 4 -cols 180 -dump %s'
let g:ref_source_webdict_sites = { 'Wikipedia:ja' : 'http://ja.wikipedia.org/wiki/%s', 'Weblio' : 'http://ejje.weblio.jp/content/%s', 'Weblio-Thesaurus' : 'http://ejje.weblio.jp/english-thesaurus/content/%s'}
let g:ref_source_webdict_sites.default = 'Wikipedia:ja'

" Smartinput
let s:bundle = neobundle#get('vim-smartinput')
function! s:bundle.hooks.on_source(bundle)
    call smartinput#map_to_trigger('i', '<Space>', '<Space>', '<Space>')
    call smartinput#define_rule({ 'char' : '<Space>', 'at' : '(\%#)', 'input' : '<Space><Space><Left>'})

    let lst = [   ['<',     "smartchr#loop(' < ', ' << ', '<')" ],
                \ ['>',     "smartchr#loop(' > ', ' >> ', ' >>> ', '>')"],
                \ ['+',     "smartchr#loop(' + ', '++', '+')"],
                \ ['-',     "smartchr#loop(' - ', '--', '-')"],
                \ ['/',     "smartchr#loop(' / ', '//', '/')"],
                \ ['&',     "smartchr#loop(' & ', ' && ', '&')"],
                \ ['%',     "smartchr#loop(' % ', '%')"],
                \ ['*',     "smartchr#loop(' * ', '*')"],
                \ ['<Bar>', "smartchr#loop(' | ', ' || ', '|')"],
                \ [',',     "smartchr#loop(', ', ',')"]]

    for i in lst
        call smartinput#map_to_trigger('i', i[0], i[0], i[0])
        call smartinput#define_rule({ 'char' : i[0], 'at' : '\%#',                                      'input' : '<C-R>=' . i[1] . '<CR>'})
        if i[0] == '%'
            call smartinput#define_rule({'char' : i[0], 'at' : '^\([^"]*"[^"]*"\)*[^"]*"[^"]*\%#',          'input' : i[0]})
        endif
        call smartinput#define_rule({ 'char' : i[0], 'at' : '^\([^'']*''[^'']*''\)*[^'']*''[^'']*\%#',  'input' : i[0] })
    endfor

    call smartinput#define_rule({'char' : '>', 'at' : ' < \%#', 'input' : '<BS><BS><BS><><Left>'})

    call smartinput#map_to_trigger('i', '=', '=', '=')
    call smartinput#define_rule({ 'char' : '=', 'at' : '\%#',                                       'input' : "<C-R>=smartchr#loop(' = ', ' == ', '=')<CR>"})
    call smartinput#define_rule({ 'char' : '=', 'at' : '[&+-/<>|] \%#',                             'input' : '<BS>= '})
    call smartinput#define_rule({ 'char' : '=', 'at' : '!\%#',                                      'input' : '= '})
    " call smartinput#define_rule({ 'char' : '=', 'at' : '^\([^"]*"[^"]*"\)*[^"]*"[^"]*\%#',          'input' : '='})
    call smartinput#define_rule({ 'char' : '=', 'at' : '^\([^'']*''[^'']*''\)*[^'']*''[^'']*\%#',   'input' : '='})

    call smartinput#map_to_trigger('i', '<BS>', '<BS>', '<BS>')
    call smartinput#define_rule({ 'char' : '<BS>' , 'at' : '(\s*)\%#'   , 'input' : '<C-O>dF(<BS>'})
    call smartinput#define_rule({ 'char' : '<BS>' , 'at' : '{\s*}\%#'   , 'input' : '<C-O>dF{<BS>'})
    call smartinput#define_rule({ 'char' : '<BS>' , 'at' : '<\s*>\%#'   , 'input' : '<C-O>dF<<BS>'})
    call smartinput#define_rule({ 'char' : '<BS>' , 'at' : '\[\s*\]\%#' , 'input' : '<C-O>dF[<BS>'})

    for op in ['<', '>', '+', '-', '/', '&', '%', '\*', '|']
        call smartinput#define_rule({ 'char' : '<BS>' , 'at' : ' ' . op . ' \%#' , 'input' : '<BS><BS><BS>'})
    endfor

    call smartinput#map_to_trigger('i', '*', '*', '*')
    call smartinput#define_rule({ 'char' : '*', 'at' : 'defparameter \*\%#', 'input' : '*<Left>', 'filetype' : [ 'lisp' ]})
endfunction
unlet s:bundle

" Smartchr
let s:bundle = neobundle#get('vim-smartchr')
function! s:bundle.hooks.on_source(bundle)
    inoremap <expr> , smartchr#one_of(', ', '->', ' => ')

    if &filetype ==? 'lisp'
        inoremap <expr> ; smartchr#loop('; ', ';')
    endif
endfunction
unlet s:bundle

" QuickRun FIXME
let g:quickrun_config = {}
let g:quickrun_config._ = { 'outputter' : 'quickfix', 'outputter/buffer/split' : ' :vertical rightbelow', 'runner' : 'vimproc' }
let g:quickrun_config.lisp = { 'command' : 'clisp', 'exec' : '%c < %s:p' }
let g:quickrun_config.make = { 'command' : "make",  'exec' : '%c %o', 'runner' : 'vimproc', "outputter/quickfix/open_cmd" : "", "hook/unite_quickfix/enable_exit" : 1, "hook/unite_quickfix/enable_failure" : 1}

" Conque
let g:ConqueTerm_ReadUnfocused = 1
let g:ConqueTerm_CloseOnEnd = 1
let g:ConqueTerm_StartMessages = 0
let g:ConqueTerm_CWInsert = 0
let g:ConqueTerm_EscKey = '<C-K>'
noremap <silent> <Leader>sh :ConqueTermVSplit <C-R>=$SHELL<CR><CR>

" learn-vimscript
nnoremap <Leader>lv :help learn-vimscript.txt<CR> <C-W>L

" SuddenDeath
map <Leader>x <Plug>(operator-suddendeath)

" Open-Browser
map <Leader>op <Plug>(openbrowser-open)

" operator-replace
map _ <Plug>(operator-replace)

" operator-surround
nmap <silent> zs <Plug>(operator-surround-append)
omap <silent> zs <Plug>(operator-surround-append)
nmap <silent> zd <Plug>(operator-surround-delete)
omap <silent> zd <Plug>(operator-surround-delete)
nmap <silent> zr <Plug>(operator-surround-replace)
omap <silent> zr <Plug>(operator-surround-replace)
nmap <silent> zss <Plug>(operator-surround-append)<Plug>(textobj-block-i)
nmap <silent> zdd <Plug>(operator-surround-delete)<Plug>(textobj-block-a)
nmap <silent> zrr <Plug>(operator-surround-replace)<Plug>(textobj-block-a)

" operator-reverse
nmap <silent> <Leader>re <Plug>(operator-reverse-text)

" vim-expand-region
vmap K <Plug>(expand_region_expand)
vmap J <Plug>(expand_region_shrink)

" textobj-wiw
let g:textobj_wiw_no_default_key_mappings = 0
map mw <Plug>(textobj-wiw-n)
map mb <Plug>(textobj-wiw-p)
map me <Plug>(textobj-wiw-N)
map mge <Plug>(textobj-wiw-P)

" textobj-line
omap il <Plug>(textobj-line-i)
omap al <Plug>(textobj-line-a)
vmap il <Plug>(textobj-line-i)
vmap al <Plug>(textobj-line-a)

" textobj-multiblock
let g:textobj_multiblock_blocks = [ ['(', ')'], ['[', ']'], ['{', '}'], ['<', '>'], ['"', '"'], ["'", "'"], ['\_^\s*\<function\>.*', '\_^\s*endfunction\_$'], ['\_^\s*\<if\>.*', '\_^\s*\<endif\>\s*\_$'], ]

" textobj-parameter
omap i, <Plug>(textobj-parameter-i)
omap a, <Plug>(textobj-parameter-a)

" textobj-multitextobj
let g:textobj_multitextobj_textobjects_group_i = {
            \   "A" : [
            \       "\<Plug>(textobj-wiw-i)",
            \       "iw",
            \    ],
            \   "B" : [
            \       "it",
            \       "\<Plug>(textobj-multiblock-i)",
            \    ],
            \}
let g:textobj_multitextobj_textobjects_group_a = {
            \   "A" : [
            \       "\<Plug>(textobj-wiw-a)",
            \       "aw",
            \    ],
            \   "B" : [
            \       "at",
            \       "\<Plug>(textobj-multiblock-a)",
            \    ],
            \}
omap <Plug>(textobj-word-i)  <Plug>(textobj-multitextobj-A-i)
omap <Plug>(textobj-word-a)  <Plug>(textobj-multitextobj-A-a)
omap <Plug>(textobj-block-i) <Plug>(textobj-multitextobj-B-i)
omap <Plug>(textobj-block-a) <Plug>(textobj-multitextobj-B-a)
vmap <Plug>(textobj-word-i)  <Plug>(textobj-multitextobj-A-i)
vmap <Plug>(textobj-word-a)  <Plug>(textobj-multitextobj-A-a)
vmap <Plug>(textobj-block-i) <Plug>(textobj-multitextobj-B-i)
vmap <Plug>(textobj-block-a) <Plug>(textobj-multitextobj-B-a)
omap iw <Plug>(textobj-word-i)
omap aw <Plug>(textobj-word-a)
omap ib <Plug>(textobj-block-i)
omap ab <Plug>(textobj-block-a)
vmap iw <Plug>(textobj-word-i)
vmap aw <Plug>(textobj-word-a)
vmap ib <Plug>(textobj-block-i)
vmap ab <Plug>(textobj-block-a)

" Thumbnail
nnoremap <silent> <Leader>th :Thumbnail<CR>

" Alpaca_english
if has('ruby')
    let g:alpaca_english_enable = 1
endif

" Gist
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1

" Reanimate
let g:reanimate_save_dir = expand('~/.vim/reanimate')
noremap [rr :ReanimateSave <CR>
noremap ]rr :ReanimateLoad <CR>
noremap [rn :ReanimateSave <C-R>%<CR>
noremap ]rn :ReanimateLoad <C-R>%<CR>

" VimConsole
let g:vimconsole#auto_redraw = 1

" syntastic
let g:syntastic_mode_map = { 'mode' : 'passive' }
let g:syntastic_c_compiler_options = '-std=c11 -Wall -Wextra -Wpadded -Winit-self -Wconversion -Wno-unused-parameter -Wwrite-strings -Wno-sign-compare -Wno-pointer-sign -Wno-missing-field-initializers -Wcast-qual -Wformat=2 -Wstrict-aliasing=2 -Wdisabled-optimization -Wfloat-equal -Wpointer-arith -Wbad-function-cast -Wcast-align -Wredundant-decls -Winline'
let g:syntastic_cpp_compiler_options = '-std=c++11 -stdlib=libc++ -Wall -Wextra -Wpadded -Winit-self -Wconversion -Wno-unused-parameter -Wwrite-strings -Wno-sign-compare -Wno-pointer-sign -Wno-missing-field-initializers -Wcast-qual -Wformat=2 -Wstrict-aliasing=2 -Wdisabled-optimization -Wfloat-equal -Wpointer-arith -Wbad-function-cast -Wcast-align -Wredundant-decls -Winline'
let g:syntastic_loc_list_height = 5

" rainbow parenthesis
let g:rainbow_active = 1
let g:rainbow_conf = {
            \   'guifgs' : [ '#666666', '#0087ff', '#ff005f', '#875fd7', '#d78700', '#00af87', ],
            \   'ctermfgs': [ '242', '33', '197', '98', '172', '36', ],
            \   'separately' : { '*': {}, 'vim' : {} },
            \   }

" anzu
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)

" Dictionary.vim
nnoremap <silent> <Leader>dr :<C-u>Dictionary -cursor-word<CR>

" OpenVimrc
nmap <silent> <Leader>ev <Plug>(openvimrc-open)

" yankround
let g:yankround_dir = '~/.vim/yankround'
nmap p <Plug>(yankround-p)
nmap P <Plug>(yankround-P)
nmap <C-p> <Plug>(yankround-prev)
nmap <C-n> <Plug>(yankround-next)

" LayoutPlugin
let g:layoutplugin#is_append_vimrc = 1

" small
map <Leader>sm <Plug>(smalls)

" sonictemplate
let g:sonictemplate_key = '<C-G>s'
let g:sonictemplate_intelligent_key = '<C-G>i'

" fugitive
let s:bundle = neobundle#get('vim-fugitive')
function! s:bundle.hooks.on_post_source(bundle)
    doautoall fugitive BufNewFile
endfunction
unlet s:bundle

" blockit
vmap <Leader>tt <Plug>BlockitVisual

" lightline
let g:lightline = {
            \ 'enable'      : { 'tabline' : 0 },
            \ 'colorscheme' : 'mopkai',
            \ 'active' : {
            \   'left'  : [ [ 'mode', 'paste' ], [ 'fugitive' ], [ 'filename', 'modified' ], [ 'readonly' ], [ 'buflist' ] ],
            \   'right' : [ [ 'syntastic', 'fileencoding', 'fileformat', 'lineinfo', 'percent' ], [ 'filetype' ] ,[ 'tagbar' ] ],
            \ },
            \ 'inactive' : {
            \   'left'  : [ [ 'filename' ] ],
            \   'right' : [ [ 'percent' ], [ 'filetype' ] ]
            \ },
            \ 'separator'       : { 'left' : '',  'right' : ''  },
            \ 'subseparator'    : { 'left' : '|', 'right' : '|' },
            \ 'component' : {
            \   'lineinfo'      : "%{ &filetype =~? 'vimfiler\\|tagbar\\|unite' ? '' : printf('%03d:%03d', line('.'), col('.')) }",
            \   'percent'       : "%{ &filetype =~? 'vimfiler\\|tagbar\\|unite' ? '' : printf('%3d%%', float2nr((1.0 * line('.')) / line('$') * 100.0)) }",
            \   'fileformat'    : "%{ &filetype =~? 'vimfiler\\|tagbar\\|unite' || winwidth(0) < 60 ? '' : &fileformat }",
            \   'filetype'      : "%{ &filetype =~? 'vimfiler\\|tagbar\\|unite' || winwidth(0) < 60 ? '' : &filetype }",
            \   'fileencoding'  : "%{ &filetype =~? 'vimfiler\\|tagbar\\|unite' || winwidth(0) < 60 ? '' : (strlen(&fenc) ? &fenc : &enc) }",
            \   'paste'         : "%{ &modifiable && &paste ? 'Paste' : '' }",
            \   'readonly'      : "%{ &readonly ? 'RO' : '' }",
            \   'tagbar'        : "%{ exists('*tagbar#currenttag') ? tagbar#currenttag('%s','', 'f') : '' }",
            \ },
            \ 'component_function' : {
            \   'mode'          : 'Mline_mode',
            \   'modified'      : 'Mline_modified',
            \   'filename'      : 'Mline_filename',
            \   'fugitive'      : 'Mline_fugitive',
            \   'buflist'       : 'Mline_bufhist',
            \ },
            \ 'component_expand'    : { 'syntastic' : 'SyntasticStatuslineFlag', },
            \ 'component_type'      : { 'syntastic' : 'error', },
            \ }

let s:p = { 'normal': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'inactive': {}, }
let s:cp = {
            \ 'fg'      : [ '#9e9e9e', 247 ], 'glay'    : [ '#303030', 236 ],
            \ 'dark'    : [ '#0E1119', 232 ], 'light'   : [ '#e4e4e4', 254 ],
            \ 'purple'  : [ '#875fd7',  98 ], 'blue'    : [ '#00afff',  39 ],
            \ 'orange'  : [ '#d75f00', 166 ], 'red'     : [ '#ff0000', 196 ],
            \ }
let s:pa = { 'base_glay' : [ s:cp.fg, s:cp.glay ], 'base_dark' : [ s:cp.fg, s:cp.dark ], 'base_deep' : [ s:cp.fg, [ '#2e2930', 235 ] ], }
let s:p.normal.left     = [ [ s:cp.dark, s:cp.blue ], [ s:cp.orange, s:cp.dark ], s:pa.base_dark, [ s:cp.red, s:cp.dark ] ]
let s:p.normal.middle   = [ s:pa.base_glay ]
let s:p.normal.right    = [ s:pa.base_deep, [ s:cp.purple, s:cp.dark ], [ s:cp.dark, [ '#201C26', 68 ] ] ]
let s:p.insert.left     = [ [ s:cp.dark, [ '#87ff00', 118 ] ], s:p.normal.left[1], s:p.normal.left[2], s:p.normal.left[3] ]
let s:p.replace.left    = [ [ s:cp.dark, [ '#ff0087', 198 ] ], s:p.normal.left[1], s:p.normal.left[2], s:p.normal.left[3] ]
let s:p.visual.left     = [ [ s:cp.dark, [ '#d7ff5f', 191 ] ], s:p.normal.left[1], s:p.normal.left[2], s:p.normal.left[3] ]
let s:p.inactive.left   = [ [ [ '#4e4e4e', 239 ], s:cp.dark ] ]
let s:p.inactive.middle = [ [ s:cp.fg, [ '#000000',  16 ] ] ]
let s:p.inactive.right  = [ s:pa.base_dark, [ s:cp.purple, s:cp.dark ] ]
let s:p.normal.error    = [ [ s:cp.dark, s:cp.red ] ]
let s:p.normal.warning  = [ [ s:cp.dark, [ '#ffd700', 220 ] ] ]
let g:lightline#colorscheme#mopkai#palette = lightline#colorscheme#flatten(s:p)
unlet s:pa s:cp s:p

function! Mline_mode()
    if &filetype == 'unite'
        return 'Unite'
    elseif &filetype == 'vimfiler'
        return winwidth(0) <= 35 ?  '' : 'VimFiler'
    elseif &filetype == 'tagbar'
        return 'Tagbar'
    else
        return lightline#mode()
    endif
endfunction

function! Mline_modified()
    if &filetype == 'unite' || !&modifiable
        return ''
    endif
    return &modified ? '[+]' : '[-]'
endfunction

function! Mline_filename()
    if &filetype == 'unite'
        return unite#get_status_string()
    elseif &filetype == 'vimfiler'
        if winwidth(0) <= 20
            return ''
        endif
        return vimfiler#get_status_string()
    elseif &filetype == 'tagbar'
        return g:lightline.fname
    endif
    return '' != expand('%:t') ? expand('%:t') : '[No Name]'
endfunction

function! Mline_fugitive()
    if &modifiable && &filetype !~? 'unite\|vimfiler' && exists('*fugitive#head')
        let t = fugitive#head()
        return (t != '') ? ('⎇  ' . t) : ''
    endif
    return ''
endfunction

let g:mline_bufhist_queue = []
let g:mline_bufhist_limit = 4
let g:mline_bufhist_exclution_pat = '^$\|.jax$\|vimfiler:\|\[unite\]\|tagbar'
let g:mline_bufhist_enable = 1
command! Btoggle :let g:mline_bufhist_enable = g:mline_bufhist_enable ? 0 : 1 | :redrawstatus!

function! Mline_bufhist()
    if &filetype =~? 'unite\|vimfiler\|tagbar' || !&modifiable || len(g:mline_bufhist_queue) == 0 || g:mline_bufhist_enable == 0
        return ''
    endif

    let current_buf_nr = bufnr('%')
    let buf_names_str = ''
    let last = g:mline_bufhist_queue[-1]
    for i in g:mline_bufhist_queue
        let t = fnamemodify(i, ':t')
        let n = bufnr(t)

        if n != current_buf_nr
            let buf_names_str .= printf('[%d]:%s' . (i == last ? '' : ' | '), n, t)
        endif
    endfor

    return buf_names_str
endfunction

function! s:update_recent_buflist(file)
    if a:file =~? g:mline_bufhist_exclution_pat
        " exclusion from queue
        return
    endif

    if len(g:mline_bufhist_queue) == 0
        " init
        for i in range(min( [ bufnr('$'), g:mline_bufhist_limit + 1 ] ))
            let t = bufname(i)
            if bufexists(i) && t !~? g:mline_bufhist_exclution_pat
                call add(g:mline_bufhist_queue, fnamemodify(t, ':p'))
            endif
        endfor
    endif

    " update exist buffer
    let idx = index(g:mline_bufhist_queue, a:file)
    if 0 <= idx
        call remove(g:mline_bufhist_queue, idx)
    endif

    call insert(g:mline_bufhist_queue, a:file)

    if g:mline_bufhist_limit + 1 < len(g:mline_bufhist_queue)
        call remove(g:mline_bufhist_queue, -1)
    endif
endfunction

function! g:tagbar_status_func(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
    return lightline#statusline(0)
endfunction
let g:tagbar_status_func = 'g:tagbar_status_func'

" next-alter
nmap <Leader>an <Plug>(next-alter-open)
let g:next_alter#search_dir = [ './include', '.' , '..', '../include' ]
" let g:next_alter#open_option = 'vertical topleft'

" mopkai
let g:mopkai_is_not_set_normal_ctermbg = !has('mac')

" minibufexpl
let g:miniBufExplBRSplit = 1
let g:miniBufExplorerAutoStart = 0


"-------------------------------------------------------------------------------"
" autocmd
"-------------------------------------------------------------------------------"

" Conque
function! s:delete_conque_term(buffer_name)
    let term_obj = conque_term#get_instance(a:buffer_name)
    call term_obj.close()
endfunction

" Lisp
function! s:config_lisp()
    setlocal nocindent
    setlocal nosmartindent
    setlocal lisp
    setlocal lispwords=define
endfunction

" for lightline
function! s:update_syntastic()
    if !exists(':SyntasticCheck')
        NeoBundleSource syntastic
    endif
    SyntasticCheck
    call lightline#update()
endfunction

augroup general
    autocmd!

    " .vimrc
    autocmd BufWritePost $MYVIMRC nested source $MYVIMRC

    " 挿入モード解除時に自動でpasteをoff
    autocmd InsertLeave * setlocal nopaste

    " 状態の保存と復元
    autocmd BufWinLeave ?* if (bufname('%') != '') | silent mkview!  | endif
    autocmd BufWinEnter ?* if (bufname('%') != '') | silent loadview | endif

    " Conque
    autocmd BufWinLeave zsh* call s:delete_conque_term(expand('%'))

    " git
    autocmd FileType git setlocal foldlevel=99

    " VimFiler
    autocmd FileType vimfiler call s:config_vimfiler()

    " Unite
    autocmd FileType unite call s:config_unite()

    " Lisp
    autocmd FileType lisp call s:config_lisp()

    " nask
    autocmd BufWinEnter *.nas nested setlocal filetype=nasm

    " json
    autocmd BufWinEnter *.json nested setlocal filetype=json

    " Arduino
    autocmd BufWinEnter *.pde,*.ino nested setlocal filetype=arduino

    " markdown
    autocmd BufWinEnter *.{md,mdwn,mkd,mkdn,mark*} nested setlocal filetype=markdown

    " Java
    autocmd CompleteDone *.java call javaapi#showRef()

    " for lightline
    autocmd BufWritePost * call s:update_syntastic()
    autocmd TabEnter,BufWinEnter * call s:update_recent_buflist(expand('<amatch>'))
augroup END

syntax enable           " 強調表示有効
colorscheme mopkai      " syntaxコマンドよりもあとにすること
