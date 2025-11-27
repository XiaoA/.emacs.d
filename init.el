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
 '(custom-safe-themes
   '("de87f49e3eed3f7bbc1fd525147dc0a7569bc435c9b045ceeb2d89f2904806bd"
     "32926e88c489bce47491ba330813a001d3938bb22ea894227c9c627e1d517c55"
     "2e5be9a86dbf3467288293564e209165c2e12439411bd478c644cd42acc6ccb2"
     "35ff01eb2ff2bff2760ceca637aeea7d2f3b9a60fd36ea0a96a6632637d5f222"
     default))
 '(package-selected-packages
   '(ace-jump-mode all-the-icons blackboard-theme browse-kill-ring cape
                   color-theme-sanityinc-solarized
                   color-theme-sanityinc-tomorrow corfu dap-mode
                   devdocs diff-hl dumb-jump eglot eldoc-box
                   enh-ruby-mode exec-path-from-shell expand-region
                   github-dark-vscode-theme gptel helm-ag helm-company
                   helm-lsp helm-projectile helm-xref imenu-list
                   insert-kaomoji intellij-theme
                   jetbrains-darcula-theme json-mode ligature lsp-ui
                   mac-pseudo-daemon magit minitest modus-themes
                   multiple-cursors nice-org-html ob-restclient
                   orderless org-auto-export-pandoc org-bullets
                   org-download org-journal org-modern org-re-reveal
                   org-roam-ql org-roam-ui org-ros powerline rinari
                   rjsx-mode robe rspec-mode ruby-end
                   seeing-is-believing unicode-fonts vs-dark-theme
                   web-mode yaml-mode yasnippet)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(eglot-inlay-hint-face ((t (:inherit shadow :height 0.9 :slant italic)))))
(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
