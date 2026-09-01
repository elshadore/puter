;;; Some of this code *might* be vide coded slop!

(require 'markdown-mode)

(defface adam/markdown-hide-hash
  '((((background light)) (:foreground "white"))
    (((background dark)) (:foreground "black"))
    (t (:inherit default)))
  "Face for hiding `markdown' heading hashes, depending on background `light' or `dark'.")

(defun adam/markdown-search-heading-hashes (limit)
  "Search for `markdown', headings to the limit LIMIT."
  (catch 'found
    (while (re-search-forward "^\\(#*\\)\\(#\\)[ \t]" limit t)
      (unless (markdown-code-block-at-point-p (match-beginning 0))
        (throw 'found t)))
    nil))

(defconst adam/markdown-hide-hash-keywords
  '((adam/markdown-search-heading-hashes
     (1 'adam/markdown-hide-hash prepend)
     (2 nil prepend))))

;;;###autoload
(define-minor-mode adam-markdown-tools-mode
  "Minor mode for some custom tools and additions to the default `markdown-mode' experiance."
  :lighter " adam-markdown-tools"
  (if adam-markdown-tools-mode
      (font-lock-add-keywords nil adam/markdown-hide-hash-keywords 'append)
    (font-lock-remove-keywords nil adam/markdown-hide-hash-keywords)))

(provide 'adam-markdown-tools)
;;; adam-markdown-tools.el ends here
