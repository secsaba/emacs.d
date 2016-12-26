;;; init.el --- Sets up Emacs environment
;;; Commentary:

;;; Code:

;; Bootstrap 'use-package'

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Emacs configuration

(setq inhibit-startup-screen t)

(tool-bar-mode -1)
(scroll-bar-mode -1)
(savehist-mode 1)
(blink-cursor-mode -1)
(setq ring-bell-function 'ignore)
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)
(setq require-final-newline t)
(desktop-save-mode t)

(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file 'noerror)

(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))
(setq vc-make-backup-files t)

;; Easy windows switching

(use-package ace-window
  :ensure t
  :bind ("M-p" . ace-window))

;; Display current search and total search

(use-package anzu
  :ensure t
  :config
  (global-anzu-mode))

;; Never loose your cursor

(use-package beacon
  :ensure t
  :config
  (beacon-mode 1))

;; A collection of ridiculously useful extensions

(use-package crux
  :ensure t
  :bind (("C-^" . crux-top-join-line)
	 ("C-s-<return>" . crux-smart-open-line-above)
	 ("s-<return>" . crux-smart-open-line)
	 ("C-c k" . crux-kill-other-buffers)))

;; Set the path

(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)
    (exec-path-from-shell-copy-env "GOPATH")))

;; Save point position between sessions.

(use-package saveplace
  :ensure t
  :config
  (progn
    (setq-default save-place t)
    (setq save-place-file (expand-file-name "places" user-emacs-directory))))

;; A generic completion framework

(use-package smex
  :ensure t)

(use-package flx
  :ensure t)

(use-package ivy
  :ensure t
  :bind (:map ivy-minibuffer-map ("C-'" . ivy-avy))
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
	ivy-height 10
	ivy-initial-inputs-alist nil
	ivy-count-format ""
	ivy-virtual-abbreviate 'full
	ivy-extra-directories nil
	ivy-wrap t)
  (setq ivy-re-builders-alist '((swiper . ivy--regex-plus)
				(t . ivy--regex-fuzzy))))

(use-package counsel
  :ensure t
  :config
  (counsel-mode 1))

;; Modular in-buffer completion

(use-package company
  :ensure t
  :config
  (global-company-mode))

;; Feed reader

(use-package elfeed
  :ensure t
  :config
  (setq elfeed-feeds
	'(;; Emacs
	  ("http://emacshorrors.com/feed.atom" blog emacs)
	  ("http://irreal.org/blog/?feed=rss2" blog emacs)
	  ("https://www.masteringemacs.org/feed" blog emacs)
	  ("http://planet.emacsen.org/atom.xml" emacs planet)
	  ("https://www.reddit.com/r/emacs/.rss" reddit emacs)
	  ;; Go language
	  ("https://www.reddit.com/r/golang/.rss" reddit go)
	  ("http://golangweekly.com/rss/2568jh79" weekly go)
	  ("http://blog.golang.org/feed.atom" blog go))))

;; Flycheck

(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode))

;; Markdown mode

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; Magit

(use-package magit
  :ensure t
  :commands magit-get-top-dir
  :bind ("C-x g" . magit-status)
  :config
  (magit-auto-revert-mode))

;; YASnippet - a template system

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode))

;; Org

(use-package org
  :ensure t
  :bind (("C-c a" . org-agenda)
	 ("C-c c" . org-capture)))

;; Go language

(use-package go-mode
  :ensure t
  :config
  (progn
    (setq gofmt-command "goimports")
    (add-hook 'before-save-hook #'gofmt-before-save)))

(use-package flycheck-gometalinter
  :ensure t
  :config
  (progn
    (flycheck-gometalinter-setup)
    (setq flycheck-gometalinter-vendor t)
    (setq flycheck-gometalinter-fast t)))

(use-package go-eldoc
  :ensure t
  :config
  (add-hook 'go-mode-hook 'go-eldoc-setup))

(use-package gotest
  :ensure t)

(use-package company-go
  :ensure t
  :config
  (eval-after-load 'company '(add-to-list 'company-backends 'company-go)))

;;; init.el ends here
