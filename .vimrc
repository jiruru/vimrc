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

" viとの互換をオフ
set nocompatible

" バックアップファイルと一時ファイル設定
if isdirectory(expand('~/.vim_backup'))
    set backupdir=~/.vim_backup
    set directory=~/.vim_backup
endif
set backup
set writebackup     " 上書き前にバックアップ作成
set swapfile

" インデント設定
set backspace=2     " Backspaceの動作
set cindent
set expandtab       " <Tab>の代わりに空白
set shiftwidth=4    " 自動インデントなどでずれる幅
set smarttab        " 行頭に<Tab>でshiftwidth分インデント
set softtabstop=4   " <Tab>, <BS>が対応する空白の数
set tabstop=4       " 画面上で<Tab>文字が占める幅

" エンコーディング関連
set encoding=utf-8                          " vim内部で通常使用する文字エンコーディング
set fileencodings=utf-8,sjis,cp932,euc-jp   " 既存ファイルを開く際の文字コード自動判別
set fileformats=unix,mac,dos                " 改行文字設定

" 検索設定
set hlsearch    " 検索結果強調-:nohで解除
set incsearch   " インクリメンタルサーチを有効
set ignorecase  " 大文字小文字無視
set smartcase   " 大文字があれば通常の検索

" その他
set helplang=ja                 " ヘルプ検索で日本語を優先
set history=500                 " 検索やコマンドラインの保存履歴数
set tags=./tags,tags            " タグが検索されるファイル
set viewoptions=cursor,folds    " :mkviewで保存する設定
set viminfo='1000,<500,f1       " viminfoへの保存設定
set whichwrap=b,s,h,l,<,>,[,]   " カーソルを行頭、行末で止まらないようにする
set wildmenu                    " コマンドの補完候補を表示
" set virtualedit=all             " 文字のないところでも矩形選択を出来るようにする
let g:loaded_netrwPlugin=1      " 標準Pluginを読み込まない
let g:loaded_vimballPlugin=1


" 折りたたみ
set foldenable
set foldcolumn=3            " 左側に折りたたみガイド表示$
set foldmethod=indent       " 折畳の判別
set foldtext=g:toFoldFunc() " 折りたたみ時の表示設定
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo " fold内に移動すれば自動で開く

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
syntax on               " 強調表示有効
colorscheme desert
highlight Cursor ctermbg=55
highlight FoldColumn ctermfg=130
highlight Folded cterm=bold,underline ctermfg=14 ctermbg=55
highlight MatchParen cterm=bold,underline "ctermfg=11 ctermbg=3
highlight Search ctermbg=3 ctermfg=0
highlight TabLineSel ctermbg=5
" set runtimepath+=~/Dropbox/Program/Vim/Pastel
" colorscheme Pastel


"-------------------------------------------------------------------------------"
" Functions
"-------------------------------------------------------------------------------"
" 折り畳み時表示テキスト設定用関数
function! g:toFoldFunc()
    " 折りたたみ開始行取得
    let l:line = getline(v:foldstart)

    " 行頭の空白数計算 - 空白で分割→先頭の一致部分を検索しインデックスをheadSpNumに設定
    let l:headSpNum = stridx(l:line, split(l:line, ' ')[0])

    " 行頭の空白を置換
    if (l:headSpNum == 1)
        let l:line = substitute(l:line, '\ ', '-', '')
    elseif (1 < l:headSpNum)
        let l:line = substitute(l:line, '\ ', '+', '')

        " 区切りとして空白を2つ残す
        let l:i = 2
        while (l:i < l:headSpNum)
            let l:line = substitute(l:line, '\ ', '-', '')
            let l:i += 1
        endwhile
    endif

    return printf('%s %s [ %2d Lines Lv%02d ] %s', l:line, v:folddashes, (v:foldend-v:foldstart+1), v:foldlevel, v:folddashes)
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
" smap / snoremap |    -     |  -   |       -        |     @      |  -   |    -     |
" map! / noremap! |    -     |  @   |       @        |     -      |  -   |    -     |
" imap / inoremap |    -     |  @   |       -        |     -      |  -   |    -     |
" cmap / cnoremap |    -     |  -   |       @        |     -      |  -   |    -     |
"-----------------------------------------------------------------------------------"

