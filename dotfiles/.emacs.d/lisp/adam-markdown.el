(defface adam/markdown-hide-hash
  '((((background light)) (:foreground "white"))
    (((background dark)) (:foreground "black"))
    (t (:inherit default)))
  "Face used to hide leading hash symbols in ATX headings.")

(defun adam/markdown-search-heading-hashes (limit)
  (catch 'found
    (while (re-search-forward "^\\(#*\\)\\(#\\)[ \t]" limit t)
      (unless (markdown-code-block-at-point-p (match-beginning 0))
        (throw 'found t)))
    nil))

(defconst adam/markdown-hide-hash-keywords
  '((adam/markdown-search-heading-hashes
     (1 'adam/markdown-hide-hash prepend)
     (2 nil prepend))))

(provide 'adam-markdown)
