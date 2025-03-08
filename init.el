;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;;; init.el --- Where all the magic begins
;;
;; This file loads Org-mode and then loads the rest of our Emacs initialization from Emacs lisp
;; embedded in literate Org-mode files.

;; Load up Org Mode and Org Babel for elisp embedded in Org Mode files
(setq dotfiles-dir (file-name-directory (or (buffer-file-name) load-file-name)))

(let* ((org-dir (expand-file-name
                 "lisp" (expand-file-name
                         "org" (expand-file-name
                                "src" dotfiles-dir))))
       (org-contrib-dir (expand-file-name
                         "lisp" (expand-file-name
                                 "contrib" (expand-file-name
                                            ".." org-dir))))
       (load-path (append (list org-dir org-contrib-dir)
                          (or load-path nil))))
  ;; load up Org-mode and Org-babel
  ;; (require 'org-install)
  (require 'ob-tangle))

;; load up all literate org-mode files in this directory
(mapc #'org-babel-load-file (directory-files dotfiles-dir t "\\.org$"))

;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(ac-html ac-html-bootstrap ac-html-csswatcher ac-inf-ruby
             ace-jump-buffer ace-jump-mode browse-kill-ring bundler
             calfw cider coffee-mode company csv-mode dash-at-point
             dracula-theme enh-ruby-mode ess expand-region
             flymake-haml flymake-json flymake-php flymake-ruby
             fold-this folding haml-mode helm-ag helm-projectile
             helm-robe js2-mode json-mode magit markdown-mode minitest
             mode-icons multi-term multiple-cursors neotree nyan-mode
             nyan-prompt ob-restclient org-plus-contrib org-present
             org-roam-ui org-screenshot parse-csv password-generator
             php+-mode php-mode powerline project-explorer
             projectile-rails rbenv rhtml-mode rinari robe rspec-mode
             ruby-electric ruby-end ruby-refactor ruby-tools
             seeing-is-believing soothe-theme sr-speedbar
             twittering-mode undo-tree web-mode yaml-mode yasnippet)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
