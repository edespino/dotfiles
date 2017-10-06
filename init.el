(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ack-command "ack -i ")
 '(archive-zip-use-pkzip nil)
 '(case-fold-search t)
 '(column-number-mode t)
 '(confirm-kill-emacs (quote y-or-n-p))
 '(custom-safe-themes
   (quote
    ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default)))
 '(delete-selection-mode t)
 '(display-time-day-and-date t)
 '(display-time-mode t nil (time))
 '(global-font-lock-mode t)
 '(grep-command "grep -n -i -r ")
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(initial-scratch-message nil)
 '(kill-whole-line t)
 '(magit-branch-arguments nil)
 '(markdown-open-command "/Users/eespino/bin/mark")
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
    (ack bash-completion groovy-mode magit org-bullets shell-pop smart-mode-line xcscope zenburn-theme)))
 '(select-enable-clipboard t)
 '(shell-pop-full-span t)
 '(shell-pop-universal-key "")
 '(shell-pop-window-position "bottom")
 '(shell-pop-window-size 50)
 '(suggest-key-bindings nil)
 '(tab-width 4)
 '(transient-mark-mode t)
 '(truncate-lines t)
 '(visible-bell t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; ======================================================================
;; YesOrNoP
;; ======================================================================

(defalias 'yes-or-no-p 'y-or-n-p)

;; ======================================================================

(global-set-key (kbd "C-c d")   'goto-line)

(global-set-key (kbd "C-c :")   'uncomment-region)
(global-set-key (kbd "C-c ;")   'comment-region)

(global-set-key (kbd "C-c b")   'bookmark-jump)
(global-set-key (kbd "C-c f")   'browse-url-of-dired-file)
(global-set-key (kbd "C-c t")   'find-file-at-point)
(global-set-key (kbd "C-c p")   'shell-pop)

(global-set-key (kbd "C-x ,")   'compile)

(global-set-key (kbd "C-x C-b") 'electric-buffer-list)

(global-set-key (kbd "C-c g")   'magit-status)

;; ======================================================================

(put 'set-goal-column 'disabled nil)

(put 'dired-find-alternate-file 'disabled nil)

;; ======================================================================

;; Enable filename completion
(define-key
  minibuffer-local-filename-completion-map
  " " 'minibuffer-complete-word)

;; (progn
;;   (define-key minibuffer-local-completion-map " " 'minibuffer-complete-word)
;;   (define-key minibuffer-local-filename-completion-map " " 'minibuffer-complete-word)
;;   (define-key minibuffer-local-must-match-filename-map " " 'minibuffer-complete-word))

;; ======================================================================

(require 'cl)
(require 'package)

(setq cfg-var:packages
      '(
        ack
        bash-completion
        groovy-mode
        magit
        org-bullets
        shell-pop
        smart-mode-line
        xcscope
        zenburn-theme
        ))

(defun cfg:install-packages ()
    (let ((pkgs (remove-if #'package-installed-p cfg-var:packages)))
        (when pkgs
            (message "%s" "Emacs refresh packages database...")
            (package-refresh-contents)
            (message "%s" " done.")
            (dolist (p cfg-var:packages)
                (package-install p)))))

(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

(package-initialize)

(cfg:install-packages)

;; ======================================================================

(load-theme 'zenburn t)

;; ======================================================================

(defun pt-pbpaste ()
  "Paste data from pasteboard."
  (interactive)
  (shell-command-on-region
   (point)
   (if mark-active (mark) (point))
   "pbpaste" nil t))

(defun pt-pbcopy ()
  "Copy region to pasteboard."
  (interactive)
  (print (mark))
  (when mark-active
    (shell-command-on-region
     (point) (mark) "pbcopy")
    (kill-buffer "*Shell Command Output*")))

(global-set-key (kbd "C-x C-y") 'pt-pbpaste)
(global-set-key (kbd "C-x M-w") 'pt-pbcopy)

;; ======================================================================

(define-key global-map (kbd "C-c C-g l") 'magit-log-buffer-file)
(define-key global-map (kbd "C-c C-g b") 'magit-blame)
(define-key global-map (kbd "C-c C-g q") 'magit-blame-quit)

;; ======================================================================

(setq ediff-diff-options "--text")

(require 'org)
(define-key global-map (kbd "C-c l") 'org-store-link)
(define-key global-map (kbd "C-c a") 'org-agenda)
(setq org-log-done t)

(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; ======================================================================

;;(require 'helm)
;;(global-set-key (kbd "M-x") 'helm-M-x)
;;(helm-mode 1)
;;(global-set-key (kbd "C-x C-f") 'helm-find-files)
;;(require 'helm-fuzzier)
;;(helm-fuzzier-mode 1)

;; ======================================================================

;; (setq ido-enable-flex-matching t)
;; (setq ido-everywhere t)
;; (ido-mode 1)
;; (setq ido-use-filename-at-point 'guess)

;; ======================================================================

(setq sml/theme 'dark)
(sml/setup)

;; ======================================================================

(setq mouse-drag-copy-region t)

;; ======================================================================

(global-set-key (kbd "C-c e") 'insert-date)

(setq org-startup-indented t)
;; from https://www.emacswiki.org/emacs/InsertDate
(defun insert-date (prefix)
  "Insert the current date. With prefix-argument, use ISO format. With
   two prefix arguments, write out the day and month name."
  (interactive "P")
  (let ((format (cond
                 ((not prefix) "%a, %b %d, %Y")
                 ((equal prefix '(4)) "%a, %b %d, %Y - %H:%M:%S")
                 ((equal prefix '(16)) "%m/%d/%Y"))))
    (insert (format-time-string format))))

;; ======================================================================

(require 'shell-pop)
(require 'xcscope)
