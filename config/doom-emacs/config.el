;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Aditya Sadawarte"
      user-mail-address "aditya.sadawarte@outlook.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
(setq doom-font (font-spec :family "Mononoki" :size 16 :weight 'regular))

;; Theme
(setq doom-theme 'doom-dracula)

;; Org directory
(setq org-directory "~/org/")

;; Line numbers
(setq display-line-numbers-type 'relative)

;; Maximize every windows on startup
;; (add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Toggle info on fullscreen toggle
(advice-add 'toggle-frame-fullscreen :after 'on-toggle-frame-fullscreen)
(defun on-toggle-frame-fullscreen ()
  (let ((fullscreen (frame-parameter nil 'fullscreen)))
    (if (memq fullscreen '(fullscreen fullboth))
        (toggle-frame-fullscreen-info 1)
      (toggle-frame-fullscreen-info 0))))
(defun toggle-frame-fullscreen-info (mode)
  (display-battery-mode mode)
  (display-time-mode mode))

;; Undo granularity
;; (setq evil-want-fine-undo t)

;; Remove kill confirmation
(setq confirm-kill-emacs nil)

;; Run before killing emacs daemon
(add-hook 'kill-emacs-hook 'on-emacs-daemon-kill)
(defun on-emacs-daemon-kill ()
  (when (daemonp)
    (save-some-buffers 1)))

;; Disable evil access to system clipboard
(setq select-enable-clipboard nil)

;; Insert mode ctrl-v
(define-key evil-insert-state-map (kbd "C-v")
  (lambda ()
    (interactive)
    (call-interactively 'evil-paste-from-register)))

;; Basic config
(setq display-time-format "%I:%M")

;;; IDE config

;; Microsoft python language server
(after! lsp-python-ms
  (set-lsp-priority! 'mspyls 1))

;; Restart python language server on virtual environment change
(add-hook 'pyvenv-post-activate-hooks 'lsp-restart-python)
(add-hook 'pyvenv-post-deactivate-hooks 'lsp-restart-python)
(defun lsp-restart-python ()
  (mapc
   (lambda (workspace)
     (when (member (lsp--client-server-id (lsp--workspace-client workspace))
                   '(mspyls pyls))
       (lsp-workspace-restart workspace)))
   (lsp--session-workspaces (lsp-session))))

;; Sync directory
(setq sync-directory "~/Sync/org")

;; Convert org files [from org directory] to markdown on save and move them to sync directory
(add-hook 'org-mode-hook
          (lambda ()
            (add-hook 'after-save-hook 'org-to-markdown nil t)))
(defun org-to-markdown ()
  (if (string-prefix-p (file-truename org-directory) default-directory)
      (progn
        (org-md-export-to-markdown)
        (let ((new-org-directory (concat sync-directory
                                         "/"
                                         (substring default-directory
                                                    (length (file-truename org-directory))))))
          (make-directory new-org-directory t)
          (rename-file
           (concat default-directory
                   (concat (file-name-sans-extension
                            (file-name-nondirectory buffer-file-name)) ".md"))
           (concat new-org-directory) t)))))

;; Here are some additional functions/macros that could help you configure Doom:
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
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Disable checkdoc errors for current buffer
(setq flycheck-disabled-checkers '(emacs-lisp-checkdoc))

;; Local Variables:
;; byte-compile-warnings: (not free-vars unresolved)
;; End:
