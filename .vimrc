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

" 検索設定
set hlsearch    " 検索結果強調-:nohで解除
set incsearch   " インクリメンタルサーチを有効

" その他
set backspace=2                 " Backspaceの動作
set helplang=ja,en              " ヘルプ検索で日本語を優先
set viewoptions=cursor,folds    " :mkviewで保存する設定
set whichwrap=b,s,h,l,<,>,[,]   " カーソルを行頭、行末で止まらないようにする
set wildmenu                    " コマンドの補完候補を表示

" 折りたたみ関連
set foldenable
set foldcolumn=2        " 左側に折りたたみガイド表示$
set foldmethod=indent
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo " fold内に移動すれば自動で開く
" set foldclose=all     " fold外に移動しfoldlevelより深ければ閉じる
" set foldlevel=3       " 開いた時にどの深度から折りたたむか
" set foldnestmax=2     " 最大折りたたみ深度$

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


"-------------------------------------------------------------------------------"
" Mapping
"-------------------------------------------------------------------------------"
" コマンド          ノーマル  挿入  コマンドライン  ビジュアル  選択  演算待ち
" map  / noremap       @       -          -             @        @       @
" cmap / cnoremap      -       -          @             -        -       -
" imap / inoremap      -       @          -             -        -       -
" nmap / nnoremap      @       -          -             -        -       -
" omap / onoremap      -       -          -             -        @       @
" vmap / vnoremap      -       -          -             @        @       -
" xmap / xnoremap      -       -          -             @        -       @
" map! / noremap!      -       @          @             -        -       -
"-------------------------------------------------------------------------------"
" <Leader>を変更
let mapleader = ","

" tab
nnoremap to :tabnew<Space>
nnoremap <silent> tn :tabnext<CR>
nnoremap <silent> tp :tabprevious<CR>

" 画面分割
noremap <F5> :split<Space>
noremap <F6> :vsplit<Space>

" Windowサイズ変更
nnoremap <silent> <S-Left> :wincmd <<CR>
nnoremap <silent> <S-Right> :wincmd ><CR>
nnoremap <silent> <S-Up> :wincmd -<CR>
nnoremap <silent> <S-Down> :wincmd +<CR>

" .vimrcを開く
nnoremap <silent> <Leader>ev :tabnew $MYVIMRC<CR>

" 検索ハイライト消去
nnoremap <silent> <Esc><Esc> :nohlsearch<CR><Esc>

" 貼り付け設定反転
nnoremap <silent> <Leader>pp :set invpaste<CR>

" 自動括弧移動切り替え
nnoremap <Leader>aub :call g:toggleAutoBack()<CR>

" 自動括弧閉じ切り替え
nnoremap <Leader>aup :call g:toggleAutoPair()<CR>

" 短縮形の設定 マップを展開しない
noreabbrev #b /****************************************
noreabbrev #e <Space>****************************************/

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
    if filewritable(expand('%'))
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
        setlocal lisp
        setlocal lispwords=define
        let g:lisp_rainbow = 1
        let g:lisp_instring = 1
    endfunction
    autocmd BufRead *.lisp call s:setLispConfig()
augroup END

" C/C++設定
augroup C_Cpp
    function! s:setC_Cpp()
        nnoremap <silent> .gcc <Esc>:!gcc %<CR>
        set cindent
        " :source ~/.vim/bundle/cpp-vim/syntax/c.vim
    endfunction
    autocmd BufRead *.c,*.cpp call s:setC_Cpp()
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
filetype plugin indent off

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim
endif

call neobundle#rc(expand('~/.vim/bundle/'))

" NeoBundle 'git://github.com/vim-scripts/taglist.vim.git'
" NeoBundle 'git://github.com/wesleyche/SrcExpl.git'
" NeoBundle 'git://github.com/wesleyche/Trinity.git'
NeoBundle 'project.tar.gz'
NeoBundle 'git://github.com/Lokaltog/vim-easymotion.git'
NeoBundle 'git://github.com/Lokaltog/vim-powerline.git'
NeoBundle 'git://github.com/Shougo/neobundle.vim.git'
NeoBundle 'git://github.com/Shougo/neocomplcache.git'
NeoBundle 'git://github.com/Shougo/unite.vim.git'
NeoBundle 'git://github.com/Shougo/vimfiler.git'
NeoBundle 'git://github.com/Shougo/vimproc.git'
NeoBundle 'git://github.com/Shougo/vimshell.git'
NeoBundle 'git://github.com/h1mesuke/vim-alignta.git'
NeoBundle 'git://github.com/nathanaelkane/vim-indent-guides.git'
NeoBundle 'git://github.com/scrooloose/nerdcommenter.git'
NeoBundle 'git://github.com/t9md/vim-textmanip.git'
NeoBundle 'git://github.com/thinca/vim-quickrun.git'
NeoBundle 'git://github.com/tpope/vim-surround.git'
NeoBundle 'git://github.com/yuratomo/w3m.vim.git'

NeoBundle 'git://github.com/vim-jp/cpp-vim.git'
NeoBundle 'git://github.com/vim-jp/vimdoc-ja.git'


filetype plugin indent on

" Neocomplcache
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1

" vim-powerline
set t_Co=256
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
xmap <C-j> <Plug>(textmanip-move-down)
xmap <C-k> <Plug>(textmanip-move-up)
xmap <C-h> <Plug>(textmanip-move-left)
xmap <C-l> <Plug>(textmanip-move-right)
xmap <Space>d <Plug>(textmanip-duplicate-down)
xmap <Space>D <Plug>(textmanip-duplicate-up)

" VimFiler
let g:vimfiler_as_default_explorer=1
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_file_icon = '-'
let g:vimfiler_marked_file_icon = '*'
let g:vimfiler_tree_closed_icon = '▸'
let g:vimfiler_tree_leaf_icon = '|'
let g:vimfiler_tree_opened_icon = '▾'
nnoremap <silent> <F9> :VimFiler -split -simple -winwidth=40 -toggle -no-quit<CR>
nnoremap <silent> <F10> :VimFilerBufferDir -quit<CR>
augroup VimFiler
    if has('vim_starting') &&  !argc()
        autocmd VimEnter * VimFiler -quit
    endif
augroup END

" VimShell
nnoremap <silent> <Leader>sh :VimShellPop<CR>
let g:vimshell_prompt = $USER."% "
let g:vimshell_enable_smart_case = 1
let g:vimshell_execute_file_list = {}
call vimshell#set_execute_file('txt,vim,c,h,cpp,d,xml,java', 'vim')
call vimshell#set_execute_file('html,xhtml', 'gexe firefox')
autocmd FileType vimshell call vimshell#altercmd#define('cl', 'clear')
            \|call vimshell#altercmd#define('g++', '/opt/local/bin/g++-mp-4.8 -Wall')
            \| call vimshell#altercmd#define('gcc', '/opt/local/bin/gcc-mp-4.8 -Wall')
            \| call vimshell#altercmd#define('i', 'iexe')
            \| call vimshell#altercmd#define('la', 'gls -ahF --color')
            \| call vimshell#altercmd#define('ll', 'gls -hlF --color')
            \| call vimshell#altercmd#define('ls', 'gls -hF --color')
            \| call vimshell#hook#add('chpwd', 'my_chpwd', 'g:my_chpwd')
function! g:my_chpwd(args, context)
    call vimshell#execute('ls')
endfunction
