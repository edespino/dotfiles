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
<<<<<<< HEAD
    (go-mode terraform-mode yaml-mode markdown-mode magit-gh-pulls psvn ack bash-completion cmake-mode flycheck flycheck-color-mode-line groovy-mode magit org-bullets smart-mode-line zenburn-theme)))
=======
    (nlinum-hl nlinum-relative terraform-mode yaml-mode markdown-mode magit-gh-pulls psvn ack bash-completion cmake-mode flycheck flycheck-color-mode-line groovy-mode magit org-bullets smart-mode-line zenburn-theme)))
>>>>>>> Add nlinum support.
 '(select-enable-clipboard t)
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
;;; This file bootstraps the configuration, which is divided into
;;; a number of other files.

(let ((minver "24.1"))
  (when (version< emacs-version minver)
    (error "Your Emacs is too old -- this config requires v%s or higher" minver)))
(when (version< emacs-version "24.4")
  (message "Your Emacs is old, and some functionality in this config will be disabled. Please upgrade if possible."))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(defconst *spell-check-support-enabled* t) ;; Enable with t if you prefer
(defconst *is-a-mac* (eq system-type 'darwin))

;;----------------------------------------------------------------------------
;; Bootstrap config
;;----------------------------------------------------------------------------

(require 'init-utils)
(require 'init-elpa)      ;; Machinery for installing required packages

;; ======================================================================

(global-set-key (kbd "C-c d")   'goto-line)

(global-set-key (kbd "C-c :")   'uncomment-region)
(global-set-key (kbd "C-c ;")   'comment-region)

(global-set-key (kbd "C-c b")   'bookmark-jump)
(global-set-key (kbd "C-c f")   'browse-url-of-dired-file)
(global-set-key (kbd "C-c t")   'find-file-at-point)

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
        cmake-mode
        flycheck
        flycheck-color-mode-line
        go-mode
        groovy-mode
        magit
        magit-gh-pulls
        markdown-mode
        nlinum-hl
        nlinum-relative
        org-bullets
        psvn
        smart-mode-line
        terraform-mode
        yaml-mode
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

;;----------------------------------------------------------------------------
;; Load configs for specific features and modes
;;----------------------------------------------------------------------------

(require 'init-flycheck)

(when *spell-check-support-enabled*
  (require 'init-spelling))

(add-hook 'org-mode-hook 'flyspell-mode)
(add-hook 'text-mode-hook 'flyspell-mode)

;; (require 'magit-gh-pulls)
;; (add-hook 'magit-mode-hook 'turn-on-magit-gh-pulls)

(autoload 'gfm-mode "markdown-mode"
   "Major mode for editing GitHub Flavored Markdown files" t)
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))

;(require 'nlinum)
;(setq global-nlinum-mode t)
;(setq nlinum-format "%d ")

(add-hook 'prog-mode-hook 'nlinum-relative-mode)
(setq nlinum-relative-redisplay-delay 0)   ;; delay
(setq nlinum-relative-current-symbol "->") ;; or "" for display current line number
(setq nlinum-relative-offset 0)            ;; 1 if you want 0, 2, 3...
(setq nlinum-format "%d ")
