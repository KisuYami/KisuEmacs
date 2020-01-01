(setq-default indent-tabs-mode t)
(setq tab-width 4) ; or any other preferred value
(defvaralias 'c-basic-offset 'tab-width)

(defvar my-shell "/usr/bin/rshell")
(defadvice ansi-term (before force-bash)
  (interactive (list my-shell)))
(ad-activate 'ansi-term)

(global-set-key (kbd "<s-return>") 'ansi-term)

(defvaralias 'c-basic-offset 'tab-width)
(setq-default indent-tabs-mode t)
(setq tab-width 4) ; or any other preferred value

;; Bakcup
(setq backup-directory-alist `(("." . "~/.emacs.d/backup/")))
(setq backup-by-copying t)
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)

;; Local LISP
(add-to-list 'load-path "~/.emacs.d/lisp/")

;; Ask
(defalias 'yes-or-no-p 'y-or-n-p)

;; Ring
(setq ring-bell-function 'ignore)

;; UTF-8
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(setq org-ellipsis " ")
(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)
(setq org-confirm-babel-evaluate nil)
(setq org-export-with-smart-quotes t)
(setq org-src-window-setup 'current-window)
(setq org-agenda-files (quote ("~/Agenda/Index.org")))
(add-hook 'org-mode-hook 'org-indent-mode)

(add-to-list 'org-structure-template-alist
	     '("el" "#+BEGIN_SRC emacs-lisp\n?\n#+END_SRC"))

(setq org-todo-keywords
      '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook(lambda () (org-bullets-mode))))

;; Org export
(use-package ox-twbs
  :ensure t)

(use-package ox-reveal
  :ensure t
  :config
  (setq org-reveal-root "http://cdn.jsdelivr.net/reveal.js/3.0.0/")
  (setq org-reveal-mathjax t))

(setq org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
	"pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
	"pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))


(setq org-src-fontify-natively t)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)
   (latex . t)
   (C . t)
   (ditaa . t)
   (shell . t)))

(setq org-ditaa-jar-path "/usr/share/java/ditaa/ditaa-0.11.jar")
(setq view-diary-entries-initially t
      mark-diary-entries-in-calendar t
      number-of-diary-entries 7)
(add-hook 'diary-display-hook 'fancy-diary-display)
(add-hook 'today-visible-calendar-hook 'calendar-mark-today)

(add-hook 'fancy-diary-display-mode-hook
	  '(lambda ()
	     (alt-clean-equal-signs)))

(defun alt-clean-equal-signs ()
  "This function makes lines of = signs invisible."
  (goto-char (point-min))
  (let ((state buffer-read-only))
    (when state (setq buffer-read-only nil))
    (while (not (eobp))
      (search-forward-regexp "^=+$" nil 'move)
      (add-text-properties (match-beginning 0)
			   (match-end 0)
			   '(invisible t)))
    (when state (setq buffer-read-only t))))

(org-babel-do-load-languages 'org-babel-load-languages
			     '(
			       (ditaa . t)
			       (shell . t)
			       (C . t)
			       )
			     )
(use-package org
  :config
  (progn
    (defun imalison:org-inline-css-hook (exporter)
      "Insert custom inline css to automatically set the
  background of code to whatever theme I'm using's background"
      (when (eq exporter 'html)
	(let* ((my-pre-bg (face-background 'default))
	       (my-pre-fg (face-foreground 'default)))
	  (setq
	   org-html-head-extra
	   (concat
	    org-html-head-extra
	    (format "<style type=\"text/css\">\n pre.src {background-color: %s; color: %s;}</style>\n"
		    my-pre-bg my-pre-fg))))))

    (add-hook 'org-export-before-processing-hook 'imalison:org-inline-css-hook)))

(defvaralias 'c-basic-offset 'tab-width)
(defvaralias 'cperl-indent-level 'tab-width)
(setq c-default-style "linux")
(setq-default tab-always-indent t)
(setq-default indent-tabs-mode t)
(setq-default c-basic-offset 8)
(setq-default tab-width 8)

;; Only show compiler buffer when we got a error
(defun brian-compile-finish (buffer outstr)
  (unless (string-match "finished" outstr)
    (switch-to-buffer-other-window buffer))
  t)

(setq compilation-finish-functions 'brian-compile-finish)

(require 'cl)

(defadvice compilation-start
    (around inhibit-display
	    (command &optional mode name-function highlight-regexp))
  (if (not (string-match "^\\(find\\|grep\\)" command))
      (cl-flet ((display-buffer)
		(set-window-point)
		(goto-char))
	(fset 'display-buffer 'ignore)
	(fset 'goto-char 'ignore)
	(fset 'set-window-point 'ignore)
	(save-window-excursion
	  ad-do-it))
    ad-do-it))

(ad-activate 'compilation-start)

(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one t)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (doom-themes-org-config))

(defun set-light-theme ()
  "Set the light theme with some customization if needed."
  (interactive)
  (disable-theme 'doom-one)
  (load-theme 'doom-nord-light t))

(defun set-dark-theme ()
  "Set the dark theme with some customization if needed."
  (interactive)
  (disable-theme 'doom-node-light)
  (load-theme 'doom-one t))

(defvar last-theme)
(setq last-theme 0)

(defun rcs/toggle-theme ()
  "Toggle between dark and white themes"
  (interactive)
  (if (= last-theme 0)
      (progn (set-light-theme) (setq last-theme 1))
      (progn (set-dark-theme) (setq last-theme 0))
      )
  )

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Scroll before cursor hits the end
(setq scroll-margin 3
      scroll-conservatively 9999
      scroll-step 1)

;; Show line numbers
(defun rcs/line-numbers ()
  "Enable and define config for line numbers."
  (interactive)
  (progn
    (require 'display-line-numbers)
    (global-display-line-numbers-mode 1)
    (display-line-numbers-update-width)
    (setq display-line-numbers-type 'relative))
  )

(add-hook 'emacs-startup-hook 'rcs/line-numbers)
;; Highlight cursor
(global-hl-line-mode 1)

;; Set font
(add-to-list 'default-frame-alist '(font . "Hack-10" ))
;; Maximized window
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(use-package projectile
  :ensure t
  :config
  (projectile-mode +1)
  (setq projectile-project-search-path '("~/Dev/Software"))
  (setq projectile-enable-caching t)
  )

(use-package page-break-lines
  :ensure t)

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner "~/.emacs.d/img/dashLogo.png")
  (setq dashboard-banner-logo-title "Welcome to the dark side")
  (setq dashboard-center-content t)
  (setq dashboard-show-shortcuts nil)
  (setq dashboard-items '((agenda . 5)
			  (recents  . 5)
			  (projects . 15))))

(use-package doom-modeline
  :ensure t
  :init
  :hook (after-init . doom-modeline-mode))

					;(use-package spaceline
					;:ensure t
					;:config
					;(require 'spaceline-config)
					;(setq spaceline-buffer-encoding-abbrev-p nil)
					;(setq spaceline-line-column-p nil)
					;(setq spaceline-line-p nil)
					;(setq powerline-default-separator (quote arrow))
					;(spaceline-spacemacs-theme))

(use-package diminish
  :ensure t
  :init
  (diminish 'hungry-delete-mode)
  (diminish 'workgroups-mode)
  (diminish 'which-key-mode)
  (diminish 'undo-tree-mode)
  (diminish 'which-key-mode)
  (diminish 'yas-minor-mode)
  (diminish 'undo-tree-mode)
  (diminish 'subword-mode)
  (diminish 'company-mode)
  (diminish 'org-indent-mode)
  (diminish 'rainbow-mode))

(use-package whitespace
  :ensure t
  :config
  (setq whitespace-line-column 80) ;; limit line length
  (setq whitespace-style '(face lines-tail))

  (add-hook 'prog-mode-hook 'whitespace-mode)
  (whitespace-mode 1))

(setq ido-enable-flex-matching nil)
(setq ido-create-new-buffer 'always)
(setq ido-everywhere t)
(ido-mode 1)

(use-package ido-vertical-mode
  :ensure t
  :init
  (ido-vertical-mode 1))

(setq ido-vertical-define-keys 'C-n-and-C-p-only)

(setq ibuffer-saved-filter-groups
      (quote (("default"
	       ("dired" (mode . dired-mode))
	       ("programming" (or
			       (mode . css-mode)
			       (mode . html-mode)
			       (mode . markdown-mode)
			       (mode . org-mode)
			       (mode . asm-mode)
			       (mode . c-mode)
			       (mode . prog-mode)))
	       ("planner" (or
			   (name . "^\\**Calendar\\**$")
			   (name . "^diary$")
			   (mode . muse-mode)))
	       ("emacs" (or
			 (name . "^\\**dashboard\\**$")
			 (name . "^\\**scratch\\**$")
			 (name . "^\\**Messages\\**$")
			 (name . "^\\**elfeed-log\\**$")))
	       ("feeds" (or
			 (mode . message-mode)
			 (mode . bbdb-mode)
			 (mode . mail-mode)
			 (mode . gnus-group-mode)
			 (mode . gnus-summary-mode)
			 (mode . gnus-article-mode)
			 (name . "^\\.bbdb$")
			 (name . "^\\.newsrc-dribble")))))))

(add-hook 'ibuffer-mode-hook
	  (lambda ()
	    (ibuffer-auto-mode 1)
	    (ibuffer-switch-to-saved-filter-groups "default")))

(setq ibuffer-expert t)
(setq ibuffer-show-empty-filter-groups nil)

(use-package switch-window
  :ensure t
  :config
  (setq switch-window-input-style 'minibuffer)
  (setq switch-window-increase 4)
  (setq switch-window-threshold 2)
  :bind
  ([remap other-window] . switch-window))

(global-subword-mode 1)

(use-package magit
  :ensure t)

(use-package evil-magit
  :ensure t)

(use-package git-gutter+
  :ensure t
  :init (global-git-gutter+-mode +1))



(use-package git-gutter-fringe+
  :ensure t
  :config

  ;; Please adjust fringe width if your own sign is too big.

  (setq-default fringes-outside-margins t)
  (setq-default left-fringe-width  3)
  (setq-default right-fringe-width 0)

  (fringe-helper-define 'git-gutter-fr+-added nil
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX")

  (fringe-helper-define 'git-gutter-fr+-deleted nil
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX")

  (fringe-helper-define 'git-gutter-fr+-modified nil
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"
    "XXXXXXXX"))

(use-package php-mode
  :ensure t)

(use-package hide-mode-line
  :ensure t
  :hook (hide-modeline-mode . emacs-startup-hook))

(use-package x86-lookup
  :ensure t
  :config
  (setq x86-lookup-pdf "~/Documents/Programming/C/Reference/Intel_x86_64_Manual.pdf"))

(use-package hungry-delete
  :ensure t
  :config
  (global-hungry-delete-mode))

(use-package sudo-edit
  :ensure t)

(use-package hl-todo
  :ensure t
  :config
  (global-hl-todo-mode t))

(use-package helpful
  :ensure t)

;; Instead of normal M-x
(use-package smex
  :ensure t
  :init (smex-initialize)
  :bind ("M-x" . smex))

(defun c/lisp-pair-mode ()
  (if (derived-mode-p 'c-mode)
      (setq electric-pair-pairs '(
				  (?\( . ?\))
				  (?\[ . ?\])
				  (?\{ . ?\})
				  (?\" . ?\")
				  (?\' . ?\')
				  ))
    (setq electric-pair-pairs '((?\( . ?\))))))

(add-hook 'c-mode #'c/lisp-pair-mode)
(electric-pair-mode t)

(use-package popup-kill-ring
  :ensure t
  :bind ("M-p" . popup-kill-ring))

(use-package which-key
  :ensure t
  :init
  (which-key-mode))

;; Autocompletion frontend
(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode)
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-lenght 3)
  :preface
  ;; enable yasnippet everywhere
  (defvar company-mode/enable-yas t
    "Enable yasnippet for all backends.")
  (defun company-mode/backend-with-yas (backend)
    (if (or
	 (not company-mode/enable-yas)
	 (and (listp backend) (member 'company-yasnippet backend)))
	backend
      (append (if (consp backend) backend (list backend))
	      '(:with company-yasnippet)))))

(with-eval-after-load 'company
  (define-key company-active-map (kbd "M-n") 'nil)
  (define-key company-active-map (kbd "M-p") 'nil)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (add-hook 'c++-mode-hook 'company-mode)
  (add-hook 'c-mode-hook 'company-mode))

;; Backend for C/C++ autocompletion
;;(use-package irony
;;:ensure t
;;:config
;;(add-hook 'c++-mode-hook 'irony-mode)
;;(add-hook 'c-mode-hook 'irony-mode)
;;(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))

;; Integration for company and irony
;;(use-package company-irony
;;:ensure t
;;:config
;;(require 'company)
;;(add-to-list 'company-backends 'company-irony)
;;(add-to-list 'company-backends 'company-c-headers))

;; Backend for C/C++ autocompletion
(use-package lsp-mode
  :commands lsp
  :ensure t
  :hook (prog-mode . lsp)
  :config
  (setq lsp-auto-guess-root t))

(use-package company-lsp
  :ensure t
  :commands company-lsp
  :config
  (push 'company-lsp company-backends)
  (setq company-lsp-cache-candidates 'auto)
  (setq company-lsp-async t)
  (setq company-lsp-enable-snippet t)
  (push 'company-lsp company-backends)) ;; add company-lsp as a backend

(use-package lsp-ui :commands lsp-ui-mode :ensure t)

(use-package treemacs
  :ensure t)

(use-package lsp-treemacs
  :ensure t
  :hook (treemacs-mode . treemacs-lsp-mode)
  :config
  (lsp-treemacs-sync-mode 1))

(use-package yasnippet
  :ensure t
  :init (yas-global-mode t)
  :config
  (use-package yasnippet-snippets
    :ensure t)
  (yas-reload-all))

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode t)
  :config
  (setq flycheck-clang-language-standard "gnu99"))

(use-package eldoc
  :ensure t
  :diminish eldoc-mode
  :init (add-hook 'company-mode-hook 'eldoc-mode))

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

(use-package evil
  :ensure t
  :init (evil-mode 1))

(setq evil-emacs-state-modes nil)
(setq evil-insert-state-modes nil)
(setq evil-motion-state-modes nil)
(setq evil-move-cursor-back nil)

(eval-after-load 'evil
  '(progn
     (evil-make-overriding-map helpful-mode-map 'normal)
     (evil-make-overriding-map help-mode-map 'normal)
     (evil-make-overriding-map calendar-mode-map 'normal)

     (add-hook 'calendar-mode-hook 'evil-normalize-keymaps)
     (add-hook 'help-mode-hook 'evil-normalize-keymaps)
     (add-hook 'helpful-mode-hook 'evil-normalize-keymaps)))

(eval-after-load 'magit
  '(evil-set-initial-state 'magit-popup-mode 'emacs))

(require 'custom-binds)
(require 'general)

(defconst rcs/key-leader "SPC")

;; Unbind Everything
(dolist (key '("\C-a" "\C-b" "\C-c" "\C-d" "\C-e" "\C-f" "\C-g"
	       "\C-h" "\C-k" "\C-l" "\C-n" "\C-o" "\C-p" "\C-q"
	       "\C-t" "\C-u" "\C-v" "\C-x" "\C-z" "\e"))
  (global-unset-key key))

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-=") 'text-scale-increase)
(global-set-key (kbd "M--") 'text-scale-decrease)

(general-define-key
 :states '(normal emacs)
 :keymaps 'dashboard-mode-map
 :prefix rcs/key-leader
 :non-normal-prefix "C-SPC"

 ;; Agenda
 "aa" 'org-agenda
 "am" 'calendar
 "ad" 'diary
 )

(general-define-key
 :states '(normal)
 :keymaps 'org-mode-map
 :prefix rcs/key-leader
 :non-normal-prefix "C-SPC"
 "e"	'eval-last-sexp

 "E" 'org-babel-execute-src-block
 "oa" 'org-agenda
 "oe" 'org-export-dispatch
 "op" 'org-latex-export-to-pdf
 "o[" 'org-agenda-file-to-front
 "o]" 'org-remove-file
 "o." 'org-agenda-time-stamp
 "oc."'org-time-stamp
 "od" 'org-deadline
 "os" 'org-schedule
 "'" 'org-edit-special
 )

(general-define-key
 :states '(normal)
 :keymaps 'emacs-lisp-mode-map
 :prefix rcs/key-leader
 :non-normal-prefix "C-SPC"

 "e"	'eval-last-sexp
 "'" 'org-edit-src-exit
 )

(general-define-key
 :states '(normal emacs)
 :prefix rcs/key-leader
 :non-normal-prefix "C-SPC"

 ;; Config
 "cr" '(lambda () (interactive) (org-babel-load-file (expand-file-name "~/.emacs.d/config.org")))
 "ce" '(lambda () (interactive) (find-file "~/.emacs.d/config.org"))
 "cf" 'indent-buffer

 ;; Files
 "su" 'sudo-edit
 "f"	'ido-find-file
 "F"	'dired

 ;; Buffers
 "k"	'kill-current-buffer
 "b"	'ido-switch-buffer
 "xk" 'kill-all-buffers
 "xb" 'ibuffer

 ;; UI
 "um" 'hide-mode-line-mode
 "ut" 'rcs/toggle-theme

 ;; Windows
 "wo" 'switch-window

 "wv" 'split-and-fallow-v
 "wh" 'split-and-fallow-h

 "wk" 'delete-window
 "wd" 'delete-other-windows

 ;; Help
 "hk" 'helpful-key
 "hf" 'helpful-function
 "hx" 'describe-mode
 "ht" 'help-with-tutorial
 "hi" 'info
 "hy" 'yas-describe-tables
 "hm" 'x86-lookup

 ;; Magit
 "gg" 'magit

 ;; Treemacs
 "t" 'treemacs
 )

(general-def
  :states '(normal)
  :keymaps 'c-mode-map
  :prefix rcs/key-leader
  :non-normal-prefix "C-SPC"
  "cc" 'projectile-compile-project
  "ct" 'create-tags
  )

(general-def
  :states '(normal)
  :keymaps 'c-mode-map
  "<f12>" 'recompile
  )

(progn
  (require 'dired)
  (general-def dired-mode-map "C-f e"))
