;;; init-python.el --- Python editing -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(setq auto-mode-alist
      (append '(("SConstruct\\'" . python-mode)
                ("SConscript\\'" . python-mode))
              auto-mode-alist))

(require-package 'pip-requirements)

;; Allow tabs
(add-hook 'python-mode-hook
	  (lambda () (setq indent-tabs-mode nil
			   python-indent-offset 4
			   python-indent-guess-indent-offset t)))

;; TODO(rushy_panchal): Switch to lsp-mode and LSP's support for Python
;; instead.
;; Configure elpy to use python3, not python, on MacOS.
;; After MacOS 12.3, the python binary was removed.
(when *is-a-mac*
  (setq-default elpy-rpc-python-command "python3")
  (setq-default python-shell-interpreter "python3"))

(when (maybe-require-package 'anaconda-mode)
  (after-load 'python
    (add-hook 'python-mode-hook 'anaconda-mode)
    (add-hook 'python-mode-hook 'anaconda-eldoc-mode))
  (after-load 'anaconda-mode
    (define-key anaconda-mode-map (kbd "M-?") nil))
  (when (maybe-require-package 'company-anaconda)
    (after-load 'company
      (after-load 'python
        (push 'company-anaconda company-backends)))))


(provide 'init-python)
;;; init-python.el ends here
