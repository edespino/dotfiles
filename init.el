(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(archive-zip-use-pkzip nil)
 '(case-fold-search t)
 '(column-number-mode t)
 '(confirm-kill-emacs (quote y-or-n-p))
 '(custom-safe-themes
   (quote
    ("c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" default)))
 '(delete-selection-mode t)
 '(display-time-day-and-date t)
 '(display-time-mode t nil (time))
 '(global-font-lock-mode t)
 '(grep-command "grep -n -i -r ")
 '(ack-command "ack -i ")
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(initial-scratch-message nil)
 '(kill-whole-line t)
 '(magit-branch-arguments nil)
 '(markdown-open-command "/Users/eespino/bin/mark")
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
    (ack smart-mode-line org-bullets magit zenburn-theme)))
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

(global-set-key "\C-cd"    'goto-line)

(global-set-key "\C-c:"    'uncomment-region)
(global-set-key "\C-c;"    'comment-region)

(global-set-key "\C-cb"    'bookmark-jump)
(global-set-key "\C-cf"    'browse-url-of-dired-file)
(global-set-key "\C-ct"    'find-file-at-point)

(global-set-key "\C-x,"    'compile)

(global-set-key "\C-x\C-b" 'electric-buffer-list)

(global-set-key "\C-cg"    'magit-status)

;; ======================================================================

(put 'set-goal-column 'disabled nil)

(fset 'get_cwd_dired_other_window
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("o<  wo" 0 "%d")) arg)))

(global-set-key "\C-co"      'get_cwd_dired_other_window)

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
        magit
        org-bullets
        smart-mode-line
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

(global-set-key [?\C-x ?\C-y] 'pt-pbpaste)
(global-set-key [?\C-x ?\M-w] 'pt-pbcopy)

;; ======================================================================

(define-key global-map (kbd "C-c C-g l") 'magit-log-buffer-file)
(define-key global-map (kbd "C-c C-g b") 'magit-blame)
(define-key global-map (kbd "C-c C-g q") 'magit-blame-quit)

;; ======================================================================

(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
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

(setq sml/theme 'respectful)
(sml/setup)

;; ======================================================================

(setq mouse-drag-copy-region t)

;; ======================================================================

;; from http://emacswiki.org/emacs/InsertingTodaysDate
(defun insert-todays-date (arg)
  (interactive "P")
  (insert (if arg
              (format-time-string "%a, %b %d, %Y")
            (format-time-string "%a, %b %d, %Y - %H:%M:%S"))))

;; ======================================================================
