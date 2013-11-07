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
set cindent
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
let &path = '.,./include/,' . substitute($PATH, '/[a-zA-Z]*bin:', '/include/,', 'g')

" 折りたたみ
set foldenable
set foldcolumn=3            " 左側に折りたたみガイド表示$
set foldmethod=indent       " 折畳の判別
set foldtext=g:to_fold() " 折りたたみ時の表示設定
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
" 折り畳み時表示テキスト設定用関数
function! g:to_fold()
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
endif

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
noremap <silent> <F2> :<C-U>bprevious<CR>
noremap <silent> <F3> :<C-U>bnext<CR>

" Tab操作
noremap <Leader>to :tabnew<Space>
noremap <Leader>j gT
noremap <Leader>k gt

" 画面分割
noremap <Leader>sp :split<Space>
noremap <Leader>vsp :vsplit<Space>

" 現在バッファをTabで開く
noremap <Leader>tsp :tab split<CR>

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

" <C-Space> で <NUL> が来るため
map <NUL> <C-Space>
map! <NUL> <C-Space>

" Yank & Paste
nnoremap Y y$
nnoremap <silent> <Leader>pp :set paste!<CR>
noremap <C-Space> "*yy
noremap mp "*p

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
" Plugin
"-------------------------------------------------------------------------------"
" neobundleが存在しない場合これ以降を読み込まない
if !isdirectory(expand('~/.vim/bundle/neobundle.vim'))
    echoerr 'No NeoBundle !'
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
NeoBundle 'Shougo/vimproc.vim' ,{ 'build' : { 'mac' : 'make -f make_mac.mak', 'unix' : 'make -f make_unix.mak' } }
NeoBundle 'bling/vim-airline'
NeoBundle 'honza/vim-snippets'
NeoBundle 'kana/vim-niceblock'
NeoBundle 'mattn/sonictemplate-vim'
NeoBundle 'mopp/openvimrc.vim'
NeoBundle 'osyo-manga/shabadou.vim'
NeoBundle 'osyo-manga/vim-anzu'
NeoBundle 'osyo-manga/vim-reunions'
NeoBundle 'rbtnn/vimconsole.vim'
NeoBundle 'rhysd/vim-operator-surround'
NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'thinca/vim-ambicmd'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'thinca/vim-ref'
NeoBundle 'thinca/vim-visualstar'
NeoBundle 'tomasr/molokai'
NeoBundle 'tpope/vim-fugitive', { 'external_commands' : ['git'], 'disabled' : (!executable('git')) }
NeoBundle 'tpope/vim-repeat'
NeoBundle 'vim-jp/vimdoc-ja'
NeoBundle 'vim-scripts/Rainbow-Parentheses-Improved-and2'
NeoBundleLazy 'Rip-Rip/clang_complete', { 'autoload' : { 'filetype' : 'c' , 'insert' : '1'} ,  'build' : { 'mac' : 'make install', 'others' : 'make install'} }
NeoBundleLazy 'Shougo/context_filetype.vim', { 'autoload' : { 'function_prefix' : 'context_filetype' } }
NeoBundleLazy 'Shougo/neocomplete.vim', { 'depends' : 'Shougo/context_filetype.vim',  'autoload' : { 'insert' : '1' }, 'disabled' : (!has('lua')), 'vim_version' : '7.3.885' }
NeoBundleLazy 'Shougo/neosnippet', { 'autoload' : { 'insert' : '1', 'unite_sources' : ['neosnippet/runtime', 'neosnippet/user', 'snippet']} }
NeoBundleLazy 'Shougo/vimfiler', { 'depends' : 'Shougo/unite.vim', 'autoload' : { 'commands' : [ { 'name' : 'VimFiler', 'complete' : 'customlist,vimfiler#complete'}, 'VimFiler', 'VimFilerTab', 'VimFilerExplorer',], 'explorer' : 1,} }
NeoBundleLazy 'Shougo/vinarise', { 'autoload' : { 'commands' : 'Vinarise'} }
NeoBundleLazy 'calorie/vim-swap-windows'
NeoBundleLazy 'elzr/vim-json', { 'autoload' : { 'filetypes' : 'json' } }
NeoBundleLazy 'gregsexton/gitv', { 'depends' : 'tpope/vim-fugitive', 'autoload' : {'commands' : 'Gitv'} }
NeoBundleLazy 'info.vim', { 'autoload' : { 'commands' : 'Info'} }
NeoBundleLazy 'itchyny/dictionary.vim', { 'autoload' : { 'commands' : 'Dictionary'}, 'disabled' : (!has('mac')) }
NeoBundleLazy 'itchyny/thumbnail.vim', { 'autoload' : {'commands' : 'Thumbnail'} }
NeoBundleLazy 'kana/vim-operator-replace', { 'autoload' : { 'mappings'  : ['<Plug>(operator-replace)'] } }
NeoBundleLazy 'kana/vim-operator-user', { 'autoload' : { 'function_prefix' : 'operator' } }
NeoBundleLazy 'kana/vim-smartchr', '', 'loadInsert'
NeoBundleLazy 'kana/vim-smartinput', '', 'loadInsert'
NeoBundleLazy 'kannokanno/previm', { 'autoload' : { 'filetype' : 'markdown' } }
NeoBundleLazy 'koron/nyancat-vim', { 'autoload' : { 'commands' : [ 'Nyancat', 'Nyancat2',], } }
NeoBundleLazy 'majutsushi/tagbar', { 'autoload' : { 'commands'  : 'TagbarToggle' } }
NeoBundleLazy 'mattn/benchvimrc-vim', { 'autoload' : {'commands' : 'BenchVimrc'} }
NeoBundleLazy 'mattn/gist-vim', { 'autoload' : {'commands' : 'Gist'} }
NeoBundleLazy 'mattn/learn-vimscript', { 'autoload' : { 'mappings'  : ['<Leader>lv'] } }
NeoBundleLazy 'osyo-manga/vim-marching', { 'autoload' : { 'filetype' : 'cpp' , 'insert' : '1'} }
NeoBundleLazy 'plasticboy/vim-markdown', { 'autoload' : { 'filetypes' : 'markdown' } }
NeoBundleLazy 'rosenfeld/conque-term', { 'autoload' : { 'commands'  : ['ConqueTerm', 'ConqueTermSplit', 'ConqueTermTab', 'ConqueTermVSplit'] } }
NeoBundleLazy 'scrooloose/syntastic', '', 'loadInsert'
NeoBundleLazy 'taichouchou2/alpaca_english', { 'build' : { 'mac' : 'bundle', }, 'autoload' : { 'insert' : '1', 'unite_sources': ['english_dictionary', 'english_example', 'english_thesaurus'], } }
NeoBundleLazy 'taku-o/vim-copypath', { 'autoload' : { 'commands'  : ['CopyFileName', 'CopyPath'] } }
NeoBundleLazy 'thinca/vim-ft-help_fold', { 'autoload' : {'commands' : 'help'} }
NeoBundleLazy 'thinca/vim-painter'
NeoBundleLazy 'thinca/vim-scouter'
NeoBundleLazy 'ujihisa/neco-look', '', 'loadInsert'
NeoBundleLazy 'vim-jp/cpp-vim', { 'autoload' : { 'filetypes' : 'cpp' } }
NeoBundleLazy 'vim-jp/vital.vim'
NeoBundleLazy 'vim-scripts/Arduino-syntax-file', { 'autoload' : { 'filetypes' : 'arduino' } }
NeoBundleLazy 'yomi322/vim-operator-suddendeath', { 'depends' : 'kana/vim-operator-user', 'autoload' : {'mappings' : ['<Plug>(operator-suddendeath)']} }
NeoBundleLazy 'yuratomo/java-api-complete', { 'autoload' : { 'filetypes' : 'java' } }

