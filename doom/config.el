;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
;;
;; Produce backtraces when errors occur
(setq debug-on-error t)

(let ((minver "30.2"))
  (when (version< emacs-version minver)
    (error "Your Emacs is too old -- this config requires v%s or higher" minver)))

(defconst *is-a-mac* (eq system-type 'darwin))
(defconst *tty* (eq (display-graphic-p) nil))

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function.
(setq doom-theme 'sanityinc-tomorrow-night)
;; (custom-theme-set-faces! 'doom-one
;;   '(default :background "#000000"))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;;(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;;(setq org-directory "~/org/")

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; TODO(rushy_panchal): Use add-load-path! to separate out some configuration.

;; Editing configuration
(setq-default cursor-type 'bar
              tooltip-delay 1.5
              tab-width 4
              scroll-preserve-screen-position 'always
              confirm-kill-emacs nil
              ;; Allow scrolling to the end of a buffer even if we're close to the end.
              scroll-error-top-bottom t)

;; Delete a selection when inserting into it.
(delete-selection-mode)

(global-set-key (kbd "C-x C-_") 'comment-line)
(global-set-key (kbd "C-c w") 'kill-ring-save)

(use-package visual-regexp-steroids
  :config
  ;; Better regexp (Python-style!)
  (global-set-key (kbd "C-c r") 'vr/replace)
  (global-set-key (kbd "C-c q") 'vr/query-replace)
  ;; if you use multiple-cursors, this is for you:
  ;; (define-key global-map (kbd "C-c m") 'vr/mc-mark)
  (define-key esc-map (kbd "C-r") 'vr/isearch-backward) ;; C-M-r
  (define-key esc-map (kbd "C-s") 'vr/isearch-forward)) ;; C-M-s)

;; Treemacs setup - nicer file browsing.
(use-package treemacs
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
  (defun treemacs-select-if-visible ()
    "Selects the treemacs buffer, if it is visible."
    (interactive)
    (when (eq (treemacs-current-visibility) 'visible)
      (treemacs-select-window)))

  :config
  (global-set-key (kbd "C-x t") 'treemacs-toggle-project-exclusively)
  (global-set-key (kbd "C-x p") 'treemacs-select-if-visible)
  (setq +treemacs-git-mode 'deferred)

  ;; Settings treemacs-no-png-images doesn't disable image icons in tty mode,
  ;; for some reason. So, use a theme to explicitly disable them.
  (treemacs-create-theme "tty-no-icons"
    :config
    (progn
      (treemacs-create-icon :icon "- " :extensions (root-open) :fallback 'same-as-icon)
      (treemacs-create-icon :icon "+ " :extensions (root-closed) :fallback 'same-as-icon)
      (treemacs-create-icon :icon "- " :extensions (dir-open) :fallback 'same-as-icon)
      (treemacs-create-icon :icon "+ " :extensions (dir-closed) :fallback 'same-as-icon)
      (treemacs-create-icon :icon "  " :extensions (fallback) :fallback 'same-as-icon)))
  (when *tty*
    (setq treemacs-no-png-images t)
    (treemacs-load-theme "tty-no-icons")))

;; Use magit extensions for treemacs.
(use-package treemacs-magit
  :after (treemacs magit))

;; centaur.
(use-package centaur-tabs
  :config
  (when *tty*
    (setq centaur-tabs-set-close-button nil
          centaur-tabs-set-icons nil)))

;; ibuffer.
(use-package ibuffer
  :config
  (define-ibuffer-column size-h
    (:name "Size" :inline t)
    (file-size-human-readable (buffer-size)))
  (setq ibuffer-formats
        '((mark modified read-only vc-status-mini " "
           (name 22 22 :left :elide)
           " "
           (size-h 9 -1 :right)
           " "
           (mode 12 12 :left :elide)
           " "
           vc-relative-file)
          (mark modified read-only vc-status-mini " "
                (name 22 22 :left :elide)
                " "
                (size-h 9 -1 :right)
                " "
                (mode 14 14 :left :elide)
                " "
                (vc-status 12 12 :left)
                " "
                vc-relative-file)))
  (setq ibuffer-filter-group-name-face 'font-lock-doc-face))

(use-package lsp-python-ms
  :config (setq lsp-python-ms-auto-install-server t))

;; MacOS specific configuration.
(when *is-a-mac*
  (setq mac-command-modifier 'meta
        mac-option-modifier 'none)

  ;; Bind keys for copy/paste to clipboard
  (defun osx-copy-pasteboard (start end)
    "Copies to the OSX keyboard"
    (interactive "r")
    (if (use-region-p)
	(shell-command-on-region start end "pbcopy")
      ())
    )

  (global-set-key (kbd "C-x C-y") 'osx-copy-pasteboard))
