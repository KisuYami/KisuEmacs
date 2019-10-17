(defgroup custom-binds nil
  "Gives convenient wrappers for key definitions."
  :group 'convenience
  :prefix "custom-binds-")

 (provide 'custom-binds)

;; Window Bindings
(defun split-and-fallow-h ()
	(interactive)
	(split-window-below)
	(balance-windows)
	(other-window 1))

(defun split-and-fallow-v ()
	(interactive)
	(split-window-right)
	(balance-windows)
	(other-window 1))

;; Config
(defun config-visit(file)
	"Open Config Files"
	(interactive "sWhich File? ")
	(if (= (length file) 0)
		(find-file "~/.emacs.d/config/general.org")
		(find-file (concat "~/.emacs.d/config/" file ".org"))))

(defun config-reload ()
	"Reload Config Files"
	(interactive)
	(org-babel-load-file (expand-file-name "~/.emacs.d/config/general.org"))
	(org-babel-load-file (expand-file-name "~/.emacs.d/config/visual.org"))
	(org-babel-load-file (expand-file-name "~/.emacs.d/config/keybindings.org"))
	(org-babel-load-file (expand-file-name "~/.emacs.d/config/packages.org")))

;; Buffers
(defun kill-current-buffer ()
  (interactive)
  (kill-buffer (current-buffer)))

(defun kill-all-buffers ()
   (interactive)
   (mapc 'kill-buffer (buffer-list)))
