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
if isdirectory(expand('~/.vim_backup'))
    set backupdir=~/.vim_backup
    set directory=~/.vim_backup
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
set history=500         " 検索やコマンドラインの保存履歴数
set completeopt=menu    " 挿入モードでの補完設定
set wildmenu            " コマンドの補完候補を表示

" 折りたたみ
set foldenable
set foldcolumn=3            " 左側に折りたたみガイド表示$
set foldmethod=indent       " 折畳の判別
set foldtext=g:ToFoldFunc() " 折りたたみ時の表示設定
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo " fold内に移動すれば自動で開く

" その他
set helplang=ja                 " ヘルプ検索で日本語を優先
set tags=./tags,tags            " タグが検索されるファイル
set viewoptions=cursor,folds    " :mkviewで保存する設定
set viminfo='1000,<500,f1       " viminfoへの保存設定
set whichwrap=b,s,h,l,<,>,[,]   " カーソルを行頭、行末で止まらないようにする
set timeout                     " マッピングのタイムアウト有効
set timeoutlen=3000             " マッピングのタイムアウト時間
set ttimeoutlen=100             " キーコードのタイムアウト時間
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
syntax enable           " 強調表示有効
colorscheme desert
highlight Cursor ctermbg=55
highlight FoldColumn ctermfg=130
highlight Folded cterm=bold,underline ctermfg=14 ctermbg=55
highlight MatchParen cterm=bold,underline ctermbg=3
highlight Search ctermbg=3 ctermfg=0
highlight TabLineSel ctermbg=5


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

    return printf('%s %s [ %2d Lines Lv%02d ] %s', line, v:folddashes, (v:foldend-v:foldstart+1), v:foldlevel, v:folddashes)
endfunction


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

    set path=.,/opt/local/include,/usr/include   " ファイルの検索パス指定

    " Metaキーを有効化 Reference from http://d.hatena.ne.jp/thinca/20101215/1292340358
    if !has('gui_running')
        for i in map( range(char2nr('a'), char2nr('z')) + range(char2nr('A'), char2nr('Z')) + range(char2nr('0'), char2nr('9')) , 'nr2char(v:val)')
            execute 'set <M-'.i.'>='.i
        endfor

        map <NUL> <C-Space>
        map! <NUL> <C-Space>
        map <C-Space> "*yy
    endif
endif


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

" set <M-m>=m
nnoremap <M-m> :echo 'mop'<CR>
nnoremap <M-M> :echo 'Mop'<CR>

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
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>
inoremap <C-D> <Del>
noremap <C-J> G
noremap <C-K> gg
noremap <C-H> ^
noremap <C-L> $

" バッファ操作
noremap <silent> <C-x> :bprevious<CR>
noremap <silent> <C-c> :bnext<CR>

" Tab操作
noremap go :tabnew<Space>
noremap <M-h> gt
noremap <M-l> gT

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
nnoremap <silent> <Leader>h :<C-U>help <C-R><C-W><CR>

" .vimrcを開く
nnoremap <silent> <Leader>ev :tabnew $MYVIMRC<CR>

" カレントウィンドウのカレントディレクトリを変更
nnoremap <Leader>cd :lcd %:p:h<CR>

" 検索ハイライト消去
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

" 空行を追加
nnoremap <silent> <Leader>o   :<C-u>for i in range(1, v:count1) \| call append(line('.'),   '') \| endfor \| silent! call repeat#set("<Space>o", v:count1)<CR>
nnoremap <silent> <Leader>O   :<C-u>for i in range(1, v:count1) \| call append(line('.')-1, '') \| endfor \| silent! call repeat#set("<Space>O", v:count1)<CR>

" Tagが複数あればリスト表示
nnoremap <C-]> g<C-]>zz


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
    let g:neobundle#default_options = { 'loadInsert' : { 'autoload' : { 'insert' : '1' } } }
endif
call neobundle#rc(expand('~/.vim/bundle'))

NeoBundleFetch 'git://github.com/Shougo/neobundle.vim'

" NeoBundleLazy 'git://github.com/vim-jp/vital.vim.git'
" NeoBundleLazy 'git://github.com/ynkdir/vim-vimlparser.git'

