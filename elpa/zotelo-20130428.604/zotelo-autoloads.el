;;; zotelo-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (moz-command zotelo-reset zotelo-set-collection
;;;;;;  zotelo-update-database zotelo-export-secondary zotelo-minor-mode
;;;;;;  zotelo-translators zotelo-default-translator) "zotelo" "zotelo.el"
;;;;;;  (21211 17263 0 0))
;;; Generated autoloads from zotelo.el

(defvar zotelo-default-translator 'BibTeX "\
The name of the default zotero-translator to use (a symbol).

Must correspond to one of the keys in `zotelo-translators' alist.

You can set this varialbe interactively with
`zotelo-set-translator'.
")

(custom-autoload 'zotelo-default-translator "zotelo" t)

(defvar zotelo-translators '((BibTeX "9cb70025-a888-4a29-a210-93ec52da40d4" "bib") (BibLaTeX "ba4cd274-f24e-42cf-8ff2-ccfc603aacf3" "bib") (BibLaTeX-cite "fe7a85a9-4cb5-4986-9cc3-e6b47d6660f7" "bib") (Zotero-RDF "14763d24-8ba0-45df-8f52-b8d1108e7ac9" "rdf") (Wikipedia "3f50aaac-7acc-4350-acd0-59cb77faf620" "txt") (CSL-JSON "bc03b4fe-436d-4a1f-ba59-de4d2d7a63f7" "json") (Bookmarks-HTML "4e7119e0-02be-4848-86ef-79a64185aad8" "html") (Refer/BibIX "881f60f2-0802-411a-9228-ce5f47b64c7d" "txt") (RIS "32d59d2d-b65a-4da4-b0a3-bdd3cfb979e7" "ris") (MODS "0e2235e7-babf-413c-9acf-f27cce5f059c" "xml") (Bibliontology-RDF "14763d25-8ba0-45df-8f52-b8d1108e7ac9" "rdf")) "\
An alist of zotero translators ids.
Each cell consists an user friendly key, and a value is a list of
an unique identifier used by zotero and an extension of the
target file.

Not all of the listed translatros are the default zotero
translators. You have to search and download them yourself.

Standard BibTeX (zotero): '9cb70025-a888-4a29-a210-93ec52da40d4'
BibLaTeX (downloaded from https://code.google.com/p/zotero-biblatex-export/): 'ba4cd274-f24e-42cf-8ff2-ccfc603aacf3'
")

(custom-autoload 'zotelo-translators "zotelo" t)

(autoload 'zotelo-minor-mode "zotelo" "\
zotelo minor mode for interaction with Firefox.
With no argument, this command toggles the mode.
Non-null prefix argument turns on the mode.
Null prefix argument turns off the mode.

When this minor mode is enabled, `zotelo-set-collection' prompts
for zotero collection and stores it as file local variable . To
manually update the BibTeX data base call
`zotelo-update-database'. The \"file_name.bib\" file will be
created with the exported zotero items. To specify the file_name
just insert insert \\bibliography{file_name} anywhere in the
buffer.

This mode is designed mainly for latex modes and works in
conjunction with RefTex, but it can be used in any other mode
such as org-mode.

The following keys are bound in this minor mode:

\\{zotelo-minor-mode-map}

\(fn &optional ARG)" t nil)

(autoload 'zotelo-export-secondary "zotelo" "\
Export zotero collection into  secondary BibTeX database.

Before export, ask for a secondary database and zotero collection
to be exported into the database. Secondary databases are those
in \\bibliography{file1, file2, ...}, except the first one.

Error ocures if there is only one (primary) file listed in 
\\bibliography{...}.

Error if zotero collection is not found by MozRepl

\(fn)" t nil)

(autoload 'zotelo-update-database "zotelo" "\
Update the primary BibTeX database associated with the current buffer.

Primary database is the first file in \\bibliography{file1, file2,
...}, list. If you want to export into a different file use
`zotelo-update-database-secondary'.

If BIBFILE is supplied, don't infer from \\bibliography{...} statement.

If ID is supplied, don't infer collection id from file local variables.

Through an error if zotero collection has not been found by MozRepl

\(fn &optional CHECK-ZOTERO-CHANGE BIBFILE ID)" t nil)

(autoload 'zotelo-set-collection "zotelo" "\
Ask for a zotero collection.
Ido interface is used by default. If you don't like it set `zotelo-use-ido' to nil.


In `ido-mode' use \"C-s\" and \"C-r\" for navigation. See
ido-mode emacs wiki for many more details.

If no-update is t, don't update after setting the collecton.

If no-file-local is non-nill don't set file-local variable.

Return the properized collection name.

\(fn &optional PROMPT NO-UPDATE NO-FILE-LOCAL)" t nil)

(autoload 'zotelo-reset "zotelo" "\
Reset zotelo.

\(fn)" t nil)

(autoload 'moz-command "zotelo" "\
Send the moz-repl  process command COM and delete the output
from the MozRepl process buffer.  If an optional second argument BUF
exists, it must be a string or an existing buffer object. The
output is inserted in that buffer. BUF is erased before use.

New line is automatically appended.

\(fn COM &optional BUF)" nil nil)

;;;***

;;;### (autoloads nil nil ("zotelo-pkg.el") (21211 17264 131845 0))

;;;***

(provide 'zotelo-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; zotelo-autoloads.el ends here