" <Leader>を変更
let g:mapleader = ' '

" 矯正
inoremap <BS> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>

" 移動
noremap! <C-A> <Home>
noremap! <C-E> <End>
noremap! <C-F> <Right>
noremap! <C-B> <Left>
noremap! <C-D> <Del>
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" delete動作
inoremap <C-D> <Del>
inoremap <C-L> <ESC>

" 画面分割
noremap <Leader>sp :split<Space>
noremap <Leader>vsp :vsplit<Space>

" バッファ移動
noremap <silent> <C-x> :bprevious<CR>
noremap <silent> <C-c> :bnext<CR>

" Windowサイズ変更
noremap <silent> <S-Left> :wincmd <<CR>
noremap <silent> <S-Right> :wincmd ><CR>
noremap <silent> <S-Up> :wincmd -<CR>
noremap <silent> <S-Down> :wincmd +<CR>

" Tab操作
noremap to :tabnew<Space>
noremap <silent> <C-M> gt
noremap <silent> <C-N> gT

" 端に移動
noremap <C-J> G
noremap <C-K> gg
noremap <C-H> ^
noremap <C-L> $

" 検索とジャンプで中央へ
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap '. '.zz
nnoremap '' ''zz

" 検索ハイライト消去
nnoremap <silent> <Esc><Esc> :nohlsearch<CR><Esc>

" Yand & Paste
nnoremap Y y$
nnoremap <silent> <Leader>pp :set paste!<CR>
nnoremap <silent> cy ce<C-R>0<ESC>:let @/ = @1<CR>:noh<CR>
vnoremap <silent> cy c<C-R>0<ESC>:let @/ = @1<CR>:noh<CR>
nnoremap <silent> ciy ciw<C-R>0<ESC>:let @/ = @1<CR>:noh<CR>

" カーソル下のwordをhelpする
nnoremap <silent> <Leader>h :<C-U>help <C-R><C-W><CR>

" .vimrcを開く
nnoremap <silent> <Leader>ev :tabnew $MYVIMRC<CR>

" カレントウィンドウのカレントディレクトリを変更
nnoremap <Leader>cd :lcd %:p:h<CR>

" ctagsを作成
nnoremap <silent> <Leader>mc :!ctags -R %:p:h<CR><CR>


"-----------------------------------------------------------------------------------"
" 環境依存設定                                                                      |
"-----------------------------------------------------------------------------------"
" Macのみの設定
if "Darwin\n" == system('uname')
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

    " Macフラグ
    let s:isDarwin = 1
endif


"-------------------------------------------------------------------------------"
" Plugin
"-------------------------------------------------------------------------------"

" neobundleが存在しない場合これ以降を読み込まない
if !isdirectory(expand('~/.vim/bundle/neobundle.vim'))
    set statusline=%<%F\ %m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).']['.&fileformat.']'}%=%l/%L,%c%V%8P
    finish
endif

" NeoBundle
if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim
endif
call neobundle#rc(expand('~/.vim/bundle'))

" NeoBundle 'git://github.com/h1mesuke/vim-alignta.git'
" NeoBundle 'git://github.com/kana/vim-smartchr.git'
" NeoBundle 'git://github.com/kana/vim-textobj-indent.git'
" NeoBundle 'git://github.com/kana/vim-textobj-user.git'
" NeoBundle 'git://github.com/rhysd/unite-n3337.git'
" NeoBundle 'git://github.com/t9md/vim-textmanip.git'
" NeoBundle 'project.tar.gz'

