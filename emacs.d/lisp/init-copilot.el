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
  ;; don't show in mode line
  :diminish)

(provide 'init-copilot)
;;; init-copilot.el ends here
