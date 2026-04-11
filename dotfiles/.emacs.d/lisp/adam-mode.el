;;; package -- Summary
;;; Commentary:
;;; Code:

(require 'adam)
(require 'adam-window)

(global-set-key (kbd "M-l") 'awin/move-left)

(define-minor-mode adam-mode
  "Adam global mode for Adam based sheringans!"
  1
  :global t
  :group 'adam
  :lighter " adam-mode"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "M-x") 'adam/M-x)
            (define-key map (kbd "C-,") 'adam/move-to-top)
            (define-key map (kbd "C-x SPC") 'adam/M-x)

            (define-key map (kbd "C-x k") 'kill-buffer)
            (define-key map (kbd "C-x K") 'kill-buffer-and-window)

            (define-key map (kbd "C-x w 1") 'delete-other-windows)
            (define-key map (kbd "C-x w n") 'evil-window-split)
            (define-key map (kbd "C-x w v") 'evil-window-vsplit)
            (define-key map (kbd "C-x w w") 'evil-window-next)
            (define-key map (kbd "C-x w k") 'evil-window-delete)
            (define-key map (kbd "C-x w h") 'awin/move-left)
            (define-key map (kbd "C-x w j") 'awin/move-down)
            (define-key map (kbd "C-x w k") 'awin/move-up)
            (define-key map (kbd "C-x w l") 'awin/move-right)

            (define-key map (kbd "C-c r") 'repeat-complex-command)
            (define-key map (kbd "C-c C-r") 'repeat-complex-command)

            (define-key map (kbd "M-<left>") 'awin/move-left)
            (define-key map (kbd "M-<down>") 'awin/move-down)
            (define-key map (kbd "M-<up>") 'awin/move-up)
            (define-key map (kbd "M-<right>") 'awin/move-right)

            (define-key map (kbd "M-h") 'awin/move-left)
            (define-key map (kbd "M-j") 'awin/move-down)
            (define-key map (kbd "M-k") 'awin/move-up)
            (define-key map (kbd "M-l") 'awin/move-right)

            (define-key map (kbd "M-H") 'awin/swap-left)
            (define-key map (kbd "M-J") 'awin/swap-down)
            (define-key map (kbd "M-K") 'awin/swap-up)
            (define-key map (kbd "M-L") 'awin/swap-right)

            (define-key map (kbd "C-M-h") 'awin/split-left)
            (define-key map (kbd "C-M-j") 'awin/split-down)
            (define-key map (kbd "C-M-k") 'awin/split-up)
            (define-key map (kbd "C-M-l") 'awin/split-right)

            (define-key map (kbd "M-m") 'awin/maximize)

            (define-key map (kbd "C-x c f")
                        #'(lambda () (interactive) (kill-new (buffer-file-name))))
            (define-key map (kbd "C-x c d")
                        #'(lambda ()
                            (interactive)
                            (kill-new
                             (file-name-directory (buffer-file-name)))))
            map))

(provide 'adam-mode)
;;; adam-mode.el ends here
