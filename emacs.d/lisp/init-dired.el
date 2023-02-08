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
  :after (projectile)
  :init
  (defun treemacs-toggle-project-exclusively ()
	"Initialise or toggle treemacs, exclusively with the current project.
- If the treemacs window is visible, hide it.
- If a treemacs buffer exists but is not visible, show it.
- If no treemacs buffer exists for the current frame, create and show it with the current project exclusively."
	(interactive)
	(pcase (treemacs-current-visibility)
      ('visible (delete-window (treemacs-get-local-window)))
      ('exists  (treemacs-select-window))
      ('none    (treemacs-add-and-display-current-project-exclusively))))

  ;; bind-keys* overwrites any other key bindings, so this prevents other modes
  ;; from messing with this key binding (namely, ruby-mode).
  (bind-keys*
   ;; Open the current project if it is not already open.
   ("C-x t" . treemacs-toggle-project-exclusively)))

;; Use magit extensions if magit is installed.
(when (package-installed-p 'magit)
  (use-package treemacs-magit
	:after (treemacs magit)
	:ensure t))

(provide 'init-dired)
;;; init-dired.el ends here
