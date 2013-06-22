"---------------------------------------------------------------------------------------"
" Vimrc By mopp
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
set cindent
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
let &path = '.,' . substitute($PATH, ';', ',', 'g')

" 折りたたみ
set foldenable
set foldcolumn=3            " 左側に折りたたみガイド表示$
set foldmethod=indent       " 折畳の判別
set foldtext=g:ToFoldFunc() " 折りたたみ時の表示設定
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
let g:loaded_netrwPlugin = 1    " 標準Pluginを読み込まない
let g:loaded_tar = 1
let g:loaded_tarPlugin= 1
let g:loaded_vimballPlugin = 1
let g:loaded_zip = 1
let g:loaded_zipPlugin = 1

" 外観設定
" set ambiwidth=double    " マルチバイト文字や記号でずれないようにする
set cmdheight=2         " コマンドラインの行数
set cursorline          " 現在行に下線表示
set laststatus=2        " ステータスラインを表示する時
set list
set listchars=eol:$,tab:>\ ,trail:\|,extends:<,precedes:<
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
" 折り畳み時表示テキスト設定用関数
function! g:ToFoldFunc()
    " 折りたたみ開始行取得
    let line = getline(v:foldstart)

    " 行頭の空白数計算 - 空白で分割→先頭の一致部分を検索しインデックスをheadSpNumに設定
    let headSpNum = stridx(line, split(line, ' ')[0])

    " 行頭の空白を置換
    if (headSpNum == 1)
        let line = substitute(line, '\ ', '-', '')
    elseif (1 < headSpNum)
        let line = substitute(line, '\ ', '+', '')

        " 区切りとして空白を2つ残す
        let i = 2
        while (i < headSpNum)
            let line = substitute(line, '\ ', '-', '')
            let i += 1
        endwhile
    endif

    return printf('[ %2d Lines Lv%02d ] %s %s %s', (v:foldend-v:foldstart+1), v:foldlevel, line, v:folddashes, v:folddashes)
endfunction


"-----------------------------------------------------------------------------------"
" Mapping                                                                           |
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
if has('mac') && !has('gui_running')
    for i in map( range(char2nr('a'), char2nr('z')) + range(char2nr('A'), char2nr('Z')) + range(char2nr('0'), char2nr('9')) , 'nr2char(v:val)')
        execute 'set <M-'.i.'>='.i
    endfor

    map <NUL> <C-Space>
    map! <NUL> <C-Space>
    map <C-Space> "*yy
endif

" <Leader>を変更
let g:mapleader = ' '

" 矯正
inoremap <BS> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>

" 移動系
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
noremap <silent> <F2> :<C-U>bprevious<CR>
noremap <silent> <F3> :<C-U>bnext<CR>

" Tab操作
noremap <Leader>to :tabnew<Space>
noremap <M-h> gT
noremap <M-l> gt

" 画面分割
noremap <Leader>sp :split<Space>
noremap <Leader>vsp :vsplit<Space>

" エラーリスト移動
nnoremap <silent> [o :cprevious<CR>
nnoremap <silent> ]o :cnext<CR>
nnoremap <silent> [O :<C-u>cfirst<CR>
nnoremap <silent> ]O :<C-u>clast<CR>

" Windowサイズ変更
noremap <silent> <S-Left> :<C-U>wincmd <<CR>
noremap <silent> <S-Right> :<C-U>wincmd ><CR>
noremap <silent> <S-Up> :<C-U>wincmd -<CR>
noremap <silent> <S-Down> :<C-U>wincmd +<CR>

" 検索とジャンプで中央へ
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap '. '.zz
nnoremap '' ''zz

" Yand & Paste
nnoremap Y y$
nnoremap <silent> <Leader>pp :set paste!<CR>

" 入れ替え
noremap ; :
noremap : ;

" カーソル下のwordをhelpする
" nnoremap <silent> <Leader>h :vertical aboveleft help <C-R><C-W><CR>
nnoremap <silent> <Leader>h :help <C-R><C-W><CR>

