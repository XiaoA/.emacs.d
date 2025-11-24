;; (require 'server)
;; (unless (server-running-p)
;;   (server-start))

;; I use these for cleaning up some report data from R. Not really useful for anyone but me...
(fset 'ab/chat-regexp-home-pm
   "\223[0-\C-?\C-?6-9\\|10]\C-?\C-?\C-?(10)]\C-?\C-?\C-?\C-?\C-?+:\C-?\C-?\C-?\C-?]+:[0-9]+:[0-9]+,PM\C-eHome")

(fset 'ab/chat-regexp-office-am
   "\223[0-9]+:[0-9]+:[0-9]+,AM\C-eOffice")

(fset 'ab/chat-regexp-office-pm
   "\223[0-5]+:[0-9]+:[0-9]+,PM\C-eOffice")
