(add-to-list 'load-path "~/.emacs.d/config/")

;; type "y"/"n" instead of "yes"/"no"
(fset 'yes-or-no-p 'y-or-n-p)

(setq visible-bell t)

;; (set-frame-font "Menlo 14" nil t)
(set-face-attribute 'default nil :font "Menlo" :height 170)

;; Use Helm Mode
(helm-mode 1)

;; (global-set-key (kbd "C-x RET") 'helm-M-x)

(global-set-key (kbd "M-y") 'helm-show-kill-ring)

(global-set-key (kbd "C-x b") 'helm-mini)

(global-set-key (kbd "C-x C-f") 'helm-find-files)

(global-set-key (kbd "C-c h o") 'helm-occur)

(global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)

(global-set-key (kbd "C-c h x") 'helm-register)

(load-theme 'modus-vivendi t)

(require 'powerline)
(powerline-center-theme)

;;(set-default-font "Menlo-17")

;; A great tip from Steve Yegge. Because Alt-x is too awkward...
(global-set-key "\C-x\C-m" 'execute-extended-command)
;; Experimenting with 'helm-M-x; see 'Helm Keyboard Shortcuts,' above

;; Byte Recompile
(defun ab/byte-recompile ()
  (interactive)
  (byte-recompile-directory "~/.emacs.d" 0))

(setq default-tab-width 2)
(setq-default indent-tabs-mode nil)

;; Write backup files to own directory
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)

;;; import-env-from-shell.el --- Make Emacs use the environment set up by the user's shell

;; Copyright (C) 2013-2014 Vincent Goulet

;; Author: Vincent Goulet

;; This file is a modified version of exec-path-from-shell.el by
;; Steve Purcell <steve@sanityinc.com>
;; URL: https://github.com/purcell/exec-path-from-shell

;; This file is part of GNU Emacs.app Modified
;; http://vgoulet.act.ulaval.ca/emacs

;; GNU Emacs.app Modified is free software; you can redistribute it
;; and/or modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

(defgroup import-env-from-shell nil
  "Make Emacs use shell-defined values for $PATH etc."
  :prefix "import-env-from-shell-"
  :group 'environment)

(defcustom import-env-from-shell-variables
  '("PATH" "MANPATH" "LANG")
  "List of environment variables which are copied from the shell."
  :type '(repeat (string :tag "Environment variable"))
  :group 'import-env-from-shell)

(defvar import-env-from-shell-debug nil
  "Display debug info when non-nil.")

(defun import-env-from-shell--double-quote (s)
  "Double-quote S, escaping any double-quotes already contained in it."
  (concat "\"" (replace-regexp-in-string "\"" "\\\\\"" s) "\""))

(defun import-env-from-shell--tcsh-p (shell)
  "Return non-nil if SHELL appears to be tcsh."
  (string-match "tcsh$" shell))

(defun import-env-from-shell--login-arg (shell)
  "Return the name of the --login arg for SHELL."
  (if (import-env-from-shell--tcsh-p shell) "-d" "-l"))

(defcustom import-env-from-shell-arguments
  (list (import-env-from-shell--login-arg (getenv "SHELL")) "-i")
  "Additional arguments to pass to the shell.

The default value denotes an interactive login shell."
  :type '(repeat (string :tag "Shell argument"))
  :group 'import-env-from-shell)

(defun import-env-from-shell--debug (msg &rest args)
  "Print MSG and ARGS like `message', but only if debug output is enabled."
  (when import-env-from-shell-debug
    (apply 'message msg args)))

(defun import-env-from-shell--standard-shell-p (shell)
  "Return non-nil iff SHELL supports the standard ${VAR-default} syntax."
  (not (string-match "\\(fish\\|tcsh\\)$" shell)))

(defun import-env-from-shell-printf (str &optional args)
  "Return the result of printing STR in the user's shell.

Executes $SHELL as interactive login shell.

STR is inserted literally in a single-quoted argument to printf,
and may therefore contain backslashed escape sequences understood
by printf.

ARGS is an optional list of args which will be inserted by printf
in place of any % placeholders in STR. ARGS are not automatically
shell-escaped, so they may contain $ etc."
  (let* ((printf-bin (or (executable-find "printf") "printf"))
         (printf-command
          (concat printf-bin
                  " '__RESULT\\000" str "' "
                  (mapconcat #'import-env-from-shell--double-quote args " ")))
         (shell-args (append import-env-from-shell-arguments
                             (list "-c"
                                   (if (import-env-from-shell--standard-shell-p (getenv "SHELL"))
                                       printf-command
                                     (concat "sh -c " (shell-quote-argument printf-command))))))
         (shell (getenv "SHELL")))
    (with-temp-buffer
      (import-env-from-shell--debug "Invoking shell %s with args %S" shell shell-args)
      (let ((exit-code (apply #'call-process shell nil t nil shell-args)))
        (import-env-from-shell--debug "Shell printed: %S" (buffer-string))
        (unless (zerop exit-code)
          (error "Non-zero exit code from shell %s invoked with args %S.  Output was:\n%S"
                 shell shell-args (buffer-string))))
      (goto-char (point-min))
      (if (re-search-forward "__RESULT\0\\(.*\\)" nil t)
          (match-string 1)
        (error "Expected printf output from shell, but got: %S" (buffer-string))))))

(defun import-env-from-shell-getenvs (names)
  "Get the environment variables with NAMES from the user's shell.

Execute $SHELL according to `import-env-from-shell-arguments'.
The result is a list of (NAME . VALUE) pairs."
  (let* ((dollar-names (mapcar (lambda (n) (format "${%s-}" n)) names))
         (values (split-string (import-env-from-shell-printf
                                (mapconcat #'identity (make-list (length names) "%s") "\\000")
                                dollar-names) "\0")))
    (let (result)
      (while names
        (prog1
            (push (cons (car names) (car values)) result)
          (setq values (cdr values)
                names (cdr names))))
      result)))

(defun import-env-from-shell-getenv (name)
  "Get the environment variable NAME from the user's shell.

Execute $SHELL as interactive login shell, have it output the
variable of NAME and return this output as string."
  (cdr (assoc name (import-env-from-shell-getenvs (list name)))))

(defun import-env-from-shell-setenv (name value)
  "Set the value of environment var NAME to VALUE.
Additionally, if NAME is \"PATH\" then also set corresponding
variables such as `exec-path'."
  (setenv name value)
  (when (string-equal "PATH" name)
    (setq eshell-path-env value
          exec-path (append (parse-colon-path value) (list exec-directory)))))

(defun import-env-from-shell-copy-envs (names)
  "Set the environment variables with NAMES from the user's shell.

As a special case, if the variable is $PATH, then `exec-path' and
`eshell-path-env' are also set appropriately.  The result is an alist,
as described by `import-env-from-shell-getenvs'."
  (mapc (lambda (pair)
          (import-env-from-shell-setenv (car pair) (cdr pair)))
        (import-env-from-shell-getenvs names)))

(defun import-env-from-shell-copy-env (name)
  "Set the environment variable $NAME from the user's shell.

As a special case, if the variable is $PATH, then `exec-path' and
`eshell-path-env' are also set appropriately.  Return the value
of the environment variable."
  (interactive "sCopy value of which environment variable from shell? ")
  (cdar (import-env-from-shell-copy-envs (list name))))

(defun import-env-from-shell-initialize ()
  "Initialize environment from the user's shell.

The values of all the environment variables named in
`import-env-from-shell-variables' are set from the corresponding
values used in the user's shell."
  (interactive)
  (import-env-from-shell-copy-envs import-env-from-shell-variables))

(import-env-from-shell-initialize)

(provide 'import-env-from-shell)

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

;; Increment Number at Point
;;Got this from EmacsWiki; enables incremental numbers. First input
  ;; numbers and then use this!
  (defun ab/increment-number-at-point ()
      (interactive)
      (skip-chars-backward "0123456789")
      (or (looking-at "[0123456789]+")
          (error "No number at point"))
      (replace-match (number-to-string (1+ (string-to-number (match-string 0))))))

;; Paren-Mode
(require 'paren)
(show-paren-mode t)

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

(add-to-list 'load-path "~/.emacs.d/elpa/ace-jump-mode*/")
(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)

(define-key global-map (kbd "C-c j") 'ace-jump-mode)

;; enable a more powerful jump back function from ace jump mode

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

;; (add-to-list 'load-path "~/.emacs.d/elpa/yasnippet")
;;     (require 'yasnippet) ;; not yasnippet-bundle
;;     (yas-global-mode 1)
(use-package yasnippet
  :config
  (setq yas-snippet-dirs '("~/.emacs.d/snippets"))
  (yas-global-mode 1))

;; Load my snippets
(add-to-list 'load-path "~/.emacs.d/snippets/web-mode/")
(add-to-list 'load-path "~/.emacs.d/snippets/markdown-mode/")
(add-to-list 'load-path "~/.emacs.d/snippets/org-mode")
(add-to-list 'load-path "~/.emacs.d/snippets/ruby-mode")

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

;; (require 'auto-complete)
;; (global-auto-complete-mode t)
;; (auto-complete-mode t)

;; Use web-mode whenever possible...
(setq auto-mode-alist (cons '("\\.html$" . web-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.aspx$" . web-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.erb$" . web-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.php$" . web-mode) auto-mode-alist))

;; For some reason, I've had trouble getting indentation to work properly. This fixed that.
(defun my-web-mode-hook ()
  "Hooks for Web mode."
    (setq web-mode-markup-indent-offset 2)
    (setq web-mode-css-indent-offset 2)
    (setq web-mode-code-indent-offset 2)
    (setq web-mode-indent-style 2)
)
(add-hook 'web-mode-hook  'my-web-mode-hook)

;; Require Org-Mode
(require 'org)

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
            (local-set-key "\M-I" 'org-toggle-image-in-org)
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
    (shell . t)
    (R . t)
    (perl . t)
    (ruby . t)
    (python . t)
    (js . t)
    (haskell . t)
;;    (elixir . t)
    (restclient . t)
    ))

(add-to-list 'org-src-lang-modes
             '("r" . ess-mode))

;; (add-to-list 'org-src-lang-modes '("racket" . racket-mode))
;; (add-to-list 'load-path "~/.emacs.d/vendor/emacs-ob-racket/")

;; ;; Set path to racket interpreter
;; (setq org-babel-command:racket "/usr/local/bin/racket")

;; (require 'ob-racket)

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

;; Nice Bulleted Lists
  (require 'org-bullets)
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; It's silly, I know, but why not let Emacs greet me...? ;)
  (message "Welcome back, Andrew. Are you ready to save the world?")

;; Let's keep our files in Dropbox
(setq org-directory "~/Dropbox/org")
(setq org-default-notes-file "~/Dropbox/org/refile.org")
(global-set-key (kbd "C-c c") 'org-capture)

(require 'ox-md)

(add-hook 'org-clock-in-hook (lambda () (call-process "/usr/bin/osascript" nil 0 nil "-e" (concat "tell application \"org-clock-statusbar\" to clock in \"" (replace-regexp-in-string "\"" "\\\\\"" org-clock-current-task) "\""))))
(add-hook 'org-clock-out-hook (lambda () (call-process "/usr/bin/osascript" nil 0 nil "-e" "tell application \"org-clock-statusbar\" to clock out")))

;; From: https://github.com/fxbois/web-mode/issues/51
;; Fixes Yassnippet with web-mode

(defun yas-web-mode-fix ()
  (web-mode-buffer-refresh)
  (indent-for-tab-command))
(setq yas/after-exit-snippet-hook 'yas-web-mode-fix)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((ditaa . t))) ; this line activates ditaa

(setq orgd-itaa-jar-path "/usr/local/Cellar/ditaa/0.9/libexec/ditaa0_9.jar")

(require 'org-download)

;; Drag-and-drop to `dired`
(add-hook 'dired-mode-hook 'org-download-enable)

(setq org-roam-v2-ack t)

(use-package org-roam
  :ensure t
  :defer t
  :init
  (setq org-roam-v2-ack t)
  
  :custom
  (org-roam-directory "/Users/abuckingham/org-roam")
  :bind (("C-c n f" . org-roam-node-find)
         ("C-c n l" . org-roam-buffer-toggle)
         ("C-c n i" . org-roam-node-insert)
         :map org-mode-map
         ("C-M-i" . completion-at-point))
  :config
  (org-roam-setup))

(use-package websocket
              :after org-roam)

(use-package org-roam-ui
              :after org-roam ;; or :after org
              ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
              ;;         a hookable mode anymore, you're advised to pick something yourself
              ;;         if you don't care about startup time, use
              ;;  :hook (after-init . org-roam-ui-mode)
              :config
              (setq org-roam-ui-sync-theme t
                    org-roam-ui-follow t
                    org-roam-ui-update-on-save t
                    org-roam-ui-open-on-start t))

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

;;Autoload file types (.markdown; .md; .mkd)
(autoload 'markdown-mode "markdown-mode"
     "Major mode for editing Markdown files" t)
  (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.mkd\\'" . markdown-mode))

;; Use Marked.app as my Markdown viewer
(defun markdown-preview-file-with-marked ()
  "run Marked on the current file and revert the buffer"
  (interactive)
  (shell-command 
   (format "open -a /Applications/Marked\\ 2.app %s" 
	   (shell-quote-argument (buffer-file-name)))))

(global-set-key (kbd "\C-cm") 'markdown-preview-file-with-marked)

;; Thanks to Xah Lee: http://ergoemacs.org/misc/ask_emacs_tuesday_2013-08-27.html
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

(setq ispell-program-name "/usr/local/bin/ispell")

(setq autopair-global-mode t)

;; Rake files are Ruby.    
  (dolist (exp '("Rakefile\\'" "\\.rake\\'"))
      (add-to-list 'auto-mode-alist
                   (cons exp 'ruby-mode)))

(require 'robe)

(require 'rinari)

(defun timestamp ()
  "Insert timestamp at point."
  (interactive)
  (insert (format-time-string "%a, %b %d, %Y %H:%M:%S %z")))

(defun jekyll-timestamp ()
  "Insert timestamp at point."
  (interactive)
  (insert (format-time-string "%Y-%m-%d %H:%M:%S %:z")))
(global-set-key [f5] 'jekyll-timestamp)

;; adapted from Peter Reavy's elisp solution: http://peterreavy.com/tech/2012/12/18/elisp-to-create-a-new-blog-post-in-Jekyll.html

(defun jekyll-new-post (title)
  "Start a new blog post"
  (setq path "~/jekyll/andrewbuckingham-source/_posts/")
  (interactive "sTitle: ")
  (find-file (concat path (format-time-string "%Y-%m-%d")
    "-" (replace-regexp-in-string " " "-" title) ".md"))
  (insert "---
layout: single
title: 
date: 
tags: []
---
")
  )

;; Enable minitest-mode for Ruby
(add-hook 'ruby-mode-hook 'minitest-mode)
(add-hook 'enh-ruby-mode-hook 'minitest-mode)

;;  (add-to-list 'load-path "~/.emacs.d/slime")
;;  (setq inferior-lisp-program "/usr/local/bin/sbcl")
;;  (require 'slime)
;;  (slime-setup)

;  (autoload 'js2-mode "js2-mode" nil t)
;  (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
;  (global-set-key [f5] 'slime-js-reload)
;  (add-hook 'js2-mode-hook
;            (lambda ()
;              (slime-js-minor-mode 1)))
 ; (load-file "~/.emacs.d/setup-slime-js.el")

;; (require 'ob-elixir)

(use-package exec-path-from-shell
:ensure t
:config
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize)))

(add-to-list 'exec-path "/Users/abuckingham/.asdf/shims")
(setenv "PATH" (concat "/Users/abuckingham/.asdf/shims:" (getenv "PATH")))

;; (use-package lsp-mode
;;     :commands lsp
;;     :ensure t
;;     :diminish lsp-mode
;;     :hook
;;     (elixir-mode . lsp)
;;     :init
;;     (add-to-list 'exec-path "~/.emacs.d/vendor/elixir-ls-1.12/"))

(use-package unicode-fonts
  :ensure t
  :config
  (unicode-fonts-setup))

(defun ab/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . ab/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c p")
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook
  (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))


(use-package helm-lsp
  :commands helm-lsp-workspace-symbol)

(use-package which-key
  :config
  (which-key-mode))

(use-package typescript-mode
  :mode "\\.ts\\'"
  :mode "\\.tsx\\'"
  :mode "\\.js\\'"
  :hook
  (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))


(use-package company
  ;; :after lsp-mode
  ;; :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
              ("<tab>" . company-complete-selection))
  (:map lsp-mode-map
        ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

;; (use-package company-box
;;   :hook
;;   (company-mode . company-box-mode))

;; Based on http://ezinearticles.com/?What-is-the-Average-Reading-Speed-and-the-Best-Rate-of-Reading?&id=2298503
(defun ab/time-to-read ()
  "Calculate time to read the content(mins.)
       which is around 200 wpm."
  (let ((count (count-words-region)))
    (if (zerop count)
        (message "ERR: Cannot estimate time to read.")
      (setq ttr (fceiling (/ (/ count (/ 200 60.0)) 60.0))))
    ttr))

(use-package gptel
:ensure t
:config
(setq gptel-api-key "<your-openai-api-key>"
      gptel-default-model "gpt-4"))


(setq gptel-default-model "gpt-4")            ;; Choose the model

(let ((secrets-file "~/.emacs.d/secrets.el"))
(when (file-exists-p secrets-file)
  (load secrets-file)))

(require 'ox-md)
