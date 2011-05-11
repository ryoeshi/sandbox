;; �ŏ��̃e�X�g
;(global-set-key #\C-9
;				#'(lambda()
;					(interactive)
;					(insert "siteinit.l����ǂݍ��񂾂�[\n")))

;; *backlog* ���I�����ɕۑ�
;(add-hook '*kill-xyzzy-hook*
;		  #'(lambda ()
;			  (save-excursion
;				(save-backlog))))

;; *backlog* ��ۑ�
(defun save-backlog ()
  (interactive)
  (save-excursion
	(let* ((b (find-buffer "*backlog*")))
	  (when b
		(set-buffer b)
		(save-buffer)))))

;; *backlog* �ǂݍ���
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
  
;; *backlog* ���N�����Ƀ��[�h
;(add-hook '*post-startup-hook*
;		  #'(lambda ()
;			  (save-excursion
;				(load-backlog))))

;;; *scratch* �ȏꍇ�� nil ��Ԃ���kill�����Ȃ�
;(add-hook '*query-kill-buffer-hook*
;		  #'(lambda ()
;			  (if (and (not *kill-buffer-kills-scratch*)
;					   (equal (buffer-name (selected-buffer))
;							  "*scratch*"))
;				  nil
;				t)))

; *scratch*��� C-x C-s ���Ă��������킹�Ȃ�
(add-hook '*save-buffer-no-filenames-hook*
		  #'(lambda ()
			  (if (equal (buffer-name (selected-buffer))
						 "*scratch*")
				  t
				nil)))

; �t���[���ύX���ɕύX��t���[������\��
(add-hook '*select-pseudo-frame-hook*
		  #'(lambda ()
			  (message "Frame: ~A" (ed::pseudo-frame-name ed::*current-pseudo-frame*))
			  ))

;; C-c b
;; siteinit.l ���R���p�C�����āA�_���v�t�@�C�����폜
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

;; URL���ۂ���������f�t�H���g�̃u���E�U�ŊJ��
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
;;; URL���ۂ���������J���i�}�E�X�p�j
;(defun open-url-mouse-point ()
;  (interactive)
;  (continue-pre-selection)
;  (goto-last-mouse-point)
;  (open-url-string))