NeoBundle 'h1mesuke/textobj-wiw'
NeoBundle 'kana/vim-textobj-function'
NeoBundle 'kana/vim-textobj-indent'
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'osyo-manga/vim-textobj-multiblock'
NeoBundle 'osyo-manga/vim-textobj-multitextobj'
NeoBundle 'sgur/vim-textobj-parameter'

NeoBundleLazy 'Shougo/unite.vim', { 'autoload' : { 'commands' : [{ 'name' : 'Unite', 'complete' : 'customlist,unite#complete_source'}, 'Unite'], 'function_prefix' : 'unite' }}
NeoBundleLazy 'Shougo/unite-help', { 'autoload' : { 'unite_sources' : ['help'],} }
NeoBundleLazy 'Shougo/unite-outline', { 'autoload' : { 'unite_sources' : ['outline'],} }
NeoBundleLazy 'Shougo/unite-ssh', { 'autoload' : { 'unite_sources' : ['ssh'],} }
NeoBundleLazy 'osyo-manga/vim-reanimate', { 'autoload' : { 'unite_sources' : ['Reanimate'], 'commands' : ['ReanimateLoad', 'ReanimateSave']} }
NeoBundleLazy 'osyo-manga/unite-quickfix', { 'autoload' : { 'unite_sources' : ['quickfix'],} }
NeoBundleLazy 'thinca/vim-unite-history', { 'autoload' : { 'unite_sources' : ['history/command', 'history/yank', 'history/search'],} }

