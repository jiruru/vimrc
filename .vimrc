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


autocmd!
filetype off
filetype plugin indent on

" viとの互換をオフ
set nocompatible

" バックアップファイルと一時ファイル設定
if (isdirectory(expand('~/.vim_backup')))
    set backupdir=~/.vim_backup
    set directory=~/.vim_backup
endif
set backup
set writebackup     " 上書き前にバックアップ作成
set swapfile

" インデント設定
set cindent
set expandtab       " <Tab>の代わりに空白
set shiftwidth=4    " 自動インデントなどでずれる幅
set smarttab        " 行頭に<Tab>でshiftwidth分インデント
set tabstop=4       " 画面上で<Tab>文字が占める幅
set softtabstop=4   " <Tab>, <BS>が対応する空白の数

" エンコーディング関連
set charconvert=utf-8               " 文字エンコーディングに使われるexpressionを定める
set encoding=utf-8                  " vim内部で通常使用する文字エンコーディングを設定
set fileencoding=utf-8              " バッファのファイルエンコーディングを指定
set fileencodings=utf-8,euc-jp,sjis " 既存ファイルを開く際の文字コード自動判別
set fileformats=unix,mac,dos        " 改行文字設定

" 検索設定
set hlsearch    " 検索結果強調-:nohで解除
set incsearch   " インクリメンタルサーチを有効
set ignorecase  " 大文字小文字無視
set smartcase   " 大文字があれば通常の検索

" その他
set backspace=2                 " Backspaceの動作
set helplang=ja,en              " ヘルプ検索で日本語を優先
set viewoptions=cursor,folds    " :mkviewで保存する設定
set whichwrap=b,s,h,l,<,>,[,]   " カーソルを行頭、行末で止まらないようにする
set wildmenu                    " コマンドの補完候補を表示

" 折りたたみ関連
set foldenable
set foldcolumn=3            " 左側に折りたたみガイド表示$
set foldmethod=indent       " 折畳の判別
set foldtext=g:toFoldFunc() " 折りたたみ時の表示設定
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo " fold内に移動すれば自動で開く
set foldnestmax=4         " 最大折りたたみ深度$
" set foldclose=all         " fold外に移動しfoldlevelより深ければ閉じる
" set foldlevel=3           " 開いた時にどの深度から折りたたむか

" 見た目の設定
set ambiwidth=double    " マルチバイト文字や記号でずれないようにする
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


"-------------------------------------------------------------------------------"
" Functions
"-------------------------------------------------------------------------------"
" 折り畳み時表示テキスト設定用関数
function! g:toFoldFunc()
    " 折りたたみ開始行取得
    let l:line = getline(v:foldstart)

    " 行頭の空白数計算 - 空白で分割→先頭の一致部分を検索しインデックスをheadSpNumに設定
    let l:headSpNum = stridx(l:line, split(l:line, " ")[0])

    " 行頭の空白を置換
    if (l:headSpNum == 1)
        let l:line = substitute(l:line, "\ ", '-', '')
    elseif (1 < l:headSpNum)
        let l:line = substitute(l:line, "\ ", '+', '')

        " 区切りとして空白を2つ残す
        let l:i = 2
        while (l:i < l:headSpNum)
            let l:line = substitute(l:line, "\ ", '-', '')
            let l:i += 1
        endwhile
    endif

    return printf('%s %s [ %2d Lines Lv%02d ] %s', l:line, v:folddashes, (v:foldend-v:foldstart+1), v:foldlevel, v:folddashes)
endfunction

" 入力時に自動で括弧内に移動
function! g:toggleAutoBack()
    if(0 == g:autoBackState)
        inoremap {} {}<Left>
        inoremap [] []<Left>
        inoremap () ()<Left>
        inoremap "" ""<Left>
        inoremap '' ''<Left>
        inoremap <> <><Left>
        if !has('vim_starting')
            echo "AutoBack is ON"
        endif
        let g:autoBackState = 1
    else
        if(hasmapto('{}', 'i'))
            iunmap {}
        endif
        if(hasmapto('[]', 'i'))
            iunmap []
        endif
        if(hasmapto('()', 'i'))
            iunmap ()
        endif
        if(hasmapto('""', 'i'))
            iunmap ""
        endif
        if(hasmapto('''''', 'i'))
            iunmap ''
        endif
        if(hasmapto('<>', 'i'))
            iunmap <>
        endif

        if !has('vim_starting')
            echo "AutoBack is OFF"
        endif

        let g:autoBackState = 0
    endif
endfunction

" 起動時のみ自動実行
if !exists("g:autoBackState")
    " 初期値
    let g:autoBackState = 0
    call g:toggleAutoBack()
endif