" .vimrcを開く
nnoremap <silent> <Leader>ev :tabnew $MYVIMRC<CR>

" カレントウィンドウのカレントディレクトリを変更
nnoremap <Leader>cd :lcd %:p:h<CR>

" 検索ハイライト消去
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

" 空行を追加
nnoremap <silent> <CR> :<C-u>for i in range(1, v:count1) \| call append(line('.'),   '') \| endfor \| silent! call repeat#set("<CR>", v:count1)<CR>
" nnoremap <silent> <Leader>O   :<C-u>for i in range(1, v:count1) \| call append(line('.')-1, '') \| endfor \| silent! call repeat#set("<Space>O", v:count1)<CR>

" Tagが複数あればリスト表示
nnoremap <C-]> g<C-]>zz

" バッファの一覧と選択
nnoremap <Leader>b :ls<CR>:b

command! -nargs=0 Nyaruko call append(line('.'), '（」・ω・）」うー！（／・ω・）／にゃー！')
command! -nargs=0 Mload source %


"-----------------------------------------------------------------------------------"
" 環境依存設定                                                                      |
"-----------------------------------------------------------------------------------"
" Macのみの設定
if has('mac')
    " Mac の辞書.appで開く from http://qiita.com/items/6928282c5c843aad81d4
    " 引数に渡したワードを検索
    command! -nargs=1 MacDict      call system('open '.shellescape('dict://'.<q-args>))
    " カーソル下のワードを検索
    command! -nargs=0 MacDictCWord call system('open '.shellescape('dict://'.shellescape(expand('<cword>'))))
    " 辞書.app を閉じる
    command! -nargs=0 MacDictClose call system("osascript -e 'tell application \"Dictionary\" to quit'")
    " 辞書にフォーカスを当てる
    command! -nargs=0 MacDictFocus call system("osascript -e 'tell application \"Dictionary\" to activate'")
    " キーマッピング
    nnoremap <silent> <Leader>do :<C-u>MacDictCWord<CR>
    vnoremap <silent> <Leader>doy :<C-u>MacDict<Space><C-r>*<CR>
    nnoremap <silent> <Leader>dc :<C-u>MacDictClose<CR>
    nnoremap <silent> <Leader>df :<C-u>MacDictFocus<CR>
endif


"-------------------------------------------------------------------------------"
" Developing
"-------------------------------------------------------------------------------"
function! g:nyaruline_after_init_hook(controler)
    " let g:vimfiler_force_overwrite_statusline = 0
    " call a:controler.default.n.add_atom(-1, '%{exists("g:loaded_vimfiler")?vimfiler#get_status_string():""}',  'NYARU_VIMF_N', a:controler.get_highlight_param('164a84', 'c1d8ac', 'NONE'), 'left')

    " echo 'call hook'
    " echo a:controler.default.n.get_statusline_expr()
endfunction

" set runtimepath+=~/Dropbox/Program/Vim/Pastel
" set runtimepath+=~/Dropbox/Program/Vim/unite-battle_editors
" set runtimepath+=~/Dropbox/Program/Vim/unite-rss
" set runtimepath+=~/Dropbox/Program/Vim/rogue.vim
set runtimepath+=~/Dropbox/Program/Vim/nyaruline.vim
set runtimepath+=~/Dropbox/Program/Vim/AOJ.vim
" set runtimepath+=~/Dropbox/Program/Vim/jumper.vim


"-------------------------------------------------------------------------------"
" Plugin
"-------------------------------------------------------------------------------"
" neobundleが存在しない場合これ以降を読み込まない
if !isdirectory(expand('~/.vim/bundle/neobundle.vim'))
    finish
endif

" NeoBundle
if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim
else
    call neobundle#call_hook('on_source')
endif
call neobundle#rc()

NeoBundleFetch 'Shougo/neobundle.vim'

let g:neobundle#default_options = { 'loadInsert' : { 'autoload' : { 'insert' : '1' } } }

NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'Shougo/context_filetype.vim'
NeoBundle 'Shougo/vimproc.vim' ,{ 'build' : { 'mac' : 'make -f make_mac.mak', 'unix' : 'make -f make_unix.mak' } }
NeoBundle 'kana/vim-niceblock'
NeoBundle 'kana/vim-textobj-indent'
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'osyo-manga/vim-textobj-multiblock'
NeoBundle 'rbtnn/vimconsole.vim'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'thinca/vim-ref'
NeoBundle 'thinca/vim-visualstar'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-surround'
NeoBundle 'vim-jp/vimdoc-ja'
NeoBundleLazy 'Rip-Rip/clang_complete', { 'build' : { 'mac' : 'make install' } }
NeoBundleLazy 'Shougo/neocomplete.vim', '', 'loadInsert'
NeoBundleLazy 'Shougo/neosnippet', '', 'loadInsert'
NeoBundleLazy 'Shougo/vimfiler', { 'depends' : 'Shougo/unite.vim', 'autoload' : { 'commands' : [ 'VimFiler', 'VimFilerTab', 'VimFilerExplorer',], 'explorer' : 1,} }
NeoBundleLazy 'Shougo/vinarise', { 'autoload' : { 'commands' : 'Vinarise'} }
NeoBundleLazy 'deton/jasegment.vim', { 'autoload' : { 'function_prefix' : 'jasegment' } }
NeoBundleLazy 'elzr/vim-json', { 'autoload' : { 'filetypes' : 'json' } }
NeoBundleLazy 'gregsexton/gitv', { 'depends' : 'tpope/vim-fugitive', 'autoload' : {'commands' : 'Gitv'} }
NeoBundleLazy 'itchyny/thumbnail.vim', { 'autoload' : {'commands' : 'Thumbnail'} }
NeoBundleLazy 'kana/vim-operator-replace', { 'autoload' : { 'mappings'  : ['<Plug>(operator-replace)'] } }
NeoBundleLazy 'kana/vim-operator-user', { 'autoload' : { 'function_prefix' : 'operator' } }
NeoBundleLazy 'kana/vim-smartchr', '', 'loadInsert'
NeoBundleLazy 'kana/vim-smartinput', '', 'loadInsert'
NeoBundleLazy 'kannokanno/previm', { 'autoload' : { 'filetypes' : 'markdown' } }
NeoBundleLazy 'majutsushi/tagbar', { 'autoload' : { 'commands'  : 'TagbarToggle' } }
NeoBundleLazy 'mattn/benchvimrc-vim', { 'autoload' : {'commands' : 'BenchVimrc'} }
NeoBundleLazy 'mattn/gist-vim', { 'autoload' : {'commands' : 'Gist'} }
NeoBundleLazy 'mattn/learn-vimscript', { 'autoload' : { 'mappings'  : ['<Leader>lv'] } }
NeoBundleLazy 'plasticboy/vim-markdown', { 'autoload' : { 'filetypes' : 'markdown' } }
NeoBundleLazy 'rosenfeld/conque-term', { 'autoload' : { 'commands'  : ['ConqueTerm', 'ConqueTermSplit', 'ConqueTermTab', 'ConqueTermVSplit'] } }
NeoBundleLazy 'scrooloose/syntastic', '', 'loadInsert'
NeoBundleLazy 'taichouchou2/alpaca_english', { 'build' : { 'mac' : 'bundle', }, 'autoload' : { 'insert' : '1', 'unite_sources': ['english_dictionary', 'english_example', 'english_thesaurus'], } }
NeoBundleLazy 'thinca/vim-ft-help_fold', { 'autoload' : {'commands' : 'help'} }
NeoBundleLazy 'thinca/vim-painter'
NeoBundleLazy 'thinca/vim-scouter'
NeoBundleLazy 'thinca/vim-showtime'
NeoBundleLazy 'uguu-org/vim-matrix-screensaver', { 'autoload' : {'commands' : 'Matrix'} }
NeoBundleLazy 'ujihisa/neco-look', '', 'loadInsert'
NeoBundleLazy 'vim-jp/cpp-vim'
NeoBundleLazy 'vim-scripts/Arduino-syntax-file', { 'autoload' : { 'filetypes' : 'arduino' } }
NeoBundleLazy 'wesleyche/SrcExpl', { 'autoload' : { 'commands' : ['SrcExplToggle', 'SrcExpl', 'SrcExplClose'] } }
NeoBundleLazy 'yomi322/vim-operator-suddendeath', { 'depends' : 'kana/vim-operator-user', 'autoload' : {'mappings' : '<Plug>(operator-suddendeath)'} }
NeoBundleLazy 'yuratomo/gmail.vim', { 'autoload' : {'commands' : 'Gmail'} }
NeoBundleLazy 'yuratomo/java-api-complete', { 'autoload' : { 'filetypes' : 'java' } }
NeoBundleLazy 'yuratomo/w3m.vim', { 'autoload' : {'commands' : 'W3m'} }

