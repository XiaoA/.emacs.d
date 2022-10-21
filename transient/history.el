((magit-blame
  ("-w"))
 (magit-branch nil)
 (magit-commit nil)
 (magit-diff
  ("--no-ext-diff" "--stat")
  (("--" "app/assets/stylesheets/responsive/mobile.scss")
   "--no-ext-diff" "--stat"))
 (magit-dispatch nil)
 (magit-fetch nil)
 (magit-file-dispatch nil)
 (magit-gitignore nil)
 (magit-log
  ("-n256" "--graph" "--decorate")
  (("--" "./"))
  (("--" "./")
   "--graph")
  ("-n256" "--graph" "--color" "--decorate")
  ("--graph" "--decorate")
  ("-n256"
   ("--" "--")
   "--graph" "--color" "--decorate")
  ("--graph" "--color"))
 (magit-merge nil
              ("--ff-only"))
 (magit-pull nil)
 (magit-push nil
             ("--force"))
 (magit-rebase nil)
 (magit-remote
  ("-f"))
 (magit-reset nil)
 (magit-revert
  ("--edit"))
 (magit-stash nil)
 (magit-status-jump nil)
 (magit:-- "--" "--color" ""))
