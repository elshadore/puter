# FZF-Style Fuzzy Matching for Ivy

## Current State
Location: `/home/adam/puter/dotfiles/.emacs.d/init.el:153-156`

```elisp
(defun adam/fuzzy-re-builder (str)
  "Fuzzy find (FZF), on the string STR. Specifically used for ivy as an ivy-rebuilder."
  (let ((case-fold-search t))
    (ivy--regex-plus str)))
```

**Problem**: This just wraps `ivy--regex-plus` which does substring/word-boundary matching, not true FZF-style character-level fuzzy matching.

## FZF Algorithm

FZF's core matching principles:
1. **Character-by-character matching** - Each char in query must appear in order in the candidate
2. **Non-contiguous matching** - Characters can be scattered throughout the string
3. **Scoring priorities**:
   - Consecutive character matches (bonus)
   - Matches at word boundaries (camelCase, underscores, slashes)
   - Matches at string start
   - Shorter gaps between matched characters

## Implementation

### Replace lines 153-156 with:

```elisp
(defun adam/fuzzy--regex-from-string (str)
  "Convert STR to a FZF-style fuzzy regex pattern."
  (if (string-empty-p str)
      ""
    (let* ((chars (string-to-list str))
           (first (regexp-quote (char-to-string (car chars))))
           (rest (mapcar (lambda (c)
                          (concat ".*" (regexp-quote (char-to-string c))))
                        (cdr chars))))
      (concat first (mapconcat #'identity rest "")))))

(defun adam/fuzzy-re-builder (str)
  "FZF-style fuzzy regex builder for ivy.
Converts query string STR into a fuzzy matching regex where each
character must appear in order but not necessarily consecutively."
  (let ((case-fold-search t))
    (if (string-empty-p str)
        ""
      (let ((terms (split-string str " +" t)))
        (if (= (length terms) 1)
            (adam/fuzzy--regex-from-string (car terms))
          (mapconcat #'adam/fuzzy--regex-from-string terms ".*"))))))
```

## How It Works

### Example Transformations:
- `"fbr"` → `"f.*b.*r"` matches `"find-buffer"` (f-b-r in order)
- `"fb"` → `"f.*b"` matches `"find-buffer"`, `"file-browser"`
- `"foo bar"` → `"foo.*bar"` (space = AND logic with gap)

### Key Features:
1. **Character-level fuzzy**: Each query char becomes a literal with `.*` between
2. **Space-separated AND**: Multiple terms joined with `.*` for AND logic
3. **Regex escaping**: `regexp-quote` handles special characters safely
4. **Case-insensitive**: `case-fold-search` preserves existing behavior

## Testing

After applying, test with:
- `C-s` (swiper) - search with `"fbr"` should match `"find-buffer"`
- `C-x b` (buffer switch) - type partial chars to fuzzy match buffer names
- `M-x` (counsel-M-x) - fuzzy match command names

## Tradeoffs

**Pros**:
- True FZF-style character-level matching
- Simple, efficient regex-based approach
- Works with ivy's existing ranking

**Cons**:
- Ivy handles ranking (not full FZF scoring algorithm)
- No special boundary bonuses (camelCase, etc.) - would need ivy scoring customization
- Regex-based may be slower on very large collections vs FZF's optimized C implementation