NeoBundleLazy 'Shougo/unite.vim', { 'autoload' : { 'commands' : 'Unite', 'function_prefix' : 'unite' }}
NeoBundleLazy 'Shougo/unite-help', { 'autoload' : { 'unite_sources' : ['help'],} }
NeoBundleLazy 'Shougo/unite-outline', { 'autoload' : { 'unite_sources' : ['outline'],} }
NeoBundleLazy 'Shougo/unite-ssh', { 'autoload' : { 'unite_sources' : ['ssh'],} }
NeoBundleLazy 'sgur/unite-qf', { 'autoload' : { 'unite_sources' : ['qf'],} }
NeoBundleLazy 'thinca/vim-unite-history', { 'autoload' : { 'unite_sources' : ['history/command', 'history/yank', 'history/search'],} }
NeoBundleLazy 'tsukkee/unite-tag', { 'autoload' : { 'unite_sources' : ['tag'],} }
NeoBundleLazy 'osyo-manga/vim-reanimate', { 'autoload' : { 'unite_sources' : ['Reanimate'], 'commands' : ['ReanimateLoad', 'ReanimateSave']} }

NeoBundleLazy 'basyura/TweetVim', { 'depends' : ['basyura/twibill.vim', 'tyru/open-browser.vim'], 'autoload' : { 'commands' : ['TweetVimHomeTimeline', 'TweetVimUserStream'], 'unite_sources' : ['tweetvim'],} }
NeoBundleLazy 'basyura/twibill.vim', { 'depends' : 'tyru/open-browser.vim'}
NeoBundleLazy 'mattn/excitetranslate-vim', { 'depends' : 'mattn/webapi-vim', 'autoload' : { 'commands' : 'ExciteTranslate' } }
NeoBundleLazy 'mattn/webapi-vim', { 'autoload' : { 'function_prefix' : 'webapi' } }
NeoBundleLazy 'tyru/open-browser.vim', { 'autoload' : { 'mappings'  : ['<Plug>(openbrowser-open)'], 'function_prefix' : 'openbrowser' } }

" NeoBundle 'mattn/habatobi-vim'
" NeoBundle 'mattn/unite-advent_calendar'
" NeoBundle 'modsound/gips-vim'
" NeoBundle 'mopp/unite-battle_editors'
" NeoBundle 'mopp/unite-rss'
" NeoBundle 'supermomonga/shaberu.vim'

if has('python')
    " pip install --user git+git://github.com/Lokaltog/powerline
    " NeoBundle 'Lokaltog/powerline', { 'rtp' : '~/.vim/bundle/powerline/powerline/bindings/vim', 'build' : { 'mac' : 'python setup.py build install --user' } }
else
    NeoBundle 'Lokaltog/vim-powerline'
    let g:Powerline_stl_path_style = 'short'

    " PowerLineの再読み込み
    if exists('g:Powerline_loaded')
        silent! call Pl#Load()
    endif
