(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(archive-zip-use-pkzip nil)
 '(case-fold-search t)
 '(column-number-mode t)
 '(confirm-kill-emacs (quote y-or-n-p))
 '(delete-selection-mode t)
 '(display-time-day-and-date t)
 '(display-time-mode t nil (time))
 '(global-font-lock-mode t)
 '(grep-command "grep -n -i -r ")
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(initial-scratch-message nil)
 '(kill-whole-line t)
 '(menu-bar-mode nil)
 '(safe-local-variable-values (quote ((require-final-newline . t))))
 '(suggest-key-bindings nil)
 '(tab-width 4)
 '(transient-mark-mode t)
 '(truncate-lines t)
 '(visible-bell t)
 '(x-select-enable-clipboard t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ec2-instance-terminated-face ((t (:background "yellow" :foreground "black")))))

(setq linum-format "%d ")
(global-set-key (kbd "C-c l") 'linum-mode)

;; ======================================================================
;; Terse affirmations
;; ======================================================================

(fset 'yes-or-no-p 'y-or-n-p)

;; ======================================================================
;; Initial Setting of the display
;; ======================================================================

(setq default-mode-line-format '("-"
                                 mode-line-mule-info
                                 mode-line-modified
                                 mode-line-frame-identification
                                 mode-line-buffer-identification
                                 " "
                                 mode-line-position
                                 (-3 . "%p")
                                 " "
                                 global-mode-string
                                 "   %[("
                                 mode-name mode-line-process
                                 minor-mode-alist "%n" ")%]--"
                                 "-%-"))

;; ======================================================================
;; Insert-box support
;; ======================================================================

(defun insert-box (start end text)
  "Insert a text prefix at a column in all the lines in the region.
   Called from a program, takes three arguments, START, END, and TEXT.
   The column is taken from that of START.
   The rough inverse of this function is kill-rectangle.

  COMMON BINDINGS: Only Available via M-x"
  (interactive "r\nsText To Insert: ")
  (save-excursion
    (let (cc)
      ;; the point-marker stuff is needed to keep the edits from changing
      ;; where end is
      (goto-char end)
      (setq end (point-marker))
      (goto-char start)
      (setq cc  (current-column))
      (while (< (point) end) ;; modified 2/2/88
        ;; I should here check for tab chars
        (insert text)
        (forward-line 1)
        (move-to-column-force cc)) ;; Alternate: use move-to-column if you must.
      (move-marker end nil))))

(defun move-to-column-force (column)
  "Move to column COLUMN in current line.
Differs from move-to-column in that it creates or modifies whitespace
if necessary to attain exactly the specified column.

This version (non-standard) insures that the column is visible,
scrolling if needed."
  (move-to-column column)
  (let ((col (current-column)))
    (if (< col column)
        (indent-to column)
      (if (and (/= col column)
               (= (preceding-char) ?\t))
          (let (indent-tabs-mode)
            (delete-char -1)
            (indent-to col)
            (move-to-column column)))))
  )

;; ======================================================================

(global-set-key "\C-cd"      'goto-line)

(global-set-key "\C-c:"      'uncomment-region)
(global-set-key "\C-c;"      'comment-region)

(global-set-key "\C-cb"      'bookmark-jump)
(global-set-key "\C-cf"      'browse-url-of-dired-file)

(global-set-key "\C-cg"      'grep-find)

(global-set-key "\C-cr"      'browse-url-at-point)
(global-set-key "\C-ct"      'find-file-at-point)

(global-set-key "\C-x,"      'compile)

(global-set-key "\C-x\C-b"   'electric-buffer-list)

(global-set-key "\C-x\C-i"   'insert-box)
(global-set-key "\C-x\C-d"   'delete-rectangle)
(global-set-key "\C-cg"      'magit-status)

;; ======================================================================

;; Enable filename completion
;;(define-key minibuffer-local-filename-completion-map
;;  " " 'minibuffer-complete-word)

;; (progn
;;   (define-key minibuffer-local-completion-map " " 'minibuffer-complete-word)
;;   (define-key minibuffer-local-filename-completion-map " " 'minibuffer-complete-word)
;;   (define-key minibuffer-local-must-match-filename-map " " 'minibuffer-complete-word))

;; ======================================================================
;; 
(put 'dired-find-alternate-file 'disabled nil)
;; 
;; ======================================================================

(put 'set-goal-column 'disabled nil)

(fset 'get_cwd_dired_other_window
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("o<  wo" 0 "%d")) arg)))

(global-set-key "\C-co"      'get_cwd_dired_other_window)

;; ======================================================================

(global-set-key "\C-ci"      'list-faces-display)

;; ======================================================================

;; make a face
(make-face 'font-lock-small-face)

(set-face-attribute 'font-lock-small-face
                    nil
                    :foreground "white" :background "red") ; have smaller font.
     
;; ======================================================================

(require 'dired)