NeoBundle 'Lokaltog/vim-easymotion.git'
NeoBundle 'Shougo/vimproc.git', { 'build' : { 'mac' : 'make -f make_mac.mak', 'unix' : 'make -f make_unix.mak' } }
NeoBundle 'kana/vim-textobj-indent.git'
NeoBundle 'kana/vim-textobj-user.git'
NeoBundle 'mattn/learn-vimscript.git'
NeoBundle 'modsound/gips-vim.git'
NeoBundle 'scrooloose/nerdcommenter.git'
NeoBundle 'supermomonga/shaberu.vim.git'
NeoBundle 'thinca/vim-quickrun.git'
NeoBundle 'thinca/vim-ref.git'
NeoBundle 'thinca/vim-visualstar.git'
NeoBundle 'tpope/vim-repeat.git'
NeoBundle 'tpope/vim-surround.git'
NeoBundle 'ujihisa/neco-look.git'
NeoBundle 'vim-jp/vimdoc-ja.git'
NeoBundleLazy 'JSON.vim', { 'autoload' : { 'filetypes' : 'json' } }
NeoBundleLazy 'Shougo/neocomplcache-clang.git', { 'depends' : 'Shougo/neocomplcache' }
NeoBundleLazy 'Shougo/neocomplcache.git', { 'rev' : 'ver.8', 'autoload' : { 'insert' : 1 } }
NeoBundleLazy 'Shougo/neosnippet.git', '', 'loadInsert'
NeoBundleLazy 'Shougo/vimfiler.git', { 'depends' : 'Shougo/unite.vim', 'autoload' : { 'commands' : ['VimFiler', 'VimFilerTab', 'VimFilerExplorer'], 'explorer' : 1,} }
NeoBundleLazy 'Shougo/vinarise.git', { 'autoload' : { 'commands' : 'Vinarise'} }
NeoBundleLazy 'deton/jasegment.vim.git', { 'autoload' : { 'function_prefix' : 'jasegment' } }
NeoBundleLazy 'http://conque.googlecode.com/svn/trunk/', { 'directory' : 'conque', 'autoload' : { 'commands'  : ['ConqueTerm', 'ConqueTermSplit', 'ConqueTermTab', 'ConqueTermVSplit'] } }
NeoBundleLazy 'itchyny/thumbnail.vim.git', { 'autoload' : {'commands' : 'Thumbnail'} }
NeoBundleLazy 'kana/vim-operator-replace.git', { 'autoload' : { 'mappings'  : ['<Plug>(operator-replace)'] } }
NeoBundleLazy 'kana/vim-operator-user.git', { 'autoload' : { 'function_prefix' : 'operator' } }
NeoBundleLazy 'kana/vim-smartchr.git', '', 'loadInsert'
NeoBundleLazy 'kana/vim-smartinput.git', '', 'loadInsert'
NeoBundleLazy 'majutsushi/tagbar.git', { 'autoload' : { 'commands'  : 'TagbarToggle' } }
NeoBundleLazy 'mattn/benchvimrc-vim.git', { 'autoload' : {'commands' : 'BenchVimrc'} }
NeoBundleLazy 'osyo-manga/vim-textobj-multiblock.git', { 'autoload' : { 'mappings'  : ['<Plug>(textobj-multiblock-a)', '<Plug>(textobj-multiblock-i)'] } }
NeoBundleLazy 'plasticboy/vim-markdown.git', { 'autoload' : { 'filetypes' : 'md' } }
NeoBundleLazy 'scrooloose/syntastic.git', '', 'loadInsert'
NeoBundleLazy 'thinca/vim-painter.git'
NeoBundleLazy 'tomasr/molokai.git'
NeoBundleLazy 'uguu-org/vim-matrix-screensaver.git', { 'autoload' : {'commands' : 'Matrix'} }
NeoBundleLazy 'vim-jp/cpp-vim.git'
NeoBundleLazy 'vim-scripts/Arduino-syntax-file.git', { 'autoload' : { 'filetypes' : 'arduino' } }
NeoBundleLazy 'wesleyche/SrcExpl.git', { 'autoload' : { 'commands' : ['SrcExplToggle', 'SrcExpl', 'SrcExplClose'] } }
NeoBundleLazy 'yomi322/vim-operator-suddendeath.git', { 'depends' : 'kana/vim-operator-user', 'autoload' : {'mappings' : '<Plug>(operator-suddendeath)'} }
NeoBundleLazy 'yuratomo/gmail.vim.git', { 'autoload' : {'commands' : 'Gmail'} }
NeoBundleLazy 'yuratomo/java-api-complete.git'
NeoBundleLazy 'yuratomo/w3m.vim.git', { 'autoload' : {'commands' : 'W3m'} }

