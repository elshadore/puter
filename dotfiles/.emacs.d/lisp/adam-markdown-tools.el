;;; Some of this code *might* be vide coded slop!

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

(defconst adam/markdown-inline-link-groups '(1 2 4 5 6 7 8))
(defconst adam/markdown-reference-link-groups '(1 2 4 5 6 7))

(defun adam/markdown--fold-link (limit type)
  (let ((regexp (if (eq type 'reference)
                    markdown-regex-link-reference
                  markdown-regex-link-inline))
        (groups (if (eq type 'reference)
                    adam/markdown-reference-link-groups
                  adam/markdown-inline-link-groups))
        beg)
    (if (re-search-forward regexp limit t)
        (progn
          (setq beg (match-beginning 0))
          (cond
           ((equal (char-after beg) ?!)
            (goto-char (match-end 0))
            nil)
           ((or (markdown-code-block-at-point-p beg)
                (markdown-inline-code-at-point-p beg))
            (goto-char (1+ beg))
            nil)
           (t
            (dolist (group groups)
              (when (and (match-beginning group)
                         (< (match-beginning group) (match-end group)))
                (put-text-property (match-beginning group) (match-end group)
                                   'display "")))
            t))))))

(defun adam/markdown--find-link-start (limit type)
  (save-excursion
    (let ((regexp (if (eq type 'reference)
                      markdown-regex-link-reference
                    markdown-regex-link-inline)))
      (when (re-search-forward regexp limit t)
        (match-beginning 0)))))

(defun adam/markdown--fontify-hide-links (limit)
  (let (folded)
    (while (< (point) limit)
      (let* ((start (point))
             (inline-start (adam/markdown--find-link-start limit 'inline))
             (reference-start (adam/markdown--find-link-start limit 'reference))
             (earliest (cond ((and inline-start reference-start)
                              (min inline-start reference-start))
                             (inline-start inline-start)
                             (reference-start reference-start)))
             (type (cond ((and earliest (= earliest inline-start)) 'inline)
                         (earliest 'reference))))
        (if earliest
            (progn
              (goto-char earliest)
              (when (adam/markdown--fold-link limit type)
                (setq folded t)))
          (goto-char limit))
        (when (= (point) start)
          (forward-char 1))))
    (if folded t nil)))

(defconst adam/markdown-hide-link-keywords
  '((adam/markdown--fontify-hide-links)))

;;;###autoload
(define-minor-mode adam-markdown-tools-mode
  "Minor mode for some custom tools and additions to the default `markdown-mode' experiance."
  :lighter " adam-markdown-tools"
  (if adam-markdown-tools-mode
      (progn
        (font-lock-add-keywords nil adam/markdown-hide-hash-keywords 'append)
        (font-lock-add-keywords nil adam/markdown-hide-link-keywords 'append))
    (font-lock-remove-keywords nil adam/markdown-hide-hash-keywords)
    (font-lock-remove-keywords nil adam/markdown-hide-link-keywords))
  (when (derived-mode-p 'markdown-mode)
    (font-lock-flush)))

(provide 'adam-markdown-tools)

;;; adam-markdown.el ends here