NeoBundleFetch 'git://github.com/Shougo/neobundle.vim'
NeoBundle 'git://github.com/Lokaltog/vim-easymotion.git'
NeoBundle 'git://github.com/scrooloose/syntastic.git'
NeoBundle 'git://github.com/Shougo/vimproc.git', { 'build' : { 'mac' : 'make -f make_mac.mak', 'unix' : 'make -f make_unix.mak' } }
NeoBundle 'git://github.com/mopp/backscratcher.git'
NeoBundle 'git://github.com/scrooloose/nerdcommenter.git'
NeoBundle 'git://github.com/taku-o/vim-toggle.git'
NeoBundle 'git://github.com/tpope/vim-surround.git'
NeoBundle 'git://github.com/vim-jp/vimdoc-ja.git'
NeoBundle 'git://github.com/modsound/gips-vim.git'
NeoBundle 'git://github.com/w0ng/vim-hybrid.git'
NeoBundle 'git://github.com/supermomonga/shaberu.vim.git'
NeoBundleLazy 'git://github.com/tomasr/molokai.git'
NeoBundleLazy 'git://github.com/Shougo/neocomplcache-clang.git', { 'depends' : 'Shougo/neocomplcache' }
NeoBundleLazy 'git://github.com/Shougo/neocomplcache.git', { 'autoload' : { 'insert' : 1 } }
NeoBundleLazy 'git://github.com/Shougo/unite-outline.git', { 'depends' : 'Shougo/unite.vim' }
NeoBundleLazy 'git://github.com/Shougo/unite.vim.git', { 'depends' : ['Shougo/unite-outline', 'basyura/TweetVim'], 'autoload' : { 'commands' : 'Unite' } }
NeoBundleLazy 'git://github.com/Shougo/vimfiler.git', { 'depends' : 'Shougo/unite.vim', 'autoload' : { 'commands' : ['VimFiler', 'VimFilerTab', 'VimFilerExplorer'], 'explorer' : 1,} }
NeoBundleLazy 'git://github.com/Shougo/vinarise.git', { 'autoload' : { 'filetypes' : 'bin', 'commands' : 'Vinarise' } }

NeoBundleLazy 'git://github.com/basyura/TweetVim.git', { 'depends' : ['Shougo/unite.vim', 'basyura/twibill.vim', 'tyru/open-browser.vim'], 'autoload' : { 'commands' : ['TweetVimHomeTimeline', 'TweetVimSay']} }
NeoBundleLazy 'git://github.com/basyura/twibill.vim', { 'depends' : 'tyru/open-browser.vim'}
NeoBundleLazy 'git://github.com/mattn/excitetranslate-vim.git', { 'depends' : 'mattn/webapi-vim', 'autoload' : { 'commands' : 'ExciteTranslate' } }
NeoBundleLazy 'git://github.com/mattn/webapi-vim.git', { 'autoload' : { 'function_prefix' : 'webapi' } }
NeoBundleLazy 'git://github.com/tyru/open-browser.vim'

NeoBundleLazy 'git://github.com/majutsushi/tagbar.git', { 'autoload' : { 'commands'  : 'TagbarToggle' } }
NeoBundleLazy 'git://github.com/mattn/benchvimrc-vim.git', { 'autoload' : {'commands' : 'BenchVimrc'} }
NeoBundleLazy 'git://github.com/plasticboy/vim-markdown.git', { 'autoload' : { 'filetypes' : 'md' } }
NeoBundleLazy 'git://github.com/thinca/vim-painter.git'
NeoBundleLazy 'git://github.com/thinca/vim-quickrun.git'
NeoBundleLazy 'git://github.com/thinca/vim-ref.git', { 'autoload' : { 'insert'  : '1'} }
NeoBundleLazy 'git://github.com/vim-jp/cpp-vim.git'
NeoBundleLazy 'git://github.com/wesleyche/SrcExpl.git', { 'autoload' : { 'commands' : ['SrcExplToggle', 'SrcExpl', 'SrcExplClose'] } }
NeoBundleLazy 'http://conque.googlecode.com/svn/trunk/', { 'autoload' : { 'commands'  : ['ConqueTerm', 'ConqueTermSplit', 'ConqueTermTab', 'ConqueTermVSplit'] } }