NeoBundleLazy 'Shougo/unite.vim.git', { 'autoload' : { 'commands' : 'Unite' }}
NeoBundle 'Shougo/unite-outline.git'
NeoBundle 'Shougo/unite-ssh.git'
NeoBundle 'thinca/vim-unite-history.git'
NeoBundle 'tsukkee/unite-tag.git'

NeoBundleLazy 'basyura/TweetVim.git', { 'depends' : ['basyura/twibill.vim', 'tyru/open-browser.vim'], 'autoload' : { 'commands' : ['TweetVimHomeTimeline', 'TweetVimSay']} }
NeoBundleLazy 'basyura/twibill.vim', { 'depends' : 'tyru/open-browser.vim'}
NeoBundleLazy 'mattn/excitetranslate-vim.git', { 'depends' : 'mattn/webapi-vim', 'autoload' : { 'commands' : 'ExciteTranslate' } }
NeoBundleLazy 'mattn/webapi-vim.git', { 'autoload' : { 'function_prefix' : 'webapi' } }
NeoBundleLazy 'tyru/open-browser.vim', { 'autoload' : { 'mappings'  : ['<Plug>(openbrowser-open)'] } }

if (has('python'))
    " pip install --user git+git://github.com/Lokaltog/powerline
    NeoBundle 'git://github.com/Lokaltog/powerline.git', { 'rtp' : '~/.vim/bundle/powerline/powerline/bindings/vim', 'build' : { 'mac' : 'python setup.py build install --user' } }
else
    NeoBundle 'git://github.com/Lokaltog/vim-powerline.git'
    let g:Powerline_stl_path_style = 'short'

    " PowerLineの再読み込み
    if exists('g:Powerline_loaded')
        silent! call Pl#Load()
    endif
endif

filetype plugin indent on

" Unite
let g:unite_source_file_mru_limit = 50
let g:unite_cursor_line_highlight = 'TabLineSel'
let g:unite_enable_short_source_names = 1
nnoremap [unite] <Nop>
nmap f [unite]
nnoremap <silent> [unite]b :<C-u>Unite -buffer-name=buffers buffer<CR>
nnoremap <silent> [unite]d :<C-u>Unite -buffer-name=files -default-action=lcd directory_mru<CR>
nnoremap <silent> [unite]f :<C-u>Unite -buffer-name=sources source<CR>
nnoremap <silent> [unite]g :<C-u>Unite -buffer-name=vimgrep vimgrep -start-insert -keep-focus -no-quit<CR>
nnoremap <silent> [unite]hc :<C-u>Unite -buffer-name=history history/command<CR>
nnoremap <silent> [unite]hs :<C-u>Unite -buffer-name=history history/search<CR>
nnoremap <silent> [unite]hy :<C-u>Unite -buffer-name=history history/yank<CR>
nnoremap <silent> [unite]l :<C-u>Unite -buffer-name=lines line<CR>
nnoremap <silent> [unite]ma :<C-u>Unite -buffer-name=mappings mapping<CR>
nnoremap <silent> [unite]me :<C-u>Unite -buffer-name=messages output:message<CR>
nnoremap <silent> [unite]o :<C-u>Unite -buffer-name=outlines outline<CR>
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=registers register<CR>
nnoremap <silent> [unite]s :<C-u>Unite -buffer-name=files jump_point file_point buffer_tab file_rec:! file file/new file_mru<CR>
nnoremap <silent> [unite]t :<C-u>Unite -buffer-name=Twitter tweetvim<CR>
nnoremap <silent> [unite]ta :<C-u>Unite -buffer-name=tags tag tag/file<CR>

