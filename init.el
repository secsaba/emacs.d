;;; init.el --- Sets up emacs environment
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
(load custom-file)

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
  (global-anzu-mode 1))

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
  (setq-default save-place t)
  (setq save-place-file (expand-file-name "places" user-emacs-directory)))

;; A generic completion framework

(use-package smex
  :ensure t)

(use-package counsel
  :ensure t)

(use-package swiper
  :ensure t
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) "))

;; Modular in-buffer completion

(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode)
  (setq company-idle-delay .3)
  (setq company-echo-delay 0)
  (setq company-begin-commands '(self-insert-command)))

;; Feed reader

(use-package elfeed
  :ensure t
  :config
  (setq elfeed-feeds
	'(;; emacs
	  ("http://emacshorrors.com/feed.atom" blog emacs)
	  ("http://irreal.org/blog/?feed=rss2" blog emacs)
	  ("https://www.masteringemacs.org/feed" blog emacs)
	  ("http://planet.emacsen.org/atom.xml" emacs planet)
	  ("https://www.reddit.com/r/emacs/.rss" reddit emacs))))

;; Flycheck

(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode)
  :config
  (add-hook 'go-mode-hook 'flycheck-mode))

;; Markdown mode

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; Go language

(use-package go-autocomplete
  :ensure t)

(use-package go-eldoc
  :ensure t
  :config
  (add-hook 'go-mode-hook 'go-eldoc-setup))

(use-package go-errcheck
  :ensure t)

(use-package company-go
  :ensure t
  :config
  (add-hook 'go-mode-hook (lambda ()
			    (set (make-local-variable 'company-backends) '(company-go))
			    (company-mode))))

(use-package go-mode
  :ensure t
  :config
  (setq gofmt-command "goimports"))

;;; init.el ends here
