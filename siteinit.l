;; 最初のテスト
;(global-set-key #\C-9
;				#'(lambda()
;					(interactive)
;					(insert "siteinit.lから読み込んだよー\n")))

;; *backlog* を終了時に保存
;(add-hook '*kill-xyzzy-hook*
;		  #'(lambda ()
;			  (save-excursion
;				(save-backlog))))

;; *backlog* を保存
(defun save-backlog ()
  (interactive)
  (save-excursion
	(let* ((b (find-buffer "*backlog*")))
	  (when b
		(set-buffer b)
		(save-buffer)))))

;; *backlog* 読み込み
(defun load-backlog ()
  (interactive)
  (when (null (find-buffer "*backlog*"))
	(set-buffer (create-new-buffer "*backlog*"))
;	(insert-file-contents "~/scratch" t)
	(insert-file-contents "//ume/takashi/scratch" t)
;	(set-buffer-file-name "~/scratch")
	(set-buffer-file-name "//ume/takashi/scratch")
	(make-local-variable 'make-backup-files)
	(setq make-backup-files nil)))
  
;; *backlog* を起動時にロード
;(add-hook '*post-startup-hook*
;		  #'(lambda ()
;			  (save-excursion
;				(load-backlog))))

;;; *scratch* な場合は nil を返してkillさせない
;(add-hook '*query-kill-buffer-hook*
;		  #'(lambda ()
;			  (if (and (not *kill-buffer-kills-scratch*)
;					   (equal (buffer-name (selected-buffer))
;							  "*scratch*"))
;				  nil
;				t)))

; *scratch*上で C-x C-s しても何も言わせない
(add-hook '*save-buffer-no-filenames-hook*
		  #'(lambda ()
			  (if (equal (buffer-name (selected-buffer))
						 "*scratch*")
				  t
				nil)))

; フレーム変更時に変更先フレーム名を表示
(add-hook '*select-pseudo-frame-hook*
		  #'(lambda ()
			  (message "Frame: ~A" (ed::pseudo-frame-name ed::*current-pseudo-frame*))
			  ))

;; C-c b
;; siteinit.l をコンパイルして、ダンプファイルを削除
(defun compile-and-delete-dump-file ()
  (interactive)
  (and (find-buffer "siteinit.l")
	   (eval-buffer "siteinit.l"))
  (and (file-exist-p (concat (si:system-root) "site-lisp/siteinit.lc"))
	   (byte-compile-file
		(concat (si:system-root) "site-lisp/siteinit.l")))
  (let ((dumpfile
		 (concat (si:system-root) "xyzzy.w"
				 (case (os-platform)
				   (windows-2000 "2k")
				   (windows-nt "nt")
				   (windows-98 "98")
				   (windows-95 "95")
				   (windows-xp "xp")
				   (t "nt")))))
	(and (file-exist-p dumpfile)
		 (delete-file dumpfile))))
(global-set-key '(#\C-c #\b) 'compile-and-delete-dump-file)

;; URLっぽい文字列をデフォルトのブラウザで開く
;(defun open-url-string ()
;  (interactive)
;  (let* ((def (point)) url)
;	(skip-chars-backward "-a-zA-Z0-9_/~.#@%?&=;+(),'$!*:")
;	(when (looking-at ed::*url-scheme-regexp*)
;	  (setq url (buffer-substring (point)
;								  (progn
;									(goto-char (match-end 0))
;									(skip-chars-forward "-a-zA-Z0-9_/~.#@%?&=;+(),'$!*:")
;									(point))))
;	  (shell-execute url t))
;	(goto-char def)))
;;; URLっぽい文字列を開く（マウス用）
;(defun open-url-mouse-point ()
;  (interactive)
;  (continue-pre-selection)
;  (goto-last-mouse-point)
;  (open-url-string))

;; life 用のダミー？関数
(defun indent-rigidly (from to &optional (indent 0))
;  (message-box (format nil "~D" indent))
  (let (p)
	(goto-char from)
	(while (not (eobp))
	  (setq p (progn (skip-chars-forward " \t")
				(current-column)))
	  (smart-indentation (+ p indent))
	  (forward-line))))

;; 入力したキーを入れるか選択範囲をシフトする
(defun self-insert-or-shift-selection ()
  (interactive)
  (if (eql (get-selection-type) nil)
	  (self-insert-command)
	(shift-selection)))

