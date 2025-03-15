;; Disable UI elements before they're created
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'fringe-mode) (fringe-mode -1))

;; No splash screen on startup
(setq inhibit-splash-screen t)

;; I prefer a blank *scratch* buffer
(setq initial-scratch-message nil)
