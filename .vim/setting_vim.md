### Rubosense
* wget http://cx4a.org/pub/rsense/rsense-0.3.tar.bz2
* bzip2 -dc rsense-0.3.tar.bz2 | tar xvf -D
* sudo cp -r rsense-0.3 /usr/local/lib
* sudo chmod +x /usr/local/lib/rsense-0.3/bin/rsense
* /usr/local/lib/rsense-0.3/bin/rsense version
* gem install rubocop refe2
* gem list | grep -e rubocop -e refe2
* bitclust setup

### Ctags (メソッドジャンプするやつA
* brew install ctags

### インデント設定用
* mkdir ~/.vim/indent
* touch ~/.vim/indent/ruby.vim
* touch ~/.vimrc
* 以下のやつ貼り付け
```
" tabstop: TABキーに対応する空白数を設定
" shiftwidth: 自動インデントや"<<"、">>"で動く幅の設定
" softtabstop: TABキーやBSキーを打ち込んだときに動く幅の設定
setlocal tabstop=2 shiftwidth=2 softtabstop=2
```


### neocomplete
* https://github.com/Shougo/neocomplete.vim
* :echo has("lua") の結果が0の場合はluaのインストールが必要
* brew install lua
* brew linkapps