endif

filetype plugin indent on

" Unite
let g:unite_data_directory = expand('~/.vim/unite')
let g:unite_source_file_mru_limit = 50
let g:unite_cursor_line_highlight = 'TabLineSel'
let g:unite_enable_short_source_names = 1
let g:unite_source_history_yank_enable = 1
if executable('ag')
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '--nocolor --nogroup'
    let g:unite_source_grep_max_candidates = 200
endif
nnoremap <silent> fre :<C-u>UniteResume<CR>
nnoremap <silent> fb  :<C-u>Unite -buffer-name=Buffers buffer:!<CR>
nnoremap <silent> fk  :<C-u>Unite -buffer-name=Bookmark bookmark -default-action=vimfiler<CR>
nnoremap <silent> fs  :<C-u>Unite -buffer-name=Files file file_mru<CR>
nnoremap <silent> fd  :<C-u>Unite -buffer-name=Directory -default-action=tabopen directory directory_mru<CR>
nnoremap <silent> ff  :<C-u>Unite -buffer-name=Sources source<CR>
nnoremap <silent> fg  :<C-u>Unite -buffer-name=ag grep -keep-focus -no-quit<CR>
nnoremap <silent> fhc :<C-u>Unite -buffer-name=History history/command<CR>
nnoremap <silent> fhy :<C-u>Unite -buffer-name=History history/yank<CR>
nnoremap <silent> fhs :<C-u>Unite -buffer-name=History history/search<CR>
nnoremap <silent> fhl :<C-u>Unite -buffer-name=Help help<CR>
nnoremap <silent> fma :<C-u>Unite -buffer-name=Mappings mapping<CR>
nnoremap <silent> fme :<C-u>Unite -buffer-name=Messages output:message<CR>
nnoremap <silent> fo  :<C-u>Unite -buffer-name=Outlines outline<CR>
nnoremap <silent> fl  :<C-u>Unite -buffer-name=Line line -no-quit<CR>
nnoremap <silent> fr  :<C-u>Unite -buffer-name=Registers register<CR>
nnoremap <silent> fta :<C-u>Unite -buffer-name=Tags tag tag/file<CR>
nnoremap <silent> ft  :<C-u>Unite -buffer-name=Twitter tweetvim<CR>
nnoremap <silent> fq  :<C-u>Unite -buffer-name=QuickFix qf -no-quit -auto-resize -direction=botright<CR>
nnoremap <silent> fup :<C-u>Unite -buffer-name=NeobundleUpdateLog -log neobundle/update -direction=botright<CR>
nnoremap <silent> fed :<C-u>Unite -buffer-name=english english_dictionary<CR>
nnoremap <silent> fex :<C-u>Unite -buffer-name=example english_example<CR>
nnoremap <silent> fet :<C-u>Unite -buffer-name=thesaurus english_thesaurus<CR>
nnoremap <silent> fa  :<C-u>Unite -buffer-name=Reanimate Reanimate<CR>
function! s:configUnite()
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
    let g:neocomplete#data_directory = expand('~/.vim/neocomplete')
    let g:neocomplete#skip_auto_completion_time = '' "オムニ補完と相性が悪いかもしれない

    " 英単語補完用に以下のfiletypeをtextと同様に扱う
    if !exists('g:neocomplete#text_mode_filetypes')
        let g:neocomplete#text_mode_filetypes = {}
    endif
    let g:neocomplete#text_mode_filetypes.mkd = 1
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
    let g:neocomplete#delimiter_patterns.cpp = ['::', '.']
    let g:neocomplete#delimiter_patterns.c = ['.', '->']
    let g:neocomplete#delimiter_patterns.java = ['.']

    " 外部オムニ補完関数を直接呼び出す
    if !exists('g:neocomplete#force_omni_input_patterns')
        let g:neocomplete#force_omni_input_patterns = {}
    endif
    let g:neocomplete#force_overwrite_completefunc = 1
    let g:neocomplete#force_omni_input_patterns.java = '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplete#force_omni_input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplete#force_omni_input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
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
    let g:neocomplete#sources#omni#input_patterns.java = '[^.[:digit:] *\t]\.\%(\h\w*\)\?\|[a-zA-Z].*'

    if !exists('g:neocomplete#sources#vim#complete_functions')
        let g:neocomplete#sources#vim#complete_functions = {}
    endif
    let g:neocomplete#sources#vim#complete_functions.Ref = 'ref#complete'
    let g:neocomplete#sources#vim#complete_functions.Unite = 'unite#complete_source'
    let g:neocomplete#sources#vim#complete_functions.VimFiler = 'vimfiler#complete'
    let g:neocomplete#sources#vim#complete_functions.Vinarise = 'vinarise#complete'

    inoremap <expr> <C-l> neocomplete#complete_common_string()
    imap <C-q>  <Plug>(neocomplete_start_unite_quick_match)
