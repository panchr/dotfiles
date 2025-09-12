;;; init.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;;; Code:

;; Produce backtraces when errors occur
(setq debug-on-error t)

(let ((minver "26.1"))
  (when (version< emacs-version minver)
    (error "Your Emacs is too old -- this config requires v%s or higher" minver)))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(require 'init-benchmarking) ;; Measure startup time

(defconst *spell-check-support-enabled* nil) ;; Enable with t if you prefer
(defconst *is-a-mac* (eq system-type 'darwin))

;;----------------------------------------------------------------------------
;; Adjust garbage collection thresholds during startup, and thereafter
;;----------------------------------------------------------------------------
(let ((normal-gc-cons-threshold (* 20 1024 1024))
      (init-gc-cons-threshold (* 128 1024 1024)))
  (setq gc-cons-threshold init-gc-cons-threshold)
  (add-hook 'emacs-startup-hook
            (lambda () (setq gc-cons-threshold normal-gc-cons-threshold))))

;;----------------------------------------------------------------------------
;; Bootstrap config
;;----------------------------------------------------------------------------
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(require 'init-utils)
(require 'init-site-lisp) ;; Must come before elpa, as it may provide package.el
;; Calls (package-initialize)
(require 'init-elpa)      ;; Machinery for installing required packages
(require 'init-exec-path) ;; Set up $PATH

;;----------------------------------------------------------------------------
;; Allow users to provide an optional "init-preload-local.el"
;;----------------------------------------------------------------------------
(require 'init-preload-local nil t)

;;----------------------------------------------------------------------------
;; Load configs for specific features and modes
;;----------------------------------------------------------------------------

(require-package 'diminish)
(maybe-require-package 'scratch)
(require-package 'command-log-mode)

(require 'init-frame-hooks)
(require 'init-xterm)
(require 'init-themes)
(require 'init-osx-keys)
(require 'init-isearch)
(require 'init-ibuffer)
(require 'init-dired)
(require 'init-grep)
(require 'init-uniquify)
;; (require 'init-recentf)
(require 'init-ivy)
(require 'init-hippie-expand)
(require 'init-company)
(require 'init-mmm)
;; (require 'init-flycheck)

(require 'init-editing-utils)
(require 'init-whitespace)

(require 'init-git)

(require 'init-projectile)
(require 'init-compile)
(require 'init-copilot)

(require 'init-markdown)
(require 'init-csv)
(require 'init-javascript)
(require 'init-html)
(require 'init-css)
(require 'init-python)
(require 'init-ruby)
(require 'init-rails)
(require 'init-yaml)
(require 'init-docker)
(require 'init-go)
(require 'init-bazel)
(require 'init-terraform)
(require 'init-php)
(require 'init-java)
(maybe-require-package 'nginx-mode)

;; (require 'init-paredit)
;; (require 'init-lisp)
;; (require 'init-common-lisp)

(when *spell-check-support-enabled*
  (require 'init-spelling))

(require 'init-misc)

;; NOT USED
;; (require 'init-smex)
;; (require 'init-gui-frames)
;; (require 'init-windows)
;; (require 'init-sessions)
;; (require 'init-vc)
;; (require 'init-darcs)
;; (require 'init-folding)
;; (require 'init-dash)
;; (require 'init-ledger)

;;----------------------------------------------------------------------------
;; Allow access from emacsclient
;;----------------------------------------------------------------------------
(add-hook 'after-init-hook
          (lambda ()
            (require 'server)
            (unless (server-running-p)
              (server-start))))

;;----------------------------------------------------------------------------
;; Variables configured via the interactive 'customize' interface
;;----------------------------------------------------------------------------
(when (file-exists-p custom-file)
  (load custom-file))


;;----------------------------------------------------------------------------
;; Locales (setting them earlier in this file doesn't work in X)
;;----------------------------------------------------------------------------
(require 'init-locales)


;;----------------------------------------------------------------------------
;; Allow users to provide an optional "init-local" containing personal settings
;;----------------------------------------------------------------------------
(require 'init-local nil t)



(provide 'init)

;; Local Variables:
;; coding: utf-8
;; no-byte-compile: t
;; End:
;;; init.el ends here
