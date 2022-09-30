;;; init-dired.el --- Dired customisations -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(setq-default dired-dwim-target t)

;; Prefer g-prefixed coreutils version of standard utilities when available
(let ((gls (executable-find "gls")))
  (when gls (setq insert-directory-program gls)))

(when (maybe-require-package 'diredfl)
  (after-load 'dired
    (diredfl-global-mode)
    (require 'dired-x)))

;; Hook up dired-x global bindings without loading it up-front
(define-key ctl-x-map "\C-j" 'dired-jump)
(define-key ctl-x-4-map "\C-j" 'dired-jump-other-window)

(after-load 'dired
  (setq dired-recursive-deletes 'top)
  (define-key dired-mode-map [mouse-2] 'dired-find-file)
  (define-key dired-mode-map (kbd "C-c C-q") 'wdired-change-to-wdired-mode))

(when (maybe-require-package 'diff-hl)
  (after-load 'dired
    (add-hook 'dired-mode-hook 'diff-hl-dired-mode)))

;; Treemacs setup - nicer file browsing.
(use-package treemacs
  :ensure t
  :defer t
  :init
  :config
  (progn
    (treemacs-follow-mode nil))

  :bind
  (:map global-map
        ("C-x t"   . treemacs-add-and-display-current-project))
  (:map treemacs-mode-map
		("k"       . treemacs-remove-project-from-workspace)
		("C-x t"   . treemacs)))

(when (package-installed-p 'magit)
  (use-package treemacs-magit
	:after (treemacs magit)
	:ensure t))

(provide 'init-dired)
;;; init-dired.el ends here