endfunction
unlet s:bundle

" Clang_complete
let g:clang_complete_auto = 0
let g:clang_auto_select = 0

" Neosnippet
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
set conceallevel=2 concealcursor=i

" Easymotion
let g:EasyMotion_leader_key = '<Leader>e'

" NERDCommenter
let g:NERDSpaceDelims = 1
nmap <Leader><Leader> <Plug>NERDCommenterToggle
vmap <Leader><Leader> <Plug>NERDCommenterNested

" VimFiler
nnoremap <silent> fvs :VimFilerExplorer<CR>
nnoremap <silent> fvr :VimFilerExplorer -status ssh://ains<CR>
nnoremap <silent> fvo :VimFilerTab -status<CR>
let g:vimfiler_data_directory = expand('~/.vim/vimfiler')
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_tree_closed_icon = '▸'
let g:vimfiler_tree_opened_icon = '▾'
let g:vimfiler_directory_display_top = 1
let g:vimfiler_preview_action = 'below'
let g:vimfiler_split_action = 'right'
let g:vimfiler_enable_auto_cd = 1
function! s:configVimFiler()
    nmap <buffer> : <Plug>(vimfiler_toggle_mark_current_line)
    vmap <buffer> : <Plug>(vimfiler_toggle_mark_selected_lines)
    nnoremap <silent><buffer><expr> <C-t> vimfiler#do_action('tabopen')
    nnoremap <silent><buffer><expr> <C-b> vimfiler#do_action('bookmark')
endfunction

" SrcExpl
nmap <silent> <Leader>sc :SrcExplToggle<CR>
let g:SrcExpl_RefreshTime = 1
let g:SrcExpl_UpdateTags = 1
let g:SrcExpl_WinHeight = 10
let g:SrcExpl_pluginList = ["__Tag_List__", "NERD_tree_1", "Source_Explorer", "*unite*", "*vimfiler* - explorer", "__Tagbar__" ]

" TagBar
let g:tagbar_width = 35
let g:tagbar_autoshowtag = 1
let g:tagbar_autofocus = 1
let g:tagbar_sort = 0
let g:tagbar_compact = 1
highlight TagbarScope ctermfg=5
highlight TagbarType cterm=bold ctermfg=55
highlight TagbarHighlight cterm=bold,underline ctermfg=1
highlight TagbarSignature ctermfg=70
nnoremap <silent> tb :<C-U>TagbarToggle<CR>