" Neocomplcache
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_max_list = 1000
if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplcache_vim_completefuncs = { 'Ref' : 'ref#complete', 'Unite' : 'unite#complete_source', 'VimFiler' : 'vimfiler#complete', 'Vinarise' : 'vinarise#complete' }

" Neosnippet
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)
imap <C-l> <Plug>(neosnippet_jump_or_expand)
set conceallevel=2 concealcursor=i

" Easymotion
let g:EasyMotion_leader_key = '<Leader>e'

" NERDCommenter
let g:NERDSpaceDelims = 1
nmap <Leader><Leader> <Plug>NERDCommenterToggle
vmap <Leader><Leader> <Plug>NERDCommenterNested

" VimFiler
nnoremap <silent> fvs :VimFilerExplorer<CR>
nnoremap <silent> fvr :VimFilerExplorer ssh://ains<CR>
nnoremap <silent> fvo :VimFilerTab<CR>
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_tree_closed_icon = '▸'
let g:vimfiler_tree_opened_icon = '▾'
let g:vimfiler_directory_display_top = 1
let g:vimfiler_preview_action = 'below'
let g:vimfiler_split_action = 'right'

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

    call smartinput#define_rule({
                \ 'at': '\s\+\%#',
                \ 'char': '<CR>',
                \ 'input': "<C-o>:call setline('.', substitute(getline('.'), '\\s\\+$', '', ''))<CR><CR>",
                \ })
endfunction
unlet s:bundle

" Smartchr
let s:bundle = neobundle#get('vim-smartchr')
function! s:bundle.hooks.on_source(bundle)
    inoremap <expr> % smartchr#one_of(' % ', '%')
    inoremap <expr> & smartchr#one_of(' & ', ' && ', '&')
    inoremap <expr> <Bar> smartchr#one_of(' <Bar> ', ' <Bar><Bar> ', '<Bar>')
    inoremap <expr> , smartchr#one_of(', ', ',')
    inoremap <expr> = smartchr#one_of(' = ', ' == ', '=')
    inoremap <expr> - smartchr#one_of(' - ', '--', '-')
    inoremap <expr> + smartchr#one_of(' + ', '++', '+')
    inoremap <expr> / smartchr#one_of(' / ', '// ', '/')
    inoremap <expr> . smartchr#loop('.', '->', ' => ')
endfunction
unlet s:bundle

" Like A IDE :)
function! s:likeIDE()
    cd %:p:h
    VimFilerExplorer -simple
    wincmd l
    TagbarToggle
    wincmd h
    " SrcExplToggle
endfunction
nnoremap <silent> <Leader>id :call <SID>likeIDE()<CR>

" Ref-vim
let g:ref_open = 'split'
let g:ref_source_webdict_cmd = 'w3m -t 4 -cols 180 -dump %s'
let g:ref_source_webdict_sites = { 'Wikipedia:ja' : 'http://ja.wikipedia.org/wiki/%s', 'Weblio' : 'http://ejje.weblio.jp/content/%s', 'Weblio-Thesaurus' : 'http://ejje.weblio.jp/english-thesaurus/content/%s'}
let g:ref_source_webdict_sites.default = 'Wikipedia:ja'

" QuickRun
let g:quickrun_config = { '_' : { 'runner' : 'vimproc', 'runner/vimproc/updatetime' : 40, 'outputter/buffer/split' : ":botright 10sp",}}

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
if !exists('g:neocomplcache_dictionary_filetype_lists')
    let g:neocomplcache_dictionary_filetype_lists = {}
endif
let neco_dic = g:neocomplcache_dictionary_filetype_lists
let neco_dic.tweetvim_say = $HOME . '/.tweetvim/screen_name'

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

" Thumbnail
nnoremap <Leader>b :Thumbnail<CR>

" Textobj-Multiblock
omap ab <Plug>(textobj-multiblock-a)
omap ib <Plug>(textobj-multiblock-i)
vmap ab <Plug>(textobj-multiblock-a)
vmap ib <Plug>(textobj-multiblock-i)