NeoBundleLazy 'basyura/TweetVim', { 'depends' : ['basyura/twibill.vim', 'tyru/open-browser.vim'], 'autoload' : { 'commands' : ['TweetVimHomeTimeline', 'TweetVimUserStream'], 'unite_sources' : ['tweetvim'],} }
NeoBundleLazy 'basyura/twibill.vim', { 'depends' : 'tyru/open-browser.vim'}
NeoBundleLazy 'mattn/excitetranslate-vim', { 'depends' : 'mattn/webapi-vim', 'autoload' : { 'commands' : 'ExciteTranslate' } }
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
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '--nocolor --nogroup'
    let g:unite_source_grep_max_candidates = 200
endif
nnoremap <silent> fre :<C-u>UniteResume<CR>
nnoremap <silent> fb  :<C-u>Unite -buffer-name=Buffers buffer:!<CR>
nnoremap <silent> fk  :<C-u>Unite -buffer-name=Bookmark bookmark -default-action=vimfiler<CR>
nnoremap <silent> fs  :<C-u>Unite -buffer-name=Files file_mru<CR>
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
nnoremap <silent> fl  :<C-u>Unite -buffer-name=Line line/fast:all -no-quit<CR>
nnoremap <silent> fr  :<C-u>Unite -buffer-name=Registers register<CR>
nnoremap <silent> fta :<C-u>Unite -buffer-name=Tags tag tag/file<CR>
nnoremap <silent> fn  :<C-u>Unite -buffer-name=Snippet snippet<CR>
nnoremap <silent> ft  :<C-u>Unite -buffer-name=Twitter tweetvim<CR>
nnoremap <silent> fq  :<C-u>Unite -buffer-name=QuickFix quickfix -no-quit -direction=botright<CR>
nnoremap <silent> fa  :<C-u>Unite -buffer-name=Reanimate Reanimate<CR>
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
    let g:neocomplete#delimiter_patterns.cpp = ['::', '.']
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
unlet s:bundle

" Clang_complete
let s:bundle = neobundle#get('clang_complete')
function! s:bundle.hooks.on_source(bundle)
    let clang_exe = 'clang'
    if !executable(clang_exe)
        return
    endif

    let g:clang_complete_auto = 0
    let g:clang_auto_select = 0
    let g:clang_jumpto_declaration_key = 'dummy'
    let g:clang_jumpto_back_key = 'dummy'

    let clang_path = '/usr/local/'
    if isdirectory(clang_path) && '' != findfile('clang', clang_path . 'bin;')
        let g:clang_executable_path = clang_path.'bin/'
        let g:clang_library_path = clang_path.'lib/'
    endif
endfunction
unlet s:bundle

" Neosnippet
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
imap <C-l> <Plug>(neosnippet_start_unite_snippet)
set conceallevel=2 concealcursor=i
let g:neosnippet#snippets_directory = expand('~/.vim/bundle/vim-snippets/snippets') . '/*.snippets'

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

