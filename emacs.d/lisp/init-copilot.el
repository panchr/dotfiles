;;; init-copilot.el --- GitHub Copilot support -*- lexical-binding: t -*-

;;; Code:

(use-package s
  :ensure t)
(use-package dash
  :ensure t)
(use-package editorconfig
  :ensure t)

(use-package copilot
  :ensure nil
  :after (:all s dash editorconfig)
  ;; Don't show in mode line.
  :diminish

  ;; Automatically start copilot mode.
  :config
  (progn
	(global-copilot-mode)))

;; Taken from https://github.com/rksm/copilot-emacsd.
(defun rk/copilot-complete-or-accept ()
  "Command that either triggers a completion or accepts one if one
is available. Useful if you tend to hammer your keys like I do."
  (interactive)
  (if (copilot--overlay-visible)
	  (progn
		(copilot-accept-completion)
		(open-line 1)
		(next-line))
	(copilot-complete)))

(defun rk/copilot-quit ()
  "Run `copilot-clear-overlay' or `keyboard-quit'. If copilot is
cleared, make sure the overlay doesn't come back too soon."
  (interactive)
  (condition-case err
	  (when copilot--overlay
		(lexical-let ((pre-copilot-disable-predicates copilot-disable-predicates))
		  (setq copilot-disable-predicates (list (lambda () t)))
		  (copilot-clear-overlay)
		  (run-with-idle-timer
		   1.0
		   nil
		   (lambda ()
			 (setq copilot-disable-predicates pre-copilot-disable-predicates)))))
	(error handler)))

(defun rk/no-copilot-mode ()
  "Helper for `rk/no-copilot-modes'."
  (copilot-mode -1))

(defvar rk/copilot-manual-mode nil
  "When `t' will only show completions when manually triggered, e.g. via M-C-<return>.")

(defvar rk/no-copilot-modes '(shell-mode
							  inferior-python-mode
							  eshell-mode
							  term-mode
							  vterm-mode
							  comint-mode
							  compilation-mode
							  debugger-mode
							  dired-mode-hook
							  compilation-mode-hook
							  flutter-mode-hook
							  minibuffer-mode-hook
							  magit-mode)
  "Modes in which copilot is inconvenient.")

(defun rk/copilot-disable-predicate ()
  "When copilot should not automatically show completions."
  (or rk/copilot-manual-mode
	  (member major-mode rk/no-copilot-modes)
	  (company--active-p)))

(add-to-list 'copilot-disable-predicates #'rk/copilot-disable-predicate)

;; These keybinds cannot be added using :bind because it prevents the copilot
;; package from loading. Why? I have no idea.
(define-key copilot-mode-map (kbd "C-c a") #'rk/copilot-complete-or-accept)
(advice-add 'keyboard-quit :before #'rk/copilot-quit)

(provide 'init-copilot)
;;; init-copilot.el ends here
