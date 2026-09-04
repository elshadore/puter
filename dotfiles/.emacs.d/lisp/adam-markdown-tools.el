;;; package --- Summary -*- lexical-binding: nil -*-
;;; Commentary:
;;; Some of this code *might* be vide coded slop!
;;; Code:

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

(defconst adam/markdown-link-invisible 'adam-markdown-link-hide)

(defun adam/markdown-fontify-inline-links (last)
  "Fontify inline links to hide URL and markup, showing only link text."
  (when (markdown-match-generic-links last nil)
    (dolist (g '(2 4 5 6 8))
      (when (match-end g)
        (put-text-property (match-beginning g) (match-end g)
                           'invisible adam/markdown-link-invisible)))
    t))

(defconst adam/markdown-hide-link-keywords
  '((adam/markdown-fontify-inline-links)))

(defconst adam/markdown-list-item-max-label 60)

(defun adam/markdown-imenu-list-items ()
  "Return a flat imenu alist of bullet list items for the current buffer."
  (let ((index))
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward markdown-regex-list (point-max) t)
        (unless (markdown-code-block-at-point-p (match-beginning 0))
          (let* ((start (match-end 0))
                 (end (line-end-position))
                 (raw (buffer-substring-no-properties start
                                                      (min end (+ start (* adam/markdown-list-item-max-label 2)))))
                 (label (markdown-trim-whitespace
                         (if (> (length raw) adam/markdown-list-item-max-label)
                             (concat (substring raw 0 adam/markdown-list-item-max-label) "…")
                           raw))))
            (unless (string-empty-p label)
              (push (cons label (match-beginning 0)) index))))))
    (reverse index)))

(defun adam/markdown-imenu-create-nested-index ()
  "Return a nested imenu index with headings and bullet list items."
  (let ((nested (markdown-imenu-create-nested-index))
        (items (adam/markdown-imenu-list-items)))
    (if items
        (nconc nested (list (cons "-" items)))
      nested)))

(defun adam/markdown-imenu-create-flat-index ()
  "Return a flat imenu index with headings and bullet list items."
  (let ((flat (markdown-imenu-create-flat-index))
        (items (adam/markdown-imenu-list-items)))
    (if items
        (nconc flat (list (cons "-" items)))
      flat)))

;;;###autoload
(define-minor-mode adam-markdown-tools-mode
  "Minor mode for some custom tools and additions to the default `markdown-mode' experiance."
  :lighter " adam-markdown-tools"
  (if adam-markdown-tools-mode
      (progn
        (add-to-invisibility-spec adam/markdown-link-invisible)
        (font-lock-add-keywords nil adam/markdown-hide-hash-keywords 'append)
        (font-lock-add-keywords nil adam/markdown-hide-link-keywords 'append)
        (setq-local imenu-create-index-function
                    (if markdown-nested-imenu-heading-index
                        #'adam/markdown-imenu-create-nested-index
                      #'adam/markdown-imenu-create-flat-index)))
    (remove-from-invisibility-spec adam/markdown-link-invisible)
    (font-lock-remove-keywords nil adam/markdown-hide-hash-keywords)
    (font-lock-remove-keywords nil adam/markdown-hide-link-keywords)
    (setq-local imenu-create-index-function
                (if markdown-nested-imenu-heading-index
                    #'markdown-imenu-create-nested-index
                  #'markdown-imenu-create-flat-index)))
  (when font-lock-mode
    (font-lock-flush)))

(provide 'adam-markdown-tools)
;;; adam-markdown-tools.el ends here