" Smartinput
let s:bundle = neobundle#get('vim-smartinput')
function! s:bundle.hooks.on_source(bundle)
    call smartinput#map_to_trigger('i', '<Space>', '<Space>', '<Space>')
    call smartinput#define_rule({ 'char' : '<Space>', 'at' : '(\%#)', 'input' : '<Space><Space><Left>'})

    let lst = [   ['<',     "smartchr#loop(' < ', '<<', '<')" ],
                \ ['>',     "smartchr#loop(' > ', '>>', ' >>> ', '>')"],
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
    " inoremap <expr> + smartchr#one_of(' + ', '++', '+')
    " inoremap <expr> - smartchr#one_of(' - ', '--', '-')
    " inoremap <expr> / smartchr#one_of(' / ', '// ', '/')
    " inoremap <expr> ! smartchr#one_of('! ', ' != ', '!')
    " inoremap <expr> = smartchr#one_of(' = ', ' == ', '=')
    inoremap <expr> , smartchr#one_of(', ', '->', ' => ')

    if &filetype ==? 'lisp'
        inoremap <expr> ; smartchr#loop('; ', ';')
    endif
endfunction
unlet s:bundle

" Like A IDE :)
function! s:like_IDE()
    cd %:p:h
    VimFilerExplorer -simple
    wincmd l
    TagbarToggle
    wincmd h
    SrcExplToggle
endfunction
nnoremap <silent> <Leader>id :call <SID>like_IDE()<CR>

" Ref-vim
let g:ref_open = 'split'
let g:ref_source_webdict_cmd = 'w3m -t 4 -cols 180 -dump %s'
let g:ref_source_webdict_sites = { 'Wikipedia:ja' : 'http://ja.wikipedia.org/wiki/%s', 'Weblio' : 'http://ejje.weblio.jp/content/%s', 'Weblio-Thesaurus' : 'http://ejje.weblio.jp/english-thesaurus/content/%s'}
let g:ref_source_webdict_sites.default = 'Wikipedia:ja'

" QuickRun
let g:quickrun_config = {}
let g:quickrun_config._ = { 'outputter' : 'quickfix', 'outputter/buffer/split' : ':vertical rightbelow', 'runner' : 'vimproc' }
let g:quickrun_config.lisp = { 'command' : 'clisp', 'exec' : '%c < %s:p' }
let g:quickrun_config.make = { 'command' : "make",  'exec' : '%c %o', 'runner' : 'vimproc', "outputter/quickfix/open_cmd" : "", "hook/unite_quickfix/enable_exit" : 1, "hook/unite_quickfix/enable_failure" : 1}

" Conque
let g:ConqueTerm_ReadUnfocused = 1
let g:ConqueTerm_CloseOnEnd = 1
let g:ConqueTerm_StartMessages = 0
let g:ConqueTerm_CWInsert = 0
let g:ConqueTerm_EscKey = '<C-K>'
noremap <silent> <Leader>sh :ConqueTermVSplit <C-R>=$SHELL<CR><CR>

" TweetVim
let g:tweetvim_tweet_per_page = 60
let g:tweetvim_display_source = 1
let g:tweetvim_display_time = 1
let g:tweetvim_say_insert_account = 1
let g:tweetvim_async_post = 1
let g:tweetvim_open_say_cmd = 'split'
let g:tweetvim_config_dir = expand('~/.vim/tweetvim')
let g:tweetvim_display_username = 1
let g:tweetvim_display_icon = 1

" SuddenDeath
map <Leader>x <Plug>(operator-suddendeath)

" Open-Browser
map <Leader>op <Plug>(openbrowser-open)

" learn-vimscript
nnoremap <Leader>lv :help learn-vimscript.txt<CR> <C-W>L

" operator-replace
map _ <Plug>(operator-replace)

" operator-surround
nmap <silent>ys <Plug>(operator-surround-append)
omap <silent>ys <Plug>(operator-surround-append)
nmap <silent>yd <Plug>(operator-surround-delete)
omap <silent>yd <Plug>(operator-surround-delete)
nmap <silent>yr <Plug>(operator-surround-replace)
omap <silent>yr <Plug>(operator-surround-replace)
nmap <silent>yss <Plug>(operator-surround-append)<Plug>(textobj-multiblock-a)
nmap <silent>ydd <Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)
nmap <silent>yrr <Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)

" Textobj-wiw
let g:textobj_wiw_no_default_key_mappings = 0
map mw <Plug>(textobj-wiw-n)
map mb <Plug>(textobj-wiw-p)
map me <Plug>(textobj-wiw-N)
map mge <Plug>(textobj-wiw-P)

" Textobj-MultiTextobj
let g:textobj_multitextobj_textobjects_group_i = {
            \   "A" : [
            \       "i,",
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
            \       "a,",
            \       "\<Plug>(textobj-wiw-a)",
            \       "aw",
            \    ],
            \   "B" : [
            \       "at",
            \       "\<Plug>(textobj-multiblock-a)",
            \    ],
            \}
map <Plug>(textobj-word-i)  <Plug>(textobj-multitextobj-A-i)
map <Plug>(textobj-word-a)  <Plug>(textobj-multitextobj-A-a)
map <Plug>(textobj-block-i) <Plug>(textobj-multitextobj-B-i)
map <Plug>(textobj-block-a) <Plug>(textobj-multitextobj-B-a)
omap iw <Plug>(textobj-word-i)
vmap iw <Plug>(textobj-word-i)
omap aw <Plug>(textobj-word-a)
vmap aw <Plug>(textobj-word-a)
omap ib <Plug>(textobj-block-i)
vmap ib <Plug>(textobj-block-i)
omap ab <Plug>(textobj-block-a)
vmap ab <Plug>(textobj-block-a)

" Thumbnail
nnoremap <Leader>th :Thumbnail<CR>

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

" airline
let g:airline_left_sep = '▶ '
let g:airline_right_sep = '◀'
let g:airline_linecolumn_prefix = '¶'
let g:airline_branch_prefix = '⎇ '
let g:airline_theme = 'simple'
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#branch#enabled = 1