" Smartinput
let s:bundle = neobundle#get('vim-smartinput')
function! s:bundle.hooks.on_source(bundle)
    call smartinput#map_to_trigger('i', '<Space>', '<Space>', '<Space>')
    call smartinput#define_rule({
                \ 'at'    : '(\%#)',
                \ 'char'  : '<Space>',
                \ 'input' : '<Space><Space><Left>',
                \ })

    call smartinput#define_rule( {
                \ 'at' : '( \%# )',
                \ 'char'  : '<BS>',
                \ 'input' : '<Del><BS>',
                \ })

    call smartinput#map_to_trigger('i', '>', '>', '>')
    call smartinput#define_rule({
                \ 'at'    : '<\%#',
                \ 'char'  : '>',
                \ 'input' : '><Left>',
                \ })

    call smartinput#define_rule( {
                \ 'at' : '<\%#>',
                \ 'char'  : '<BS>',
                \ 'input' : '<Del><BS>'
                \ })

    " call smartinput#define_rule({
    " \ 'at': '\s\+\%#',
    " \ 'char': '<CR>',
    " \ 'input': "<C-o>:call setline('.', substitute(getline('.'), '\\s\\+$', '', ''))<CR><CR>",
    " \ })

    if &filetype ==? 'lisp'
        call smartinput#map_to_trigger('i', '*', '*', '*')
        call smartinput#define_rule({
                    \ 'at'    : 'defparameter \*\%#',
                    \ 'char'  : '*',
                    \ 'input' : '*<Left>',
                    \ })
    endif
endfunction
unlet s:bundle

" Smartchr
let s:bundle = neobundle#get('vim-smartchr')
function! s:bundle.hooks.on_source(bundle)
    inoremap <expr> = smartchr#one_of(' = ', ' == ', '=')
    inoremap <expr> + smartchr#one_of(' + ', '++', '+')
    inoremap <expr> - smartchr#one_of(' - ', '--', '-')
    inoremap <expr> / smartchr#one_of(' / ', '// ', '/')
    inoremap <expr> , smartchr#loop(', ', '->', ' => ')
    inoremap <expr> ! smartchr#loop('! ', ' != ', '!')

    if &filetype ==? 'lisp'
        inoremap <expr> ; smartchr#loop('; ', ';')
    endif
endfunction
unlet s:bundle

" Like A IDE :)
function! s:likeIDE()
    cd %:p:h
    VimFilerExplorer -simple
    wincmd l
    TagbarToggle
    wincmd h
    SrcExplToggle
endfunction
nnoremap <silent> <Leader>id :call <SID>likeIDE()<CR>

" Ref-vim
let g:ref_open = 'split'
let g:ref_source_webdict_cmd = 'w3m -t 4 -cols 180 -dump %s'
let g:ref_source_webdict_sites = { 'Wikipedia:ja' : 'http://ja.wikipedia.org/wiki/%s', 'Weblio' : 'http://ejje.weblio.jp/content/%s', 'Weblio-Thesaurus' : 'http://ejje.weblio.jp/english-thesaurus/content/%s'}
let g:ref_source_webdict_sites.default = 'Wikipedia:ja'

" QuickRun
let g:quickrun_config = {}
" let g:quickrun_config._ = { 'runner' : 'vimproc', 'outputter/buffer/split' : ':botright 10sp' }
let g:quickrun_config._ = { 'outputter/buffer/split' : ':vertical rightbelow' }
let g:quickrun_config.lisp =  { 'command' : 'clisp', 'exec' : '%c < %s:p' }

" Conque
let g:ConqueTerm_ReadUnfocused = 1
let g:ConqueTerm_CloseOnEnd = 1
let g:ConqueTerm_StartMessages = 0
let g:ConqueTerm_CWInsert = 1
noremap <silent> <Leader>sh :ConqueTermVSplit zsh<CR>

" TweetVim
let g:tweetvim_tweet_per_page = 60
let g:tweetvim_display_source = 1
let g:tweetvim_display_time = 1
let g:tweetvim_say_insert_account = 1
let g:tweetvim_async_post = 1
let g:tweetvim_open_say_cmd = 'split'
let g:tweetvim_config_dir = expand('~/.vim/tweetvim')
let g:tweetvim_display_username = 1

" Shaberu
let g:shaberu_user_define_say_command = 'say -v Kyoko "%%TEXT%%"'

" Gips
let g:gips_speech_via_shaberu = 1

" JaSegment
let g:jasegment#model = 'rwcp'

" SuddenDeath
map <Leader>x <Plug>(operator-suddendeath)