if (has('python') || has('python3'))
    " pip install --user git+git://github.com/Lokaltog/powerline
    NeoBundle 'git://github.com/Lokaltog/powerline.git'
    set runtimepath+=~/.vim/bundle/powerline/powerline/bindings/vim
else
    " Powerline
    NeoBundle 'git://github.com/Lokaltog/vim-powerline.git'
    let g:Powerline_stl_path_style = 'short'

    " PowerLineの再読み込み
    if exists('g:Powerline_loaded')
        silent! call Pl#Load()
    endif
endif

filetype plugin indent on

NeoBundleCheck

" Unite
let g:unite_source_file_mru_limit = 50
let g:unite_cursor_line_highlight = 'TabLineSel'
let g:unite_enable_short_source_names = 1
nnoremap [unite] <Nop>
nmap f [unite]
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
nnoremap <silent> [unite]d :<C-u>Unite -buffer-name=files -default-action=lcd directory_mru<CR>
nnoremap <silent> [unite]f :<C-u>Unite source<CR>
nnoremap <silent> [unite]ma :<C-u>Unite mapping<CR>
nnoremap <silent> [unite]me :<C-u>Unite output:message<CR>
nnoremap <silent> [unite]o :<C-u>Unite outline<CR>
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> [unite]s :<C-u>Unite -buffer-name=files -no-split jump_point file_point buffer_tab file_rec:! file file/new file_mru<CR>
nnoremap <silent> [unite]t :<C-u>Unite tweetvim<CR>

" Neocomplcache
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_max_list=1000
" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" Neocomplcache-clang
if exists('s:isDarwin')
    let g:neocomplcache_clang_use_library = 0
    let g:neocomplcache_clang_library_path = '/opt/local/libexec/llvm-3.3/lib/'
    let g:neocomplcache_clang_user_options = '-I /opt/local/include/ -I /opt/local/include/boost/'
    let g:neocomplcache_clang_executable_path = '/opt/local/bin/'
endif

" Easymotion
let g:EasyMotion_leader_key = '<Leader>e'

" NERDCommenter
let g:NERDSpaceDelims = 1
nmap <Leader><Leader> <Plug>NERDCommenterToggle
vmap <Leader><Leader> <Plug>NERDCommenterNested

" VimFiler
let g:vimfiler_as_default_explorer=1
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_tree_closed_icon = '▸'
let g:vimfiler_tree_opened_icon = '▾'
let g:vimfiler_directory_display_top=1
let g:vimfiler_preview_action='below'
let g:vimfiler_split_action = 'right'
nnoremap <silent> fvs :VimFilerExplorer<CR>
nnoremap <silent> fvo :VimFilerTab<CR>

" SrcExpl
nmap <silent> <Leader>sc :SrcExplToggle<CR>
let g:SrcExpl_RefreshTime = 1
let g:SrcExpl_UpdateTags = 1
let g:SrcExpl_WinHeight = 10
let g:SrcExpl_pluginList = ["__Tag_List__", "NERD_tree_1", "Source_Explorer", "*unite*", "*vimfiler* - explorer", "__Tagbar__" ]

" TagBar
let g:tagbar_width=35
let g:tagbar_autoshowtag = 1
let g:tagbar_autofocus = 1
highlight TagbarScope ctermfg=5
highlight TagbarType cterm=bold ctermfg=55
highlight TagbarHighlight cterm=bold,underline ctermfg=1
highlight TagbarSignature ctermfg=70
nnoremap <silent> tb :<C-U>TagbarToggle<CR>