" syntastic
let g:syntastic_mode_map = { 'mode': 'active', 'active_filetypes': [], 'passive_filetypes': ['nasm'] }
" let g:syntastic_auto_loc_list = 1
let g:syntastic_loc_list_height = 5

" Ambicmd
if neobundle#is_installed('vim-ambicmd')
    cnoremap <expr> <CR>    ambicmd#expand('<CR>')
    cnoremap <expr> <Space> ambicmd#expand('<Space>')
    " cnoremap <expr> <Tab>   ambicmd#expand('<Tab>')
endif

" rainbow parenthesis
let g:rainbow_active = 1
let g:rainbow_operators = 1
let g:rainbow_load_separately = [ [ '*' , [['(', ')'], ['\[', '\]'], ['{', '}']] ], [ '*.{html,htm}' , [['(', ')'], ['\[', '\]'], ['{', '}'], ['<\a[^>]*>', '</[^>]*>']] ], ]

" anzu
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)'

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

" marching
let s:bundle = neobundle#get('vim-marching')
function! s:bundle.hooks.on_source(bundle)
    if has('mac')
        let clang_exe = 'clang-3.4'
    else
        let clang_exe = 'clang'
    endif

    if !executable(clang_exe)
        echomsg 'Clang is NOT found.'
        return
    endif

    " systemの戻り値に注意
    let g:marching_clang_command = substitute(system('where '.clang_exe), '\r\|\n', '', 'g')
    let g:marching_clang_command_option = "-Wall -std=c++1y"
    let g:marching_enable_neocomplete = 1

    set updatetime=200
endfunction
unlet s:bundle


"-------------------------------------------------------------------------------"
" autocmd
"-------------------------------------------------------------------------------"

" Highlight
function! s:config_highlight()
    " highlight Cursor ctermbg=55
    " highlight FoldColumn ctermfg=130
    " highlight Folded cterm=bold,underline ctermfg=14 ctermbg=55
    highlight MatchParen cterm=bold,underline ctermbg=3
    highlight Search ctermbg=3 ctermfg=0
    highlight TabLineSel ctermbg=5
endfunction

" Conque
function! s:delete_conque_term(buffer_name)
    let term_obj = conque_term#get_instance(a:buffer_name)
    call term_obj.close()
endfunction

" Lisp
function! s:config_lisp()
    setlocal nocindent
    setlocal autoindent
    setlocal nosmartindent
    setlocal lisp
    setlocal lispwords=define
endfunction

" C/C++
function! s:config_ccpp()
    setlocal nosmartindent
    setlocal nocindent
    setlocal autoindent
    setlocal cindent
endfunction

" 行末の空白を削除
function! s:remove_tail_space()
    if &filetype == 'markdown'
        return
    endif
    let c = getpos('.')
    g/.*\s$/normal $gelD
    call setpos('.', c)
endfunction

augroup general
    autocmd!

    " .vimrc
    autocmd BufWritePost $MYVIMRC nested source $MYVIMRC

    " 書き込み時に行末の空白を削除
    autocmd BufWritePre * silent call s:remove_tail_space()

    " 挿入モード解除時に自動でpasteをoff
    autocmd InsertLeave * setlocal nopaste

    " 状態の保存と復元
    autocmd BufWinLeave ?* if(bufname('%')!='') | silent mkview! | endif
    autocmd BufWinEnter ?* if(bufname('%')!='') | silent loadview | endif

    " 独自ハイライト
    autocmd Colorscheme * call s:config_highlight()

    " Text
    autocmd BufReadPre *.txt setlocal filetype=text
    " autocmd BufReadPre *.txt setlocal wrap

    " git
    autocmd FileType git setlocal foldlevel=99

    " VimFiler
    autocmd FileType vimfiler call s:config_vimfiler()

    " Conque
    autocmd BufWinLeave zsh* call s:delete_conque_term(expand('%'))

    " Unite
    autocmd FileType unite call s:config_unite()

    " Lisp
    autocmd FileType lisp call s:config_lisp()

    " C/C++
    autocmd FileType c,cpp call s:config_ccpp()
    autocmd BufReadPost *.h setlocal filetype=c

    " nask
    autocmd BufReadPre *.nas setlocal filetype=nasm

    " Arduino
    autocmd BufNewFile,BufRead *.pde,*.ino nested setlocal filetype=arduino

    " json
    autocmd BufRead,BufNewFile *.json nested setlocal filetype=json autoindent

    " json
    autocmd BufRead,BufNewFile *.md nested setlocal filetype=markdown

    " Java
    autocmd CompleteDone *.java call javaapi#showRef()
augroup END

colorscheme molokai
syntax enable           " 強調表示有効