" Textobj-Operator-Replace
map _ <Plug>(operator-replace)


"-------------------------------------------------------------------------------"
" autocmd
"-------------------------------------------------------------------------------"

" VimFiler
function! s:configVimFiler()
    nmap <buffer> : <Plug>(vimfiler_toggle_mark_current_line)
    vmap <buffer> : <Plug>(vimfiler_toggle_mark_selected_lines)
    nnoremap <silent><buffer><expr> <C-t> vimfiler#do_action('tabopen')
    nnoremap <silent><buffer> / :<C-u>UniteWithCurrentDir file -buffer-name=search -default-action=vimfiler -start-insert <CR>
endfunction

" Conque
function! s:deleteConqueTerm(buffer_name)
    let term_obj = conque_term#get_instance(a:buffer_name)
    call term_obj.close()
endfunction

" Unite
function! s:configUnite()
    " Overwrite settings.
    imap <buffer> <TAB> <Plug>(unite_select_next_line)
    imap <buffer> jj <Plug>(unite_insert_leave)
    nmap <buffer> ' <Plug>(unite_quick_match_default_action)
    nmap <buffer> x <Plug>(unite_quick_match_choose_action)
    nnoremap <silent><buffer><expr> l unite#smart_map('l', unite#do_action('default'))
    nnoremap <silent><buffer><expr> t unite#do_action('tabopen')
endfunction

" Lisp
function! s:configLisp()
    nnoremap <silent> <Leader>li <Esc>:!sbcl --script %<CR>
    setlocal nocindent
    setlocal autoindent
    setlocal nosmartindent
    setlocal lisp
    setlocal lispwords=define
    let g:lisp_rainbow = 1
    let g:lisp_instring = 1
endfunction

" C/C++
function! s:configCCpp()
    " Neocomplcache-clang
    if has('mac')
        let g:neocomplcache_clang_use_library = 0
        let g:neocomplcache_clang_library_path = '/opt/local/libexec/llvm-3.3/lib/'
        let g:neocomplcache_clang_user_options = '-I /opt/local/include/ -I /opt/local/include/boost/'
        let g:neocomplcache_clang_executable_path = '/opt/local/bin/'
    endif
    NeoBundleSource cpp-vim
    NeoBundleSource neocomplcache-clang
    setlocal nosmartindent
    setlocal nocindent
    setlocal autoindent
    setlocal cindent
endfunction

" Java
function! s:configJava()
    NeoBundleSource java-api-complete
    setl omnifunc=javaapi#complete
    " inoremap <expr> <c-n> javaapi#nextRef()
    " inoremap <expr> <c-p> javaapi#prevRef()
endfunction

augroup general
    autocmd!

    " .vimrc
    autocmd BufWritePost $MYVIMRC source $MYVIMRC

    " 挿入モード解除時に自動でpasteをoff
    autocmd InsertLeave * set nopaste

    " 状態の保存と復元
    autocmd BufWinLeave ?* silent mkview!
    autocmd BufWinEnter ?* silent loadview

    " VimFiler
    autocmd FileType vimfiler call s:configVimFiler()

    " Conque
    autocmd BufWinLeave zsh* call s:deleteConqueTerm(expand('%'))

    " Unite
    autocmd FileType unite call s:configUnite()

    " Lisp
    autocmd FileType lisp call s:setLispConfig()

    " C/C++
    autocmd FileType c,cpp call s:configCCpp()

    " nask
    autocmd BufReadPre *.nas setlocal filetype=NASM

    " Arduino
    autocmd BufNewFile,BufRead *.pde,*.ino setlocal filetype=arduino

    " json
    autocmd BufRead,BufNewFile *.json setlocal filetype=json autoindent

    " Java
    autocmd BufRead,BufNewFile *.java call s:configJava()
    autocmd CompleteDone *.java call javaapi#showRef()
augroup END

" set runtimepath+=~/Dropbox/Program/Vim/NyaruLine
" set runtimepath+=~/Dropbox/Program/Vim/Pastel
" colorscheme Pastel