;; life �p�̃_�~�[�H�֐�
(defun indent-rigidly (from to &optional (indent 0))
;  (message-box (format nil "~D" indent))
  (let (p)
	(goto-char from)
	(while (not (eobp))
	  (setq p (progn (skip-chars-forward " \t")
				(current-column)))
	  (smart-indentation (+ p indent))
	  (forward-line))))

;; ���͂����L�[�����邩�I��͈͂��V�t�g����
(defun self-insert-or-shift-selection ()
  (interactive)
  (if (eql (get-selection-type) nil)
	  (self-insert-command)
	(shift-selection)))

;; ���͂����L�[�����邩�I��͈͂��A���V�t�g����
(defun self-insert-or-unshift-selection ()
  (interactive)
  (if (eql (get-selection-type) nil)
	  (self-insert-command)
	(unshift-selection)))

;; C-RBtnUp�œƎ��̃|�b�v�A�b�v���j���[�ɂ��܂��B
;(defun my-apps-popup ()
;  (interactive)
;  (track-popup-menu
;   (define-popup-menu
;	 (:item nil "�s�ԍ�(&L)"
;	  'toggle-line-number)
;	 (:item nil "�X�N���[���o�[(&B)"
;	  'toggle-vscroll-bar)
;	 (:item nil "���[�h���C��(&M)"
;	  'toggle-mode-line)
;	 (:item nil "�t�@���N�V�����L�[(&F)"
;	  'toggle-function-bar)
;	 (:item nil "�܂�Ԃ�(&T)"
;	  'toggle-fold-line)
;	 (:item nil "���[�h�I�����[(&R)"
;	  'toggle-read-only)))
;  :button2)

;;; �L�[�}�b�v�̒ǉ�
;(defvar ctl-z-map (make-sparse-keymap))
;(setf (symbol-function 'ctl-z-prefix) ctl-z-map)
;; �L�[�}�b�v�̃L�[�ݒ�
;(when (boundp 'ctl-z-map)
;  (define-key ctl-z-map #\RET 'open-url-string)
;  (define-key ctl-z-map #\a 'selection-whole-buffer)
;  (global-set-key #\C-\z 'ctl-z-prefix))
;(define-key ctl-x-6-map #\n 'rename-pseudo-frame)
;(define-key *text-mode-map* #\TAB 'tab-to-tab-stop)
;(define-key *text-mode-map* #\M-s 'center-line)

;; �[��vi����}�C�i�[���[�h�ݒ�
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

;; Lisp�p�w���v�t�@�C���ǂݍ��ݏ���
(require "ref2doc")
(reference-to-docstring)
;; Lisp�p�w���v�\��
(defun describe-function-show ()
  (interactive)
  (describe-function (intern (ed::get-winhelp-topic))
					 )
  )

;; �V���{���b�N�����N�쐬�i�v senable.exe ���s�j
(defun symlink-make (target symlink)
  (interactive "f�����N��: \nF�V���{���b�N�����N��: ")
  (let ((*command-symlink* "ln.exe")
		command
		output
		)
	;; ���ʏo�̓o�b�t�@
	(setq output (get-buffer-create "*Command Output*"))
	;; �R�}���h���C������
	(setq command (merge-pathnames *command-symlink*
								   *etc-path*))
	(setq command (concat command " -s \"" target "\" \"" symlink "\""))
;	(msgbox command)
	(execute-shell-command command
						   nil
						   output)
	))

;; �W�����N�V�����쐬
(defun junction-make (dir junction)
  (interactive "D�����N��: \nF�W�����N�V������: ")
  (let ((*command-junction* "junction.exe")
		command
		output
		)
	;; ���ʏo�̓o�b�t�@
	(setq output (get-buffer-create "*Command Output*"))
	;; �R�}���h���C������
	(setq command (merge-pathnames *command-junction*
								   *etc-path*))
	(setq command (concat command " \"" junction "\" \"" dir "\""))
;	(msgbox command)
	(execute-shell-command command
						   nil
						   output)
	))

;; �W�����N�V�����폜
(defun junction-delete (junction)
  (interactive "D�W�����N�V������: ")
  (let ((*command-junction* "junction.exe")
		command
		output
		)
	;; ���ʏo�̓o�b�t�@
	(setq output (get-buffer-create "*Command Output*"))
	;; �R�}���h���C������
	(setq command (merge-pathnames *command-junction*
								   *etc-path*))
	(setq command (concat command " -d \"" junction "\""))
;	(msgbox command)
	(execute-shell-command command
						   nil
						   output)
	))

;; ����X�P�W���[���ϊ�
(defun output-kassen-schedule ()
  (interactive)
  (let ((inbuf "*scratch*")
		(outbuf "*kassen*")
		month day wday title
		subtitle area1 area2 area3 realm1 charname1 charname2 charname3
		time1 time2 time3 realm2 charname4 charname5 charname6)
	(with-output-to-buffer ((switch-to-buffer (create-new-buffer outbuf)))
	  (format t "\"����\",\"�J�n��\",\"�J�n����\",\"�I����\",\"�I������\",\"�I�������\",\"���e\",\"�ꏊ\",\"�װ� ��/��\",\"�װѓ��t\",\"�װю���\"~%")
	  (with-input-from-buffer ((switch-to-buffer inbuf))
		(while (setq line (read-line *standard-input* nil))
		  ;; 1�s��
		  (when
			  (string-match "\\([0-9]+\\)��\\([0-9]+\\)��(\\(.+\\)) \\(.*\\)" line)
			(setq month (match-string 1))
			(setq day (match-string 2))
			(setq wday (match-string 3))
			(setq title (match-string 4))
			)
		  ;; 2�s��
		  (when
			  (string-match ".*���w *\t *���w *\t *��Q�w.*" line)
			(multiple-value-setq
				(subtitle area1 area2 area3 realm1 charname1 charname2 charname3)
			  (values-list (split-string line "\t" nil " ")))
			)
		  ;; 3�s��
		  (when
			  (string-match ".*[0-9]*:[0-9]* �` [0-9]*:[0-9]*.*" line)
			(multiple-value-setq
				(time1 time2 time3 realm2 charname4 charname5 charname6)
			  (values-list (split-string line "\t" nil " ")))
			)
		  ;; ��񂪑����Ă��當���񐶐�
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
			(when (or (string-equal "�" realm1)
					  (string-equal "�" realm2))
			  (setq title (concat "��" title)))
			(format t "\"~a ~a\"," title subtitle)
			(format t "\"2010/~a/~a\"," month day)
			(format t "\"~a\"," (first (split-string time1 "�`" nil " ")))
			(format t "\"2010/~a/~a\"," month day)
			(format t "\"~a\"," (second (split-string time3 "�`" nil " ")))
			(format t "\"Off\",")		; �I���C�x���g

			;; ���e�͕����s
			(format t "\"~a <~a>�F~a - ~a~%" area1 time1 charname1 charname4)
			(format t "~a <~a>�F~a - ~a~%" area2 time2 charname2 charname5)
			(format t "~a <~a>�F~a - ~a\"," area3 time3 charname3 charname6)

			(format t "\"\",")		; �ꏊ
			(format t "\"False\",")		; �A���[�� �I���^�I�t
			(format t "\"\",")		; �A���[�����t
			(format t "\"\",")		; �A���[������
			(format t "~%")

			;; �o�͂�����A�ϐ���S�ď�����
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