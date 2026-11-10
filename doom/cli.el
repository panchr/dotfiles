;;; $DOOMDIR/cli.el -*- lexical-binding: t; -*-

;; Loaded by the `doom' CLI, not by interactive Emacs.

(defvar +straight-recipe-repos
  '("melpa" "nongnu-elpa" "gnu-elpa-mirror" "el-get" "emacsmirror-mirror")
  "Local repo names of the recipe repositories Doom registers with straight.")

(defun +straight--git (repo-dir &rest args)
  "Run git ARGS in REPO-DIR. Return trimmed stdout, or nil if git fails."
  (with-temp-buffer
    (when (zerop (apply #'call-process "git" nil '(t nil) nil "-C" repo-dir args))
      (string-trim (buffer-string)))))

(defun +straight-follow-default-branch (repo-dir)
  "Point the clone at REPO-DIR at its remote's current default branch.
Return the new branch name if the clone was repointed, otherwise nil.

Straight clones a single branch and keeps fetching it forever, so once an
upstream renames its default branch (as MELPA did, master to main) every fetch
fails. Recipe repos carry no local work, so jumping to the remote tip is safe."
  (when-let* ((local (+straight--git repo-dir "symbolic-ref" "--short" "HEAD"))
              (ls-remote (+straight--git repo-dir "ls-remote" "--symref" "origin" "HEAD"))
              (remote (and (string-match "^ref: refs/heads/\\(\\S-+\\)\tHEAD" ls-remote)
                           (match-string 1 ls-remote)))
              ((not (equal local remote))))
    (and (+straight--git repo-dir "config" "remote.origin.fetch"
                         (format "+refs/heads/%s:refs/remotes/origin/%s" remote remote))
         (+straight--git repo-dir "fetch" "origin")
         (+straight--git repo-dir "remote" "set-head" "origin" remote)
         (+straight--git repo-dir "checkout" "-B" remote (concat "origin/" remote))
         (+straight--git repo-dir "branch" "-D" local)
         remote)))

(defun +straight-follow-recipe-repo-renames-h ()
  "Repoint recipe repos whose upstream renamed its default branch.
Doom fetches every recipe repo before installing a new package, so one stale
clone aborts the whole sync."
  (dolist (name +straight-recipe-repos)
    (let ((repo-dir (file-name-concat doom-local-dir "straight" "repos" name)))
      (when-let* (((file-directory-p repo-dir))
                  (branch (+straight-follow-default-branch repo-dir)))
        (print! (item "Repointed %s at its renamed default branch %s") name branch)))))

(add-hook 'doom-before-sync-hook #'+straight-follow-recipe-repo-renames-h)
