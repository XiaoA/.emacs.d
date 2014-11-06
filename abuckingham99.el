;;Who doesn't love packages?
(require 'package)
(add-to-list 'package-archives 
    '("marmalade" .
      "http://marmalade-repo.org/packages/"))
(package-initialize)

(add-to-list 'package-archives                                                  
             '("melpa" . "http://melpa.milkbox.net/packages/") t)               
(package-initialize)

;; Multiple Cursors
;; (Magnar is an Emacs god!)
;; https://github.com/magnars |http://www.emacsrocks.com 
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C->") 'mc/mark-all-words-like-this)

;; Goal columns are useful!
;; Enable set-goal-column
(put 'set-goal-column 'disabled nil)

;; UI Tweaks
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'fringe-mode) (fringe-mode -1))

;; type "y"/"n" instead of "yes"/"no"
(fset 'yes-or-no-p 'y-or-n-p)

;;Set up my custom.el file
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; Use web-mode whenever possible...
(setq auto-mode-alist (cons '("\\.aspx$" . web-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.erb$" . web-mode) auto-mode-alist))

;; Byte Recompile
(defun ab/byte-recompile ()
  (interactive)
  (byte-recompile-directory "~/.emacs.d" 0)

;; Increment Number at Point
;;Got this from EmacsWiki; enables incremental numbers. First input
  ;; numbers and then use this!
  (defun ab/increment-number-at-point ()
      (interactive)
      (skip-chars-backward "0123456789")
      (or (looking-at "[0123456789]+")
          (error "No number at point"))
      (replace-match (number-to-string (1+ (string-to-number (match-string 0)))))))

;; Paren-Mode
(require 'paren)
(show-paren-mode t)

;; A great tip from Steve Yegge. Because Alt-x is too awkward...
(global-set-key "\C-x\C-m" 'execute-extended-command)

;; It's more convenient to press 'Return' to follow a link from Org an C-c C-l.
(setq org-return-follows-link t)

;; Set up Org-Mode
(add-to-list 'auto-mode-alist '("\\.org\\’" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-log-done t)

;;  Make yasnippet work properly with org-mode. 
;;  (defun yas/org-very-safe-expand ()
;;    (let ((yas/fallback-behavior 'return-nil)) (yas/expand)))

(defun yas-org-very-safe-expand ()
  (let ((yas-fallback-behavior 'return-nil))
    (and (fboundp 'yas-expand) (yas-expand))))

(add-hook 'org-mode-hook
          (lambda ()
            (add-to-list 'org-tab-first-hook
                         'yas-org-very-safe-expand)
            ))

(add-hook 'org-mode-hook
          (lambda ()
            (local-set-key "\M-\C-n" 'outline-next-visible-heading)
            (local-set-key "\M-\C-p" 'outline-previous-visible-heading)
            (local-set-key "\M-\C-u" 'outline-up-heading)
            ;; table
            (local-set-key "\M-\C-w" 'org-table-copy-region)
            (local-set-key "\M-\C-y" 'org-table-paste-rectangle)
            (local-set-key "\M-\C-l" 'org-table-sort-lines)
            ;; display images
            (local-set-key "\M-I" 'org-toggle-iimage-in-org)
            ;; yasnippet (using the new org-cycle hooks)
            ;;(make-variable-buffer-local 'yas/trigger-key)
            ;;(setq yas/trigger-key [tab])
            ;;(add-to-list 'org-tab-first-hook 'yas/org-very-safe-expand)
            ;;(define-key yas/keymap [tab] 'yas/next-field)
            ))

(setq org-use-speed-commands t)

;; Org-Mode Code Blocks
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (sh . t)
     (R . t)
     (perl . t)
     (ruby . t)
     (python . t)
     (js . t)
     (haskell . t)))

(add-to-list 'org-src-lang-modes
             '("r" . ess-mode))

;; Code block fontification
  (setq org-src-fontify-natively t)
  (setq org-src-tab-acts-natively t)

;; Don't ask for confirmation on every =C-c C-c= code-block compile. 
  (setq org-confirm-babel-evaluate nil)

;; Ensure the Latest Org-mode manual is in the info directory
  (unless (boundp 'Info-directory-list)
    (setq Info-directory-list Info-default-directory-list))
  (setq Info-directory-list
        (cons (expand-file-name
               "doc"
               (expand-file-name
                "org"
                (expand-file-name "src" dotfiles-dir)))
              Info-directory-list))

;; It's silly, I know, but why not let Emacs greet me...? ;)
  (message "Welcome back, Andrew. Are you ready to save the world?")

;; Let's keep our files in Dropbox
(setq org-directory "~/Dropbox/org")
(setq org-default-notes-file "~/Dropbox/org/refile.org")
(global-set-key (kbd "C-c c") 'org-capture)

;; Keybinding for just-one-space
;; recommended by Bozhidar: http://emacsredux.com/blog/2013/05/19/delete-whitespace-around-point/
(global-set-key (kbd "C-c j") 'just-one-space)

(add-to-list 'load-path "~/.emacs.d/elpa/yasnippet")
    (require 'yasnippet) ;; not yasnippet-bundle
    (yas-global-mode 1)

;; Load my snippets
(add-to-list 'load-path "~/.emacs.d/snippets/web-mode/")
(add-to-list 'load-path "~/.emacs.d/snippets/markdown-mode/")
(add-to-list 'load-path "~/.emacs.d/snippets/org-mode")

;;Load Popup-Snippets
(add-to-list 'load-path "~/.emacs.d/vendor/")

(require 'popup)
;; add some shotcuts in popup menu mode
(define-key popup-menu-keymap (kbd "M-n") 'popup-next)
(define-key popup-menu-keymap (kbd "TAB") 'popup-next)
(define-key popup-menu-keymap (kbd "<tab>") 'popup-next)
(define-key popup-menu-keymap (kbd "<backtab>") 'popup-previous)
(define-key popup-menu-keymap (kbd "M-p") 'popup-previous)

(defun yas/popup-isearch-prompt (prompt choices &optional display-fn)
  (when (featurep 'popup)
    (popup-menu*
     (mapcar
      (lambda (choice)
        (popup-make-item
         (or (and display-fn (funcall display-fn choice))
             choice)
         :value choice))
      choices)
     :prompt prompt
     ;; start isearch mode immediately
     :isearch t
     )))

(setq yas/prompt-functions '(yas/popup-isearch-prompt yas/no-prompt))

;; This is on hold...not really using MobileOrg now, but might change my mind later...
;; (setq org-directory "~/Dropbox/org/")
;; (setq org-mobile-directory "~/Dropbox/Apps/MobileOrg/")
;; (setq org-agenda-files (quote ("~/Dropbox/org/its-2014-2.org")))
;; (setq org-mobile-inbox-for-pull "~/Dropbox/Apps/MobileOrg/inbox.org")

(setq yas-snippet-dirs
      '("/Users/abuckingham99/.emacs.d/elpa/yasnippet-20140314.255/snippets/"
        "/Users/abuckingham99/.emacs.d/snippets/"
        ))
(yas-global-mode 1) ;; or M-x yas-reload-all if you've started YASnippet already.

;; (add-to-list 'load-path
;;               "~/.emacs.d/snippets/html-mode/")

;; Set keyboard shortcut for webjump
(global-set-key (kbd "C-x g") 'webjump)

;; Add Urban Dictionary to webjump
(eval-after-load "webjump"
'(add-to-list 'webjump-sites
              '("Urban Dictionary" .
                [simple-query
                 "www.urbandictionary.com"
                 "http://www.urbandictionary.com/define.php?term="
                 ""])))

;; Write backup files to own directory
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)

;;Source: http://rawsyntax.com/blog/learn-emacs-store-window-configuration/
(defun ab/toggle-eshell-visor ()
  "Brings up a visor like eshell buffer, filling the entire emacs frame"
  (interactive)
  (if (string= "eshell-mode" (eval 'major-mode))
      (jump-to-register :pre-eshell-visor-window-configuration)
    (window-configuration-to-register :pre-eshell-visor-window-configuration)
    (call-interactively 'eshell)
    (delete-other-windows)))

(global-set-key (kbd "C-c t") 'ab/toggle-eshell-visor)

;; (add-to-list 'load-path "/full/path/where/ace-jump-mode.el/in/")
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)

(define-key global-map (kbd "C-c j") 'ace-jump-mode)

;;enable a more powerful jump back function from ace jump mode

(autoload
  'ace-jump-mode-pop-mark
  "ace-jump-mode"
  "Ace jump back:-)"
  t)
(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))
(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)

;; Require Dired-X
(require 'dired-x)

;; Turn pasted BB Sis Integration log into a CSV file
(fset 'ab/sis-integration-log
   [?\C-c ?\C-p ?\C-n ?\M-f ?\M-d ?\M-d ?\M-d ?, ?\M-\\ ?\M-f ?, ?\M-\\ ?\M-f ?, ?\M-\\ ?\M-f ?, ?\M-\\ ?\M-f ?\M-f ?, ?\M-\\ ?\C-n ?\C-a ?\M-d ?\C-d ?\C-e ?\C-r ?s ?i ?s ?\C-m ?\C-  ?\C-s ?n ?a ?m ?e ?\C-x ?\C-m ?d ?e ?l ?e ?t ?e ?- ?r ?e ?g ?i ?o ?n ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\C-e ?\C-r ?s ?n ?a ?p ?s ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\C-e ?\C-r ?a ?c ?t ?i ?v ?e ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\M-f ?\M-\\ ?\C-e ?\M-b ?\M-b ?\M-f ?, ?\M-\\ ?\C-n ?\C-a ?\M-d ?\C-d ?\C-e ?\C-r ?s ?i ?s ?\C-m ?\C-  ?\C-s ?n ?a ?m ?e ?\C-x ?\C-m ?d ?e ?l ?e ?t ?e ?- ?r ?e ?g ?i ?o ?n ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\C-e ?\C-r ?s ?n ?a ?p ?s ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\C-e ?\C-r ?a ?c ?t ?i ?v ?e ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\M-f ?\M-\\ ?\C-e ?\M-b ?\M-b ?\M-f ?, ?\M-\\ ?\C-n ?\C-a ?\M-d ?\C-d ?\C-e ?\C-r ?s ?i ?s ?\C-m ?\C-  ?\C-s ?n ?a ?m ?e ?\C-x ?\C-m ?d ?e ?l ?e ?t ?e ?- ?r ?e ?g ?i ?o ?n ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\C-e ?\C-r ?s ?n ?a ?p ?s ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\C-e ?\C-r ?a ?c ?t ?i ?v ?e ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\M-f ?\M-\\ ?\C-e ?\M-b ?\M-b ?\M-f ?, ?\M-\\ ?\C-n ?\C-a ?\M-d ?\C-d ?\C-e ?\C-r ?s ?i ?s ?\C-m ?\C-  ?\C-s ?n ?a ?m ?e ?\C-x ?\C-m ?d ?e ?l ?e ?t ?e ?- ?r ?e ?g ?i ?o ?n ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\C-e ?\C-r ?s ?n ?a ?p ?s ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\C-e ?\C-r ?a ?c ?t ?i ?v ?e ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\M-f ?\M-\\ ?\C-e ?\M-b ?\M-b ?\M-f ?, ?\M-\\ ?\C-n ?\C-a ?\M-d ?\C-d ?\C-e ?\C-r ?s ?i ?s ?\C-m ?\C-  ?\C-s ?n ?a ?m ?e ?\C-x ?\C-m ?d ?e ?l ?e ?t ?e ?- ?r ?e ?g ?i ?o ?n ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\C-e ?\C-r ?s ?n ?a ?p ?s ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\C-e ?\C-r ?a ?c ?t ?i ?v ?e ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\M-f ?\M-\\ ?\C-e ?\M-b ?\M-b ?\M-f ?, ?\M-\\ ?\C-n ?\C-a ?\M-d ?\C-d ?\C-e ?\C-r ?s ?i ?s ?\C-m ?\C-  ?\C-s ?n ?a ?m ?e ?\C-x ?\C-m ?d ?e ?l ?e ?t ?e ?- ?r ?e ?g ?i ?o ?n ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\C-e ?\C-r ?s ?n ?a ?p ?s ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\C-e ?\C-r ?a ?c ?t ?i ?v ?e ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\M-f ?\M-\\ ?\C-e ?\M-b ?\M-b ?\M-f ?, ?\M-\\ ?\C-n ?\C-a ?\M-d ?\C-d ?\C-e ?\C-r ?s ?i ?s ?\C-m ?\C-  ?\C-s ?n ?a ?m ?e ?\C-x ?\C-m ?d ?e ?l ?e ?t ?e ?- ?r ?e ?g ?i ?o ?n ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\C-e ?\C-r ?s ?n ?a ?p ?s ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\C-e ?\C-r ?a ?c ?t ?i ?v ?e ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\M-f ?\M-\\ ?\C-e ?\M-b ?\M-b ?\M-f ?, ?\M-\\ ?\C-n ?\C-a ?\M-d ?\C-d ?\C-e ?\C-r ?s ?i ?s ?\C-m ?\C-  ?\C-s ?n ?a ?m ?e ?\C-x ?\C-m ?d ?e ?l ?e ?t ?e ?- ?r ?e ?g ?i ?o ?n ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\C-e ?\C-r ?s ?n ?a ?p ?s ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\C-e ?\C-r ?a ?c ?t ?i ?v ?e ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\M-f ?\M-\\ ?\C-e ?\M-b ?\M-b ?\M-f ?, ?\M-\\ ?\C-n ?\C-a ?\M-d ?\C-d ?\C-e ?\C-r ?s ?i ?s ?\C-m ?\C-  ?\C-s ?n ?a ?m ?e ?\C-x ?\C-m ?d ?e ?l ?e ?t ?e ?- ?r ?e ?g ?i ?o ?n ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\C-e ?\C-r ?s ?n ?a ?p ?s ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\C-e ?\C-r ?a ?c ?t ?i ?v ?e ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\M-f ?\M-\\ ?\C-e ?\M-b ?\M-b ?\M-f ?, ?\M-\\ ?\C-n ?\C-a ?\M-d ?\C-d ?\C-e ?\C-r ?s ?i ?s ?\C-m ?\C-  ?\C-s ?n ?a ?m ?e ?\C-x ?\C-m ?d ?e ?l ?e ?t ?e ?- ?r ?e ?g ?i ?o ?n ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\C-e ?\C-r ?s ?n ?a ?p ?s ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\C-e ?\C-r ?a ?c ?t ?i ?v ?e ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\M-f ?\M-\\ ?\C-e ?\M-b ?\M-b ?\M-f ?, ?\M-\\ ?\C-n ?\C-a ?\M-d ?\C-d ?\C-e ?\C-r ?s ?i ?s ?\C-m ?\C-  ?\C-s ?n ?a ?m ?e ?\C-x ?\C-m ?d ?e ?l ?e ?t ?e ?- ?r ?e ?g ?i ?o ?n ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\C-e ?\C-r ?s ?n ?a ?p ?s ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\C-e ?\C-r ?a ?c ?t ?i ?v ?e ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\M-f ?\M-\\ ?\C-e ?\M-b ?\M-b ?\M-f ?, ?\M-\\ ?\C-n ?\C-a ?\M-d ?\C-d ?\C-e ?\C-r ?s ?i ?s ?\C-m ?\C-  ?\C-s ?n ?a ?m ?e ?\C-x ?\C-m ?d ?e ?l ?e ?t ?e ?- ?r ?e ?g ?i ?o ?n ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\C-e ?\C-r ?s ?n ?a ?p ?s ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\C-e ?\C-r ?a ?c ?t ?i ?v ?e ?\C-m ?\M-b ?\M-f ?, ?\M-\\ ?\M-f ?\M-\\ ?\C-e ?\M-b ?\M-b ?\M-f ?, ?\M-\\ ?\C-n ?\C-a])

;; ab/sis-1
;; Remove all of the unnecessary text and whitespace, and format the line as csv
(fset 'ab/sis-1
   "\C-a\C-c\C-p\C-sselect sis\C-m\C-a\344\C-d\C-sname\C-m\346\342\C-o\C-rsis\C-m\342\346,\C-k\C-k\C-e\C-rsnap\C-m\342\346,\334\C-sfile\C-m,\334\346,\334\C-e\342\346\342\342\346,\334\C-n\C-a")

;; ab/sis-2
;; Create the column headers for the csv file
(fset 'ab/sis-2
   [?\C-a ?\C-c ?\C-p ?\C-n ?\C-o ?\C-n ?N ?a ?m ?e ?, ?D ?e ?s ?c ?r ?i ?p ?t ?i ?o ?n ?, ?T ?y ?p ?e ?, ?S ?a backspace ?t ?a ?t ?e ?, ?L ?a ?s ?t ?  ?E ?v ?e ?n ?t ?, ?R ?e ?c ?e ?n ?t ?  ?E ?r ?r ?o ?r ?s ?\C-k ?\C-c ?\C-p])

(defun ab/uniquify-all-lines-region (start end)
  "Find duplicate lines in region START to END keeping first occurrence."
  (interactive "*r")
  (save-excursion
    (let ((end (copy-marker end)))
      (while
          (progn
            (goto-char start)
            (re-search-forward "^\\(.*\\)\n\\(\\(.*\n\\)*\\)\\1\n" end t))
        (replace-match "\\1\n\\2")))))

(defun ab/uniquify-all-lines-buffer ()
  "Delete duplicate lines in buffer and keep first occurrence."
  (interactive "*")
  (uniquify-all-lines-region (point-min) (point-max)))

;; From Xah Lee: http://ergoemacs.org/misc/ask_emacs_tuesday_2013-08-27.html
(defun ab/add-title-underline ()
  "add ========= below current line, with the same number of chars."
  (interactive)
  (let (
         (num (- (line-end-position) (line-beginning-position) ))
         (ii 0))
    (end-of-line)
    (insert"\n")
    (while (< ii num)
      (insert"=")
      (setq ii (1+ ii) ) ) ))

Autoload file types (.markdown; .md; .mkd)
  (autoload 'markdown-mode "markdown-mode"
     "Major mode for editing Markdown files" t)
  (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.mkd\\'" . markdown-mode))

;; Use Marked.app as my Markdown viewer
  (defun markdown-preview-file ()
    "run Marked on the current file and revert the buffer"
    (interactive)
    (shell-command 
     (format "open -a /Applications/Marked\ 2x.app %s" 
         (shell-quote-argument (buffer-file-name)))))

  (global-set-key (kbd "C-c C-m") 'markdown-preview-file)

(defun ab/add-title-underline ()
  "add ========= below current line, with same number of chars."
  (interactive)
  (let (
         (num (- (line-end-position) (line-beginning-position) ))
         (ii 0))
    (end-of-line)
    (insert "\n")
    (while (< ii num)
      (insert "=")
      (setq ii (1+ ii) ) ) ))

;; I use these for cleaning up some report data from R. Not really useful for anyone but me...
(fset 'ab/chat-regexp-home-pm
   "\223[0-\C-?\C-?6-9\\|10]\C-?\C-?\C-?(10)]\C-?\C-?\C-?\C-?\C-?+:\C-?\C-?\C-?\C-?]+:[0-9]+:[0-9]+,PM\C-eHome")

(fset 'ab/chat-regexp-office-am
   "\223[0-9]+:[0-9]+:[0-9]+,AM\C-eOffice")

(fset 'ab/chat-regexp-office-pm
   "\223[0-5]+:[0-9]+:[0-9]+,PM\C-eOffice")

;; ibuffer is an Improved version of list-buffers
(defalias 'list-buffers 'ibuffer)

;; From: https://github.com/fxbois/web-mode/issues/51
;; Fixes Yassnippet with web-mode

(defun yas-web-mode-fix ()
  (web-mode-buffer-refresh)
  (indent-for-tab-command))
(setq yas/after-exit-snippet-hook 'yas-web-mode-fix)

(setq ispell-program-name "/usr/local/bin/ispell")
