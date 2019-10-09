;;; init-go.el --- Go editing -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require-package 'go-mode)
(setq gofmt-command "goimports")
(add-hook 'before-save-hook 'gofmt-before-save)
(provide 'init-go)
;;; init-go.el ends here
