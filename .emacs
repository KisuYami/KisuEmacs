(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(org-babel-load-file (expand-file-name "~/.emacs.d/config/general.org"))
(org-babel-load-file (expand-file-name "~/.emacs.d/config/packages.org"))
(org-babel-load-file (expand-file-name "~/.emacs.d/config/visual.org"))
(org-babel-load-file (expand-file-name "~/.emacs.d/config/keybinds.org"))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#1B2229" "#ff6c6b" "#98be65" "#ECBE7B" "#51afef" "#c678dd" "#46D9FF" "#DFDFDF"])
 '(custom-safe-themes
   (quote
	("b46ee2c193e350d07529fcd50948ca54ad3b38446dcbd9b28d0378792db5c088" "84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "40da996f3246a3e99a2dff2c6b78e65307382f23db161b8316a5440b037eb72c" "a24c5b3c12d147da6cef80938dca1223b7c7f70f2f382b26308eba014dc4833a" default)))
 '(delete-selection-mode nil)
 '(fci-rule-color "#5B6268")
 '(jdee-db-active-breakpoint-face-colors (cons "#1B2229" "#51afef"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#1B2229" "#98be65"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#1B2229" "#3f444a"))
 '(package-selected-packages
   (quote
	(helpful impatient-mode org-reveal ox-reveal evil-magit company-irony company c-eldoc org-preview-html-mode emms weechat smart-mode-line-powerline-theme smart-mode-line immaterial-theme try exwm dashboard smex org-bullets material-theme spacemacs-theme which-key use-package)))
 '(vc-annotate-background "#282c34")
 '(vc-annotate-color-map
   (list
	(cons 20 "#98be65")
	(cons 40 "#b4be6c")
	(cons 60 "#d0be73")
	(cons 80 "#ECBE7B")
	(cons 100 "#e6ab6a")
	(cons 120 "#e09859")
	(cons 140 "#da8548")
	(cons 160 "#d38079")
	(cons 180 "#cc7cab")
	(cons 200 "#c678dd")
	(cons 220 "#d974b7")
	(cons 240 "#ec7091")
	(cons 260 "#ff6c6b")
	(cons 280 "#cf6162")
	(cons 300 "#9f585a")
	(cons 320 "#6f4e52")
	(cons 340 "#5B6268")
	(cons 360 "#5B6268")))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
