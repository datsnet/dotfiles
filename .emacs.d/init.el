
;; デバッグモードでの起動
(require 'cl)
;; Emacsからの回答をy/nで
(fset 'yes-or-no-p 'y-or-n-p)

;; max-lisp-eval-depth対策
(setq max-lisp-eval-depth 1000)
(setq max-specpdl-size 6000)


;; スタートアップメッセージを非表示
(setq inhibit-startup-screen t)

;; Emacs 23より前のバージョンを利用している方は
;; user-emacs-directory変数が未定義のため次の設定を追加
(when (> emacs-major-version 23)
  (defvar user-emacs-directory "~/.emacs.d"))

;; ファイル保存
;; Mac OS Xの場合のファイル名の設定
(when (eq system-type 'darwin)
  (require 'ucs-normalize)
  (set-file-name-coding-system 'utf-8-hfs)
  (setq locale-coding-system 'utf-8-hfs))

;; Windowsの場合のファイル名の設定
(when (eq window-system 'w32)
  (set-file-name-coding-system 'cp932)
  (setq locale-coding-system 'cp932))


;; load-path を追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;; ターミナル以外はツールバー、スクロールバーを非表示
(when window-system
  ;; tool-barを非表示
  (tool-bar-mode 0)
  ;; scroll-barを非表示
  (scroll-bar-mode 0))

;; CocoaEmacs以外はメニューバーを非表示
(unless (eq window-system 'ns)
  ;; menu-barを非表示
  (menu-bar-mode 0))

;; 引数のディレクトリとそのサブディレクトリをload-pathに追加
(add-to-load-path "elisp" "conf" "public_repos")

;; カラム番号表示
(column-number-mode t)

;; ファイルサイズ表示
(size-indication-mode t)

;; 時計表示
(setq display-time-24hr-format t) ; 24時表示


;; バッテリー残量表示
(display-battery-mode t)

;; C-mにnewline-and-intentを割り当てる。初期値はnewline
(global-set-key (kbd "C-m") 'newline-and-indent)

(keyboard-translate ?\C-h ?\C-?)
(define-key global-map (kbd "C-x ?") 'help-command)

;; 文字コードを指定する
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

;; リージョン内の行数と文字数をモードラインに表示する（範囲指定時のみ）
(defun count-lines-and-chars ()
  (if mark-active
	  (format "%d lines,%d chars "
			  (count-lines (region-beginning) (region-end))
			  (- (region-end) (region-beginning)))
	""))

(add-to-list 'default-mode-line-format
			 '(:eval (count-lines-and-chars)))

;; beepを消す
(defun my-bell-function ()
    (unless (memq this-command
				          '(isearch-abort abort-recursive-edit exit-minibuffer
										                keyboard-quit mwheel-scroll down up next-line previous-line
														              backward-char forward-char))
	      (ding)))
(setq ring-bell-function 'my-bell-function)

;; タイトルバーにフルパスを表示
(setq frame-title-format "%f")

;; 行番号を常に表示
(global-linum-mode t)

;; TABの表示幅を指定
(setq-default tab-width 4)

(set-face-background 'region "darkgreen")
(add-to-list 'exec-path "/opt/local/bin")
(add-to-list 'exec-path "/usr/local/bin")
(add-to-list 'exec-path "~/bin")

;; タイムゾーンを設定
(setq calendar-time-zone +540)
(setq calendar-standard-time-zone-name "JST")
(setq calendar-daylight-time-zone-name "JST")


(when (require 'color-theme nil t)
  ;; テーマを読み込むための設定
  (color-theme-initialize)
  ;; テーマhoberに変更する
  (color-theme-hober))

;; Menloフォント
(set-face-attribute 'default nil
		    :family "Menlo"
		    :height 120)

;; 日本語フォント
;;(set-fontset-font
;; nil 'japanese-jisx0208
 ;; 英語名の場合
 ;; (font-spec :family "Hiragino Mincho Pro"))
;;(font-spec :family "ヒラギノ明朝 Pro"))

;; 現在行のハイライト
(defface my-hl-line-face
  ;; 背景がdarkなら背景色を紺にする
  '((((class color) (background dark))
     (:background "NavyBlue" t))
    ;; 背景色がlightなら背景色を緑にする
    (((class color) (background light))
     (:background "LightGoldenrodYellow" t))
    (t (:bold t)))
  "hl-line's my face")
(setq hl-line-face 'my-hl-line-face)
(global-hl-line-mode nil)

;; 対応する括弧のハイライト
;; paren-mode : 対応する括弧を強調して表示する
(setq show-paren-delay 0) ;  表示までの秒数。初期値は0.125
(show-paren-mode t) ; 有効化
;; parenのスタイル: expressionは括弧内も強調表示
(setq show-paren-style 'expression)
;; フェイスを変更する
(set-face-background 'show-paren-match-face nil)
(set-face-underline-p 'show-paren-match-face "yellow")
;; バックアップファイルの作成場所をシステムのTempディレクトリに変更
;;(setq backup-directory-alist
;;      '((".*" . ,temporary-file-directory)))
;; オートセーブファイルの作成場所をシステムのTempディレクトリに変更
;;(setq auto-save-file-name-transforms
;;      '((".*" ,temporary-file-directory t)))

;; auto-installの設定
(when (require 'auto-install nil t)
  ;; インストールディレクトリを指定する
  (setq auto-install-directory "~/.emacs.d/elisp/")
  ;; EmacsWikiに登録されているelispの名前を取得する
  (auto-install-update-emacswiki-package-name t)
  ;; 必要であればプロキシの設定を行う
  ;; (setq url-proxy-services '(("http" . "localhost:8339")))
  ;; install-elispの関数を利用可能にする
  (auto-install-compatibility-setup))

;; redo+の設定
(when (require 'redo+ nil t)
  ;; C-'にリドゥを割り当てる
  (global-set-key (kbd "C-'") 'redo)
  ;; 日本語キーボード用
  (global-set-key (kbd "C-.") 'redo)
  )

;; package.elの設定
(when (require 'package nil t)
  ;; パッケージリポジトリにMarmaladeと開発者運営のELPAを追加
  (add-to-list 'package-archives
			   '("marmalade" . "http://marmalade-repo.org/packages/"))
  (add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))
  ;; インストールしたパッケージロードパスを通して読み込む
  (package-initialize))

;; (auto-install-batch "anything")
(when (require 'anything nil t)
  (setq
   ;; 候補を表示するまでの時間。デフォルトは0.5
   anything-idle-delay 0.3
   ;; タイプして再描写するまでの時間。デフォルトは0.1
   anything-input-idle-delay 0.2
   ;; 候補の最大表示数。デフォルトは50
   anything-candidate-number-limit 100
   ;; 候補が多いときに体感速度を早くする
   anything-quick-update t
   ;; 候補選択ショートカットをアルファベットに
   anything-enable-shortcuts 'alphabet)

  (when (require 'anything-config nil t)
    ;; root権限でアクションを実行するときのコマンド
    ;; デフォルトは"su"
    (setq anything-su-or-sudo "sudo"))

  (require 'anything-match-plugin nil t)

  (when (and (executable-find "cmigemo")
             (require 'migemo nil t))
    (require 'anything-migemo nil t))

  (when (require 'anything-complete nil t)
    ;; lispシンボルの補完候補の再検索時間
    (anything-lisp-complete-symbol-set-timer 150))

  (require 'anything-show-completion nil t)

  (when (require 'auto-install nil t)
    (require 'anything-auto-install nil t))

;; M-yにanything-show-kill-ringを割り当てる
(define-key global-map (kbd "M-y") 'anything-show-kill-ring)

;; 要color-moccur.el
(when (require 'anything-c-moccur nil t)
  (setq
   ;; anything-c-moccur 用'anything-idle-delay'
   anything-c-moccur-anything-idle-delay 0.1
   ;; バッファの情報をハイライトする
   anything-c-moccur-enable-auto-look-flag t
   ;; 現在選択中の候補の位置を他のwindowに表示する
   anything-c-moccur-enable-initial-pattern t
   ;; 起動時にポイントの位置の単語を初期パターンにする
   anything-c-moccur-enable-initial-pattern t)
  ;; C-M-oにanything-c-moccur-occur-by-moccurを割り当てる
  (global-set-key (kbd "C-M-o") 'anything-c-moccur-occur-by-moccur))
																   
  
  (when (require 'descbinds-anything nil t)
    ;; describe-bindingsをAnythingに置き換える
    (descbinds-anything-install)))

;; auto-completeの設定
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories
			   "~/.emacs.d/elisp/ac-dict")
  (define-key ac-mode-map (kbd "ESC") 'auto-complete)
  (ac-config-default))

;; color-moccurの設定
(when (require 'color-moccur nil t)
  ;; M-oにoccur-by-moccurを割り当て
  (define-key global-map (kbd "M-o") 'occur-by-moccur)
  ;; スペース区切りでAND検索
  (setq moccur-split-word t)
  ;; ディレクトリ検索のとき除外するファイル
  (add-to-list 'dmoccur-exclusion-mask "\\.DS_Store")
  (add-to-list 'dmoccur-exclusion-mask "^#.+#$")
  ;; Migemoを利用できる場合はMigemoを利用
  (when (and (executable-find "cmigemo")
			 (require 'migemo nil t))
	(setq moccur-use-migemo t)))
;; moccur-editの設定
(require 'moccur-edit nil t)

;; moccur-edit-finish-editと同時にファイルを保存する
(defadvice moccur-edit-change-file
  (after save-after-moccur-edit-buffer activate)
  (save-buffer))

;; wgrepの設定
(require 'wgrep nil t)

;; undohistの設定
(when (require 'undohist nil t)
  (undohist-initialize))

;; undo-treeの設定
(when (require 'undo-tree nil t)
  (global-undo-tree-mode))

;; point-undoの設定
(when (require 'point-undo nil t)
 ;; (define-key global-map [f5] 'point-undo)
 ;; (define-key global-map [6] 'point-redo)
  (define-key global-map (kbd "M-[")  'point-undo)
  (define-key global-map (kbd "M-]")  'point-redo)
  )

;; Elscreenのプレフィックスキーを変更する（初期値はC-z）
;; (setq elscreen-prefix-key (kbd "C-t"))
(when (require 'elscreen nil t)
  ;; C-z C-zをタイプした場合にデフォルトのC-zを利用する
  (if window-system
	  (define-key elscreen-map (kbd "C-z") 'iconify-or-deiconify-frame)
	(define-key elscreen-map (kbd "C-z") 'suspend-emacs)))

;; 半角変換するときに変なメッセージがでるので非表示に設定
(global-set-key [M-kanji] 'ignore)

;; "C-t"でウィンドウを切り替える。初期値はtranspose-chars
(define-key global-map (kbd "C-t") 'other-window)


;; hownメモ保存場所
(setq howm-directory (concat user-emacs-directory "howm"))
;; howm-menuの言語を日本語に設定
(setq howm-menu-lang 'ja)
;; howmメモを１日１ファイルにする
; (setq howm-file-name-format "%Y/%m/%Y-%m-%d.howm")
;; howm-modeを読み込む
(when (require 'howm-mode nil t)
  ;; C-c,,でhowm-menuを起動
  (define-key global-map (kbd "C-c ,, " ) 'howm-menu))
;; howmメモを保存と同時に閉じる
(defun howm-save-buffer-and-kill ()
  "howmメモを保存と同時に閉じます。"
  (interactive)
  (when (and (buffer-file-name)
			 (string-match "\\.howm" (buffer-file-name)))
	(save-buffer)
	(kill-buffer nil)))
;; C-c C-cでメモの保存と同時にバッファを閉じる
(define-key howm-mode-map (kbd "C-c C-c") 'howm-save-buffer-and-kill)

;; cua-modeの設定
(cua-mode t) ; cua-modeをオン
(setq cua-enable-cua-keys nil) ; CUAキーバインドを無効にする

;; HTML編集のデフォルトモードをnxml-modeにする
(add-to-list 'auto-mode-alist '("\\.[sx]?html?\\(\\.[a-zA-z_]+\\)?\\'" . nxml-mode))

;; HTML5
(eval-after-load "rng-loc"
  '(add-to-list 'rng-schema-locating-files
				"~/.emacs.d/public_repos/html5-el/schemas.xml"))
(require 'whattf-dt)


;;;;;;;;;;;;;;;;;;; Ruby 設定 ;;;;;;;;;;;;;;;;;;;

;; ruby-modeのインデント設定
(setq ruby-indent-level 3    ;   インデント幅を3に、初期値は2
	  ruby-deep-indent-paren-style nil   ;   改行時のインデントを調整する
	  ;; ruby-mode実行時にindent-tabs-modeを設定値に変更
	  ruby-indent-tabs-mode t)   ; タブ文字を使用する。初期値はnil

;; 括弧の自動挿入
(require 'ruby-electric nil t)
;; endに対応する行のハイライト
(when (require 'ruby-block nil t)
  (setq ruby-block-highlight-toggle t))
;; インタラクティブRubyを利用する
(autoload 'run-ruby "inf-ruby"
  "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")

;; ruby-mode-hook用の関数を定義
(defun ruby-mode-hooks ()
  (inf-ruby-keys)
  (ruby-electric-mode t)
  (ruby-block-mode t))
;; ruby-mode-hookに追加
(add-hook 'ruby-mode-hook 'ruby-mode-hooks)
  
;; rhtml-mode設定
(when (require 'rhtml-mode nil t)
  (add-to-list 'auto-mode-alist '("\\.rhtml\\'" . rhtml-mode)))
			   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; タイムスタンプを入力
(defun insert-time ()
  (interactive)
  (insert (concat "" (format-time-string "%Y/%m/%d %H:%M:%S"))))
(global-set-key (kbd "C-x /") 'insert-time)


;;;;;;;; Flymakeモードの設定 ;;;;;;;;
(require 'flymake)
(add-hook 'c-mode-common-hook (lambda () (flymake-mode t)))

;; XML用Flymakeの設定
(defun flymake-xml-init ()
  (list "xmllint" (list "--valid"
						(flymake-init-create-temp-buffer-copy
						 'flymake-create-temp-inplace))))

;; HTML用Flymakeの設定
(defun flymake-html-init ()
  (list "tidy" (list (flymake-init-create-temp-buffer-copy
					  'flymake-create-temp-inplace))))
(add-to-list 'flymake-allowed-file-name-masks
			 '("\\.html\\'" flymake-html-init))

;; tidy error pattern
(add-to-list 'flymake-err-line-patterns
			 '("line \\([0-9]+\\) column \\([0-9]+\\) - \\(Warning\\|Error\\): \\(.*\\)"
			   nil 1 2 4))

;; JS用Flymakeの初期化関数の定義
(defun flymake-jsl-init ()
  (list "jsl" (list "-process" (flymake-init-create-temp-buffer-copy
								'flymake-create-temp-inplace))))

;; JavaScript編集でFlymakeを起動する
(add-to-list 'flymake-allowed-file-name-masks
			 '("\\.js\\'" flymake-jsl-init))
(add-to-list 'flymake-err-line-patterns
   '("^\\(.+\\)(\\([0-9]+\\)): \\(.*warning\\|SyntaxError\\): \\(.*\\)" 1 2 nil 4))

;; Ruby用Flymakeの設定
(defun flymake-ruby-init ()
  (list "ruby" (list "-c" (flymake-init-create-temp-buffer-copy
						   'flymake-create-temp-inplace))))
(add-to-list 'flymake-allowed-file-name-masks
			 '("\\.rb\\" flymake-ruby-init))
(add-to-list 'flymake-err-line-patterns
			 '("\\(.*\\):(\\([0-9]+\\)): \\(.*\\)" 1 2 nil 3))

;; Python用Flymakeの設定
;; (install-elisp "https://raw.github.com/seanfisk/emacs/sean/src/flymake-python.el")
(when (require 'flymake-python nil t)
  ;; flake8を利用する
  (setq flymake-python-syntax-checker "flake8")
  ;; pep8を利用する
  ;; (setq flymake-python-syntax-checker "pep8)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; gtags-modeのキーバインドを有効化する
(setq gtags-suggested-key-mapping t)     ; 無効化する場合はコメントアウト
(require 'gtags nil t)

;; ctags.elの設定
(require 'ctags nil t)
(setq tags-revert-without-query t)
;; ctagsを呼び出すコマンドライン
;; etags互換タグを利用する場合はコメントを外す
;; (setq ctags-command "ctags -e -R ")
;; anything-exuberant-ctags.elを利用しない場合はコメントアウトする
(setq ctags-command "ctags -R --fileds=\"+afikKlmnsSzt\" ")
(global-set-key (kbd "<f5>") 'ctags-create-or-update-tags-table)

;; AnythingからTAGSを利用しやすくするコマンドを作成
(when (and (require 'anything-exuberant-ctags nil t)
		   (require 'anything-gtags nil t))
  
  ;; anything-for-tags用のソースを定義
  (setq anything-for-tags
		(list anything-c-source-imenu
			  anything-c-source-gtags-select
			  ;; etagsを利用する場合はコメントを外す
			  ;; anything-c-source-etags-select
			  anything-c-source-exuberant-ctags-select
			  ))
  
  ;; anything-for-tagsコマンドを作成
  (defun anything-for-tags ()
	"Preconfigured `anything' for anything-for-tags."
	(interactive)
	(anything anything-for-tags
			  (thing-at-point 'symbol)
			  nil nil nil "*anything for tags*"))
  
  ;; M-tにanything-for-tagを割り当て
  (define-key global-map (kbd "M-t") 'anything-for-tags))


;; emoji.el　絵文字
(require 'emoji nil t)

;;;;;;;;;;  バージョン管理設定 ;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;; Subversion 設定 ;;;;;;;;;;;;;

;; Subversionフロントエンドpsvnの設定
(when (executable-find "svn")
  (setq svn-status-verbose nil)
  (autoload 'svn-status "psvn" "Run `svn status' . " t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;  Git 設定  ;;;;;;;;;;;;;;;;;

;; GitフロントエンドEggの設定
;;(when (executable-find "git")
;;  (require 'egg nil t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; multi-termの設定
(when (require 'multi-term nil t)
  ;; 使用するシェルを指定
  (setq multi-term-program "/usr/local/bin/zsh"))

;;(setq explicit-shell-file-name "c:\\cygwin\\bin\\bash.exe")
;;(modify-coding-system-alist 'process "shell" '(undecided-dos . sjis-unix))

;; TRAMPでバックアップファイルを作成しない
(add-to-list 'backup-directory-alist
			 (cons tramp-file-name-regexp nil))

;; WoMan設定
;; キャッシュを作成
(setq woman-cache-file-name "~/.emacs.d/.wmncach.el")
;; manパスを設定
(setq woman-manpath '("/usr/share/man"
					  "/usr/local/share/man"
					  "/usr/local/share/ja"))

;; anything-for-document用のソースを定義
(setq anything-for-document-sources
	  (list anything-c-source-man-pages
			anything-c-source-info-cl
			anything-c-source-info-pages
			anything-c-source-info-elisp
			anything-c-source-apropos-emacs-commands
			anything-c-source-apropos-emacs-functions
			anything-c-source-apropos-emacs-variables))

;; anything-for-documentコマンドを作成
(defun anything-for-document ()
  "Preconfigured `anything` for anything-for-document."
  (interactive)
  (anything anything-for-document-sources
			(thing-at-point 'symbol) nil nil nil
			"*anything for document*"))
;; Command+dにanything-for-documentを割り当て
(define-key global-map (kbd "s-d") 'anything-for-document)


;; shell-pop
;; C-x tでshellをポップアップ
(require 'shell-pop)
(shell-pop-set-internal-mode "ansi-term")
(shell-pop-set-internal-mode-shell "/bin/zsh")
(defvar ansi-term-after-hook nil)
(add-hook 'ansi-term-after-hook
		            '(lambda ()
					                (define-key term-raw-map "\C-t" 'shell-pop)))
(defadvice ansi-term (after ansi-term-after-advice (org))
    "run hook as after advice"
	  (run-hooks 'ansi-term-after-hook))
(ad-activate 'ansi-term)
(global-set-key (kbd "C-x t") 'shell-pop)1021


;; lcomp
(require 'lcomp)
(lcomp-install)


;; emacsclientの設定
(require 'server)
(unless (server-running-p)
(server-start))
(defun iconify-emacs-when^server-is-done ()
  (unless server-clients (iconify-frame)))
;; 編集が終了したらEmacsをアイコン化する
(add-hook 'server-done-hook 'iconify-emacs-when^server-is-done)
;; C-x C-cに割り当てる
(global-set-key (kbd "C-x C-c") 'server-edit)
;; M-x exitでEmacsを終了できるようにする
(defalias 'exit 'save-buffers-kill-emacs)


;; navi2ch 2チャンネルブラウザ
;; http://navi2ch.sourceforge.net/
(require 'navi2ch)
(setq navi2ch-article-exist-message-range '(1 . 1000))  ; 既存スレ
(setq navi2ch-article-new-message-range '(1000 . 1))   ; 新スレ
;; Boardモードのレス数欄にレスの増加数を表示する
(setq navi2ch-board-insert-subject-with-diff t)
;; Boardモードのレス数欄にレスの未読数を表示する
(setq navi2ch-board-insert-subject-with-unread t)
;; 板一覧のカテゴリをデフォルトで全て開いて表示する
(setq navi2ch-list-init-open-category t)
;; スレをexpire(削除)しない
(setq navi2ch-board-expire-date nil)
;; 履歴の行数を制限しない
(setq navi2ch-history-max-line nil)