" Like A IDE :)
function! s:likeIDEMode()
    cd %:p:h
    VimFilerExplorer -simple
    wincmd l
    TagbarToggle
    wincmd h
    " SrcExplToggle
endfunction
nnoremap <silent> <Leader>id :call <SID>likeIDEMode()<CR>

" Ref-vim
let g:ref_open='split'
let g:ref_source_webdict_cmd = 'w3m -t 4 -cols 180 -dump %s'
let g:ref_source_webdict_sites = { 'Wikipedia:ja' : 'http://ja.wikipedia.org/wiki/%s', 'Weblio' : 'http://ejje.weblio.jp/content/%s', 'Weblio-Thesaurus' : 'http://ejje.weblio.jp/english-thesaurus/content/%s'}
let g:ref_source_webdict_sites.default = 'Wikipedia:ja'

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
let g:tweetvim_open_say_cmd='split'
if !exists('g:neocomplcache_dictionary_filetype_lists')
    let g:neocomplcache_dictionary_filetype_lists = {}
endif
let neco_dic = g:neocomplcache_dictionary_filetype_lists
let neco_dic.tweetvim_say = $HOME . '/.tweetvim/screen_name'

" Shaberu
let g:shaberu_user_define_say_command = 'say -v Kyoko "%%TEXT%%"'

" Gips
let g:gips_speech_via_shaberu = 1


"-------------------------------------------------------------------------------"
" autocmd
"-------------------------------------------------------------------------------"
augroup general
    autocmd!

    " .vimrc
    autocmd BufWritePost $MYVIMRC source $MYVIMRC

    " 挿入モード解除時に自動でpasteをoff
    autocmd InsertLeave * set nopaste

    " VimFiler
    autocmd FileType vimfiler nmap ; <Plug>(vimfiler_toggle_mark_current_line)
    autocmd FileType vimfiler vmap ; <Plug>(vimfiler_toggle_mark_selected_lines)

    " Conque
    function! s:delete_ConqueTerm(buffer_name)
        let term_obj = conque_term#get_instance(a:buffer_name)
        call term_obj.close()
        echo 'mopp'
    endfunction
    autocmd BufWinLeave zsh\s-\s? call <SID>delete_ConqueTerm(expand('%'))

    " Unite
    function! s:unite_my_settings()
        " Overwrite settings.
        imap <buffer> <TAB> <Plug>(unite_select_next_line)
        imap <buffer> jj <Plug>(unite_insert_leave)
        nmap <buffer> ' <Plug>(unite_quick_match_default_action)
        nmap <buffer> x <Plug>(unite_quick_match_choose_action)
        nnoremap <silent><buffer><expr> l unite#smart_map('l', unite#do_action('default'))
        nnoremap <silent><buffer><expr> t unite#do_action('tabopen')
    endfunction
    autocmd FileType unite call s:unite_my_settings()

    " 状態の保存と復元
    if filewritable(expand('%')) && (isdirectory(expand('~/.vim')))
        autocmd BufWinLeave ?* silent mkview!
        autocmd BufWinEnter ?* silent loadview
    endif

    " Lisp
    function! s:setLispConfig()
        nnoremap <silent> <Leader>li <Esc>:!sbcl --script %<CR>
        setlocal nocindent
        setlocal autoindent
        setlocal nosmartindent
        setlocal lisp
        setlocal lispwords=define
        let g:lisp_rainbow = 1
        let g:lisp_instring = 1
    endfunction
    autocmd BufReadPre *.lisp call s:setLispConfig()

    " C/C++
    function! s:setCCPPConfig()
        NeoBundleSource cpp-vim
        NeoBundleSource neocomplcache-clang
        setlocal nosmartindent
        setlocal nocindent
        setlocal autoindent
        setlocal cindent
    endfunction
    autocmd BufReadPre  *.c,*.cpp,*.h,*.hpp call s:setCCPPConfig()

    " nask
    autocmd BufReadPre  *.nas setlocal filetype=NASM
augroup END