;; 入力したキーを入れるか選択範囲をアンシフトする
(defun self-insert-or-unshift-selection ()
  (interactive)
  (if (eql (get-selection-type) nil)
	  (self-insert-command)
	(unshift-selection)))

;; C-RBtnUpで独自のポップアップメニューにします。
;(defun my-apps-popup ()
;  (interactive)
;  (track-popup-menu
;   (define-popup-menu
;	 (:item nil "行番号(&L)"
;	  'toggle-line-number)
;	 (:item nil "スクロールバー(&B)"
;	  'toggle-vscroll-bar)
;	 (:item nil "モードライン(&M)"
;	  'toggle-mode-line)
;	 (:item nil "ファンクションキー(&F)"
;	  'toggle-function-bar)
;	 (:item nil "折り返し(&T)"
;	  'toggle-fold-line)
;	 (:item nil "リードオンリー(&R)"
;	  'toggle-read-only)))
;  :button2)

;;; キーマップの追加
;(defvar ctl-z-map (make-sparse-keymap))
;(setf (symbol-function 'ctl-z-prefix) ctl-z-map)
;; キーマップのキー設定
;(when (boundp 'ctl-z-map)
;  (define-key ctl-z-map #\RET 'open-url-string)
;  (define-key ctl-z-map #\a 'selection-whole-buffer)
;  (global-set-key #\C-\z 'ctl-z-prefix))
;(define-key ctl-x-6-map #\n 'rename-pseudo-frame)
;(define-key *text-mode-map* #\TAB 'tab-to-tab-stop)
;(define-key *text-mode-map* #\M-s 'center-line)

;; 擬似vi操作マイナーモード設定
(defvar-local vi-mouse-mode nil)
(defvar *vi-mouse-map*
  (let ((keymap (make-sparse-keymap)))
	(define-key keymap #\h 'backward-char)
	(define-key keymap #\M-\h 'selection-backward-char)
	(define-key keymap #\M-\C-\h 'selection-backward-word)
	(define-key keymap #\i 'vi-mouse-mode)
	(define-key keymap #\j 'next-virtual-line)
	(define-key keymap #\M-\j 'selection-next-virtual-line)
	(define-key keymap #\k 'previous-virtual-line)
	(define-key keymap #\M-\k 'selection-previous-virtual-line)
	(define-key keymap #\l 'forward-char)
	(define-key keymap #\M-\l 'selection-forward-char)
	(define-key keymap #\M-\C-\l 'selection-forward-word)
	(define-key keymap #\o 'vi-mouse-mode)
	(define-key keymap #\p 'paste-from-clipboard)
	(define-key keymap #\y 'copy-selection-to-clipboard)
;	(define-key keymap #\SPC 'spc-mouse-left-press)
	(define-key keymap #\C-\; 'quit)
	keymap))
(defun vi-mouse-mode (&optional (arg nil sv))
  (interactive "p")
  (ed::toggle-mode 'vi-mouse-mode arg sv)
  (if vi-mouse-mode
	  (set-minor-mode-map *vi-mouse-map*)
	(unset-minor-mode-map *vi-mouse-map*))
  (update-mode-line t))
(pushnew '(vi-mouse-mode . "vi-mouse") *minor-mode-alist* :key #'car)

;; Lisp用ヘルプファイル読み込み処理
(require "ref2doc")
(reference-to-docstring)
;; Lisp用ヘルプ表示
(defun describe-function-show ()
  (interactive)
  (describe-function (intern (ed::get-winhelp-topic))
					 )
  )

;; シンボリックリンク作成（要 senable.exe 実行）
(defun symlink-make (target symlink)
  (interactive "fリンク先: \nFシンボリックリンク名: ")
  (let ((*command-symlink* "ln.exe")
		command
		output
		)
	;; 結果出力バッファ
	(setq output (get-buffer-create "*Command Output*"))
	;; コマンドライン生成
	(setq command (merge-pathnames *command-symlink*
								   *etc-path*))
	(setq command (concat command " -s \"" target "\" \"" symlink "\""))
;	(msgbox command)
	(execute-shell-command command
						   nil
						   output)
	))

;; ジャンクション作成
(defun junction-make (dir junction)
  (interactive "Dリンク先: \nFジャンクション名: ")
  (let ((*command-junction* "junction.exe")
		command
		output
		)
	;; 結果出力バッファ
	(setq output (get-buffer-create "*Command Output*"))
	;; コマンドライン生成
	(setq command (merge-pathnames *command-junction*
								   *etc-path*))
	(setq command (concat command " \"" junction "\" \"" dir "\""))
;	(msgbox command)
	(execute-shell-command command
						   nil
						   output)
	))

;; ジャンクション削除
(defun junction-delete (junction)
  (interactive "Dジャンクション名: ")
  (let ((*command-junction* "junction.exe")
		command
		output
		)
	;; 結果出力バッファ
	(setq output (get-buffer-create "*Command Output*"))
	;; コマンドライン生成
	(setq command (merge-pathnames *command-junction*
								   *etc-path*))
	(setq command (concat command " -d \"" junction "\""))
;	(msgbox command)
	(execute-shell-command command
						   nil
						   output)
	))

;; 合戦スケジュール変換
(defun output-kassen-schedule ()
  (interactive)
  (let ((inbuf "*scratch*")
		(outbuf "*kassen*")
		month day wday title
		subtitle area1 area2 area3 realm1 charname1 charname2 charname3
		time1 time2 time3 realm2 charname4 charname5 charname6)
	(with-output-to-buffer ((switch-to-buffer (create-new-buffer outbuf)))
	  (format t "\"件名\",\"開始日\",\"開始時刻\",\"終了日\",\"終了時刻\",\"終日ｲﾍﾞﾝﾄ\",\"内容\",\"場所\",\"ｱﾗｰﾑ ｵﾝ/ｵﾌ\",\"ｱﾗｰﾑ日付\",\"ｱﾗｰﾑ時刻\"~%")
	  (with-input-from-buffer ((switch-to-buffer inbuf))
		(while (setq line (read-line *standard-input* nil))
		  ;; 1行目
		  (when
			  (string-match "\\([0-9]+\\)月\\([0-9]+\\)日(\\(.+\\)) \\(.*\\)" line)
			(setq month (match-string 1))
			(setq day (match-string 2))
			(setq wday (match-string 3))
			(setq title (match-string 4))
			)
		  ;; 2行目
		  (when
			  (string-match ".*第壱陣 *\t *第弐陣 *\t *第参陣.*" line)
			(multiple-value-setq
				(subtitle area1 area2 area3 realm1 charname1 charname2 charname3)
			  (values-list (split-string line "\t" nil " ")))
			)
		  ;; 3行目
		  (when
			  (string-match ".*[0-9]*:[0-9]* ～ [0-9]*:[0-9]*.*" line)
			(multiple-value-setq
				(time1 time2 time3 realm2 charname4 charname5 charname6)
			  (values-list (split-string line "\t" nil " ")))
			)
		  ;; 情報が揃ってたら文字列生成
		  (when (not (find t
						   (mapcar #'(lambda (foo)
									   (null foo))
								   (list
									month day wday
									title subtitle
									area1 area2 area3
									realm1 charname1 charname2 charname3
									time1 time2 time3
									realm2 charname4 charname5 charname6
									)
								   )))
			(when (or (string-equal "蜀" realm1)
					  (string-equal "蜀" realm2))
			  (setq title (concat "○" title)))
			(format t "\"~a ~a\"," title subtitle)
			(format t "\"2010/~a/~a\"," month day)
			(format t "\"~a\"," (first (split-string time1 "～" nil " ")))
			(format t "\"2010/~a/~a\"," month day)
			(format t "\"~a\"," (second (split-string time3 "～" nil " ")))
			(format t "\"Off\",")		; 終日イベント

			;; 内容は複数行
			(format t "\"~a <~a>：~a - ~a~%" area1 time1 charname1 charname4)
			(format t "~a <~a>：~a - ~a~%" area2 time2 charname2 charname5)
			(format t "~a <~a>：~a - ~a\"," area3 time3 charname3 charname6)

			(format t "\"\",")		; 場所
			(format t "\"False\",")		; アラーム オン／オフ
			(format t "\"\",")		; アラーム日付
			(format t "\"\",")		; アラーム時刻
			(format t "~%")

			;; 出力したら、変数を全て初期化
			(multiple-value-setq
				(month day wday
					   title subtitle
					   area1 area2 area3
					   realm1 charname1 charname2 charname3
					   time1 time2 time3
					   realm2 charname4 charname5 charname6
					   )
			  '(nil))
			)
		  )
		)
	  )
	)
  )