" 入力時に自動で括弧を閉じる
function! g:toggleAutoPair()
    " 重くなるだけなのでOFF
    if(1 == g:autoBackState)
        call g:toggleAutoBack()
    endif

    if(0 == g:autoPairState)
        inoremap { {}
        inoremap [ []
        inoremap ( ()
        inoremap " ""
        inoremap ' ''
        inoremap < <>
        if !has('vim_starting')
            echo "AutoPair is ON"
        endif
        let g:autoPairState = 1
    else
        if(hasmapto('{', 'i'))
            iunmap {
        endif
        if(hasmapto('[', 'i'))
            iunmap [
        endif
        if(hasmapto('(', 'i'))
            iunmap (
        endif
        if(hasmapto('"', 'i'))
            iunmap "
        endif
        if(hasmapto('''', 'i'))
            iunmap '
        endif
        if(hasmapto('<', 'i'))
            iunmap <
        endif

        if !has('vim_starting')
            echo "AutoPair is OFF"
        endif

        let g:autoPairState = 0
    endif
endfunction

" 起動時のみ自動実行
if !exists("g:autoPairState")
    " 初期値
    let g:autoPairState = 0
    " call g:toggleAutoPair()
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
" smap / snoremap |    -     |  -   |       -        |     @      |  -   |    -     |
" map! / noremap! |    -     |  @   |       @        |     -      |  -   |    -     |
" imap / inoremap |    -     |  @   |       -        |     -      |  -   |    -     |
" cmap / cnoremap |    -     |  -   |       @        |     -      |  -   |    -     |
"-----------------------------------------------------------------------------------"

" <Leader>を変更
let mapleader = ","

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

" tab
noremap to :tabnew<Space>
noremap <silent> tn :tabnext<CR>
noremap <silent> tp :tabprevious<CR>

" 画面分割
noremap <F2> :split<Space>
noremap <F3> :vsplit<Space>

" バッファ移動
noremap <silent> <F4> :bprevious<CR>
noremap <silent> <F5> :bnext<CR>

" Windowサイズ変更
noremap <silent> <S-Left> :wincmd <<CR>
noremap <silent> <S-Right> :wincmd ><CR>
noremap <silent> <S-Up> :wincmd -<CR>
noremap <silent> <S-Down> :wincmd +<CR>

" 端に移動
noremap <C-h> ^
noremap <C-j> G
noremap <C-k> gg
noremap <C-l> $

" コマンドラインモードでの移動
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>

" カーソル下のwordをhelpする
nnoremap <silent> <Leader>h <C-U>:help <C-R><C-W><CR>

" 検索時に中央へ
nnoremap n nzz
nnoremap N Nzz

" 検索ハイライト消去
nnoremap <silent> <Esc><Esc> :nohlsearch<CR><Esc>

" .vimrcを開く
nnoremap <silent> <Leader>ev :tabnew $MYVIMRC<CR>

" 貼り付け設定反転
nnoremap <silent> <Leader>pp :set paste!<CR>

" 括弧補完切り替え
nnoremap <Leader>aub :call g:toggleAutoBack()<CR>
nnoremap <Leader>aup :call g:toggleAutoPair()<CR>

" 短縮形の設定
noreabbrev #b /****************************************
noreabbrev #e <Space>****************************************/


"-----------------------------------------------------------------------------------"
" Command                                                                           |
"-----------------------------------------------------------------------------------"
" バイナリで表示
command! Binary :%!xxd

" Mac の辞書.appで開く from http://qiita.com/items/6928282c5c843aad81d4
if ("Darwin" == substitute(system("uname"), "\n", "", "g"))
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
    vnoremap <silent> <Leader>do y:<C-u>MacDict<Space><C-r>*<CR>
    nnoremap <silent> <Leader>dc :<C-u>MacDictClose<CR>
    nnoremap <silent> <Leader>df :<C-u>MacDictFocus<CR>
endif


"-------------------------------------------------------------------------------"
" autocmd
"-------------------------------------------------------------------------------"
" ファイル全般に設定
augroup General
    autocmd!
    " 設定の保存と復元
    if filewritable(expand('%')) && (isdirectory(expand('~/.vim')))
        autocmd BufWinLeave ?* silent mkview
        autocmd BufWinEnter ?* silent loadview
    endif
augroup END

" .vimrc
augroup Vimrc
    autocmd!
    " .vimrcを保存した際に自動再読み込み
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
    if exists('g:Powerline_loaded')
        silent! call Pl#Load()
    endif
augroup END

" Lisp設定
augroup Lisp
    autocmd!
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
    autocmd BufRead *.lisp call s:setLispConfig()
augroup END

" C/C++設定
augroup C_Cpp
    autocmd!
    setlocal nosmartindent
    setlocal nocindent
    setlocal autoindent
    autocmd BufRead *.c,*.cpp setlocal cindent
augroup END


"-------------------------------------------------------------------------------"
" Plugin
"-------------------------------------------------------------------------------"

" neobundleが存在しない場合これ以降を読み込まない
if (!isdirectory(expand('~/.vim/bundle/neobundle.vim')))
    set statusline=%<%F\ %m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).']['.&fileformat.']'}%=%l/%L,%c%V%8P
    finish
endif

filetype off

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim
endif

call neobundle#rc(expand('~/.vim/bundle/'))

" NeoBundle 'git://github.com/Shougo/vimshell.git'
" NeoBundle 'git://github.com/h1mesuke/vim-alignta.git'
" NeoBundle 'git://github.com/t9md/vim-textmanip.git'
" NeoBundle 'git://github.com/ujihisa/neco-look.git'
" NeoBundle 'project.tar.gz'
NeoBundle 'git://github.com/Lokaltog/vim-easymotion.git'
NeoBundle 'git://github.com/Lokaltog/vim-powerline.git'
NeoBundle 'git://github.com/Shougo/neobundle.vim.git'
NeoBundle 'git://github.com/Shougo/neocomplcache.git'
NeoBundle 'git://github.com/Shougo/unite.vim.git'
NeoBundle 'git://github.com/Shougo/vimfiler.git'
NeoBundle 'git://github.com/Shougo/vimproc.git'
NeoBundle 'git://github.com/bkad/CamelCaseMotion.git'
NeoBundle 'git://github.com/kana/vim-textobj-indent.git'
NeoBundle 'git://github.com/kana/vim-textobj-user.git'
NeoBundle 'git://github.com/nathanaelkane/vim-indent-guides.git'
NeoBundle 'git://github.com/scrooloose/nerdcommenter.git'
NeoBundle 'git://github.com/thinca/vim-quickrun.git'
NeoBundle 'git://github.com/tpope/vim-surround.git'
NeoBundle 'git://github.com/vim-jp/cpp-vim.git'
NeoBundle 'git://github.com/vim-jp/vimdoc-ja.git'
NeoBundle 'git://github.com/vim-scripts/taglist.vim.git'
NeoBundle 'git://github.com/wesleyche/SrcExpl.git'
NeoBundle 'git://github.com/yuratomo/w3m.vim.git'

filetype plugin indent on

" Neocomplcache
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1

" vim-powerline
let g:Powerline_stl_path_style = 'short'

" Vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :highlight IndentGuidesOdd ctermbg=12
autocmd VimEnter,Colorscheme * :highlight IndentGuidesEven ctermbg=10
nmap <silent> <Leader>ig <Plug>IndentGuidesToggle

" vim-easymotion
let g:EasyMotion_leader_key = '<Leader>'

" NERDCommenter
let g:NERDSpaceDelims = 1
nmap ,, <Plug>NERDCommenterToggle
vmap ,, <Plug>NERDCommenterNested

" textmanip
xmap <C-y> <Plug>(textmanip-move-down)
xmap <C-u> <Plug>(textmanip-move-up)
xmap <C-i> <Plug>(textmanip-move-left)
xmap <C-o> <Plug>(textmanip-move-right)

" VimFiler
let g:vimfiler_as_default_explorer=1
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_file_icon = '-'
let g:vimfiler_marked_file_icon = '*'
let g:vimfiler_tree_closed_icon = '▸'
let g:vimfiler_tree_leaf_icon = '|'
let g:vimfiler_tree_opened_icon = '▾'
nnoremap <silent> <F6> :VimFiler -split -simple -winwidth=40 -toggle -no-quit<CR>
nnoremap <silent> <F7> :VimFilerBufferDir -quit<CR>
augroup VimFiler
    autocmd!
    if has('vim_starting') &&  !argc()
        autocmd VimEnter * VimFiler -quit
    endif
augroup END

" VimShell
" nnoremap <silent> <Leader>sh :VimShellPop<CR>
" let g:vimshell_prompt = $USER."% "
" let g:vimshell_enable_smart_case = 1
" let g:vimshell_execute_file_list = {}
" call vimshell#set_execute_file('txt,vim,c,h,cpp,d,xml,java', 'vim')
" call vimshell#set_execute_file('html,xhtml', 'gexe firefox')
" augroup VimShell
"     autocmd!
"     autocmd FileType vimshell call vimshell#altercmd#define('cl', 'clear')
"                 \|call vimshell#altercmd#define('g++', '/opt/local/bin/g++-mp-4.8 -Wall')
"                 \| call vimshell#altercmd#define('gcc', '/opt/local/bin/gcc-mp-4.8 -Wall')
"                 \| call vimshell#altercmd#define('i', 'iexe')
"                 \| call vimshell#altercmd#define('la', 'gls -ahF --color')
"                 \| call vimshell#altercmd#define('ll', 'gls -hlF --color')
"                 \| call vimshell#altercmd#define('ls', 'gls -hF --color')
"                 \| call vimshell#hook#add('chpwd', 'my_chpwd', 'g:my_chpwd')
"     function! g:my_chpwd(args, context)
"         call vimshell#execute('ls')
"     endfunction
" augroup END