" Open-Browser
map <Leader>op <Plug>(openbrowser-open)

" learn-vimscript
nnoremap <Leader>lv :help learn-vimscript.txt<CR> <C-W>L

" Textobj-MultiBlock
omap ab <Plug>(textobj-multiblock-a)
omap ib <Plug>(textobj-multiblock-i)
vmap ab <Plug>(textobj-multiblock-a)
vmap ib <Plug>(textobj-multiblock-i)

" Thumbnail
nnoremap <Leader>th :Thumbnail<CR>

" Textobj-Operator-Replace
map _ <Plug>(operator-replace)

" Alpaca_english
if has('ruby')
    let g:alpaca_english_enable = 1
else
    let g:alpaca_english_enable = 0
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


"-------------------------------------------------------------------------------"
" autocmd
"-------------------------------------------------------------------------------"

" Highlight
function! s:configHighlight()
    highlight Cursor ctermbg=55
    highlight FoldColumn ctermfg=130
    highlight Folded cterm=bold,underline ctermfg=14 ctermbg=55
    highlight MatchParen cterm=bold,underline ctermbg=3
    highlight Search ctermbg=3 ctermfg=0
    highlight TabLineSel ctermbg=5
endfunction

" Conque
function! s:deleteConqueTerm(buffer_name)
    let term_obj = conque_term#get_instance(a:buffer_name)
    call term_obj.close()
endfunction

" Lisp
function! s:configLisp()
    setlocal nocindent
    setlocal autoindent
    setlocal nosmartindent
    setlocal lisp
    setlocal lispwords=define
endfunction

" C/C++
function! s:configCCpp()
    NeoBundleSource cpp-vim
    if has('mac') && isdirectory('/usr/lib')
        let g:clang_library_path = '/usr/local/lib/'
        let g:clang_user_options = '-I/usr/local/include/ -I/usr/local/include/boost/'
        let g:clang_executable_path = '/usr/local/bin/'
        NeoBundleSource clang_complete
    endif
    setlocal nosmartindent
    setlocal nocindent
    setlocal autoindent
    setlocal cindent
endfunction

" 行末の空白を削除
function! s:remove_tail_space()
    let c = getpos('.')
    g/.*\s$/normal $gelD
    call setpos('.', c)
endfunction

augroup general
    autocmd!

    " .vimrc
    autocmd BufWritePost nested $MYVIMRC source $MYVIMRC

    " 書き込み時に行末の空白を削除
    autocmd BufWritePre * silent call s:remove_tail_space()

    " 挿入モード解除時に自動でpasteをoff
    autocmd InsertLeave * setlocal nopaste

    " 状態の保存と復元
    autocmd BufWinLeave ?* if(bufname('%')!='') | silent mkview! | endif
    autocmd BufWinEnter ?* if(bufname('%')!='') | silent loadview | endif

    " 独自ハイライト
    autocmd Colorscheme * call s:configHighlight()

    " Text
    autocmd BufReadPre *.txt setlocal filetype=text
    " autocmd BufReadPre *.txt setlocal wrap

    " git
    autocmd FileType git setlocal foldlevel=99

    " VimFiler
    autocmd FileType vimfiler call s:configVimFiler()

    " Conque
    autocmd BufWinLeave zsh* call s:deleteConqueTerm(expand('%'))

    " Unite
    autocmd FileType unite call s:configUnite()

    " Lisp
    autocmd FileType lisp call s:configLisp()

    " C/C++
    autocmd FileType c,cpp call s:configCCpp()

    " nask
    autocmd BufReadPre *.nas setlocal filetype=NASM

    " Arduino
    autocmd BufNewFile,BufRead *.pde,*.ino nested setlocal filetype=arduino

    " json
    autocmd BufRead,BufNewFile *.json nested setlocal filetype=json autoindent

    " Java
    autocmd CompleteDone *.java call javaapi#showRef()
augroup END

colorscheme desert
syntax enable           " 強調表示有効
set re=2
