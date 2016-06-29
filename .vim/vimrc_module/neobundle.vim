 " Note: Skip initialization for vim-tiny or vim-small.
 if 0 | endif

 if &compatible
   set nocompatible               " Be iMproved
 endif

 " Required:
 set runtimepath^=~/.vim/bundle/neobundle.vim/

 " Required:
 call neobundle#begin(expand('~/.vim/bundle/'))

 " Let NeoBundle manage NeoBundle
 " Required:
 NeoBundleFetch 'Shougo/neobundle.vim'

 " My Bundles here:
 " Refer to |:NeoBundle-examples|.
 " Note: You don't set neobundle setting in .gvimrc!
 NeoBundle 'thinca/vim-themis'
 " NeoBundle 'w0ng/vim-hybrid'
 NeoBundle 'jonathanfilip/vim-lucius'
 NeoBundle 'scrooloose/nerdtree'
 NeoBundle 'Shougo/unite.vim'
 NeoBundle 'Shougo/neomru.vim'
 NeoBundle 'ujihisa/unite-colorscheme'

 " コード補完
 if has('lua')
           NeoBundleLazy 'Shougo/neocomplete.vim', {
               \ 'depends' : 'Shougo/vimproc',
               \ 'autoload' : { 'insert' : 1,}
               \ }
 endif
 " NeoBundle 'marcus/rsense'
 " NeoBundle 'supermomonga/neocomplete-rsense.vim'
 
 " 静的解析
 NeoBundle 'scrooloose/syntastic'
 
 " ドキュメント参照
 NeoBundle 'thinca/vim-ref'
 NeoBundle 'yuku-t/vim-ref-ri'
 
 " メソッド定義元へのジャンプ
 NeoBundle 'szw/vim-tags'
 
 " 自動で閉じる
 NeoBundle 'tpope/vim-endwise'


 call neobundle#end()

 " Required:
 filetype plugin indent on

 " If there are uninstalled bundles found on startup,
 " this will conveniently prompt you to install them.
 NeoBundleCheck

 syntax enable
 set background=dark
 colorscheme lucius


 " -------------------------------
" Rsense
" -------------------------------
let g:rsenseHome = '/usr/local/lib/rsense-0.3'
let g:rsenseUseOmniFunc = 1

" --------------------------------
" neocomplete.vim
" --------------------------------
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.ruby = '[^.*\t]\.\w*\|\h\w*::'

" --------------------------------
" rubocop
" --------------------------------
" syntastic_mode_mapをactiveにするとバッファ保存時にsyntasticが走る
" active_filetypesに、保存時にsyntasticを走らせるファイルタイプを指定する
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['ruby'] }
let g:syntastic_ruby_checkers = ['rubocop']
