(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#2d3743" "#ff4242" "#74af68" "#dbdb95" "#34cae2" "#008b8b" "#00ede1" "#e1e1e0"])
 '(autopair-global-mode t)
 '(column-number-mode t)
 '(compilation-message-face (quote default))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#657b83")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(custom-enabled-themes (quote (inkpot)))
 '(custom-safe-themes
   (quote
    ("70cf411fbf9512a4da81aa1e87b064d3a3f0a47b19d7a4850578c8d64cac2353" "13496497054fba5b7efdd7bcf3d0158e97191e501eca9b6a4d63aa042ffe8fe0" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "d921083fbcd13748dd1eb638f66563d564762606f6ea4389ea9328b6f92723b7" "1f70ca6096c886ca2a587bc10e2e8299ab835a1b95394a5f4e4d41bb76359633" "0c311fb22e6197daba9123f43da98f273d2bfaeeaeb653007ad1ee77f0003037" "30f861ee9dc270afc2a9962c05e02d600c998905433c8b9211dc2b33caa97c51" "2affb26fb9a1b9325f05f4233d08ccbba7ec6e0c99c64681895219f964aac7af" "97a2b10275e3e5c67f46ddaac0ec7969aeb35068c03ec4157cf4887c401e74b1" "5bd5af0deb1ab0e2c1b9c54d94a3f030529b6c7034fdf0d3cc4b0e7e0338cb91" "5bff694d9bd3791807c205d8adf96817ee1e572654f6ddc5e1e58b0488369f9d" "9873d7793e0449ed30b78358a81d8219622aabf9df4492c22e08b247751ade5c" "968d1ad07c38d02d2e5debffc5638332696ac41af7974ade6f95841359ed73e3" "758da0cfc4ecb8447acb866fb3988f4a41cf2b8f9ca28de9b21d9a68ae61b181" "9ffeaafbdeb8d440413888b996730c25ca79f591272f40d5a3a02b0b9b3e6c9a" "4a60f0178f5cfd5eafe73e0fc2699a03da90ddb79ac6dbc73042a591ae216f03" "c739f435660ca9d9e77312cbb878d5d7fd31e386a7758c982fa54a49ffd47f6e" "2b5aa66b7d5be41b18cc67f3286ae664134b95ccc4a86c9339c886dfd736132d" "ce8998464858cd579515f35dd9c582f03e14175d898f67ace69f6a6c5624ed68" "28b17dbb4ff2013db0f007a35e06653ad386a607341f5d72e69ee91e8bbcb96c" "66bd7fc2ed32703a332d05f5d2af5c30c12ff4e729d77d8271b91d6f6f7e15fc" "5dfacaf380068d9ed06e0872a066a305ab6a1217f25c3457b640e76c98ae20e6" "22b0cbd7a141e0b366a536494cc5d4e30541d9b6140f9cced3f8978082719e6d" "4c9ba94db23a0a3dea88ee80f41d9478c151b07cb6640b33bfc38be7c2415cc4" "8d584fef1225d72bfd32d7677ac7f281208140a2535ef0e9f46f0e76343f8aca" "364a5e1aecdd0d24b70089050368851ea5ee593dc8cc6fb58cff1b8cfe88a264" "73b835431bdbc4e83a3b176a38ebb740fbac78aa2635e1d4827b3c8211e0bc99" "f5db04080a5133bc99721d680a11cf974d60d1df347b08841b43c3e97f52d3bf" "1177fe4645eb8db34ee151ce45518e47cc4595c3e72c55dc07df03ab353ad132" default)))
 '(electric-indent-mode t)
 '(fci-rule-color "#383838")
 '(global-undo-tree-mode t)
 '(helm-mode t)
 '(highlight-changes-colors (quote ("#FD5FF0" "#AE81FF")))
 '(highlight-symbol-colors
   (--map
    (solarized-color-blend it "#fdf6e3" 0.25)
    (quote
     ("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2"))))
 '(highlight-symbol-foreground-color "#586e75")
 '(highlight-tail-colors
   (quote
    (("#49483E" . 0)
     ("#67930F" . 20)
     ("#349B8D" . 30)
     ("#21889B" . 50)
     ("#968B26" . 60)
     ("#A45E0A" . 70)
     ("#A41F99" . 85)
     ("#49483E" . 100))))
 '(magit-diff-use-overlays nil)
 '(magit-use-overlays nil)
 '(markdown-command "multimarkdown")
 '(org-agenda-files
   (quote
    ("~/dropbox/org/its-12-2013.org" "~/dropbox/org/itss-11-2013.org" "~/dropbox/org/todo.org" "~/Dropbox/org/its-10-2013.org" "~/Dropbox/org/refile.org" "~/Dropbox/org/its-9-2013.org")))
 '(org-capture-templates
   (quote
    (("n" "Note" entry
      (file "~/Dropbox/org/refile.org")
      "" :kill-buffer t))))
 '(org-export-html-postamble nil)
 '(org-export-html-style-include-scripts nil)
 '(org-html-doctype "html5")
 '(org-html-head
   "<link rel=\"stylesheet\" type=\"text/css\" href=\"mystyles.css\" />")
 '(org-html-head-include-default-style nil)
 '(sentence-end-double-space nil)
 '(shell-pop-universal-key "")
 '(shell-pop-window-position "full")
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#eee8d5" 0.2))
 '(syslog-debug-face
   (quote
    ((t :background unspecified :foreground "#A1EFE4" :weight bold))))
 '(syslog-error-face
   (quote
    ((t :background unspecified :foreground "#F92672" :weight bold))))
 '(syslog-hour-face (quote ((t :background unspecified :foreground "#A6E22E"))))
 '(syslog-info-face
   (quote
    ((t :background unspecified :foreground "#66D9EF" :weight bold))))
 '(syslog-ip-face (quote ((t :background unspecified :foreground "#E6DB74"))))
 '(syslog-su-face (quote ((t :background unspecified :foreground "#FD5FF0"))))
 '(syslog-warn-face
   (quote
    ((t :background unspecified :foreground "#FD971F" :weight bold))))
 '(term-default-bg-color "#fdf6e3")
 '(term-default-fg-color "#657b83")
 '(tool-bar-mode nil)
 '(transient-mark-mode t)
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#F92672")
     (40 . "#CF4F1F")
     (60 . "#C26C0F")
     (80 . "#E6DB74")
     (100 . "#AB8C00")
     (120 . "#A18F00")
     (140 . "#989200")
     (160 . "#8E9500")
     (180 . "#A6E22E")
     (200 . "#729A1E")
     (220 . "#609C3C")
     (240 . "#4E9D5B")
     (260 . "#3C9F79")
     (280 . "#A1EFE4")
     (300 . "#299BA6")
     (320 . "#2896B5")
     (340 . "#2790C3")
     (360 . "#66D9EF"))))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   (quote
    (unspecified "#272822" "#49483E" "#A20C41" "#F92672" "#67930F" "#A6E22E" "#968B26" "#E6DB74" "#21889B" "#66D9EF" "#A41F99" "#FD5FF0" "#349B8D" "#A1EFE4" "#F8F8F2" "#F8F8F0"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background nil))))
 '(font-lock-comment-face ((t (:foreground "disabledControlTextColor"))))
 '(font-lock-string-face ((t (:foreground "keyboardFocusIndicatorColor"))))
 '(web-mode-html-attr-name-face ((t (:foreground "Cyan"))) t)
 '(web-mode-html-tag-bracket-face ((t (:foreground "Snow"))) t)
 '(web-mode-html-tag-face ((t (:foreground "White"))) t)
 '(web-mode-inlay-face ((t (:background "controlShadowColor"))) t))
