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
(defun config-visit ()
  "Open Config Files"
  (interactive)
  (find-file "~/.emacs.d/config.org"))

(defun config-reload ()
  "Reload Config Files"
  (interactive)
  (org-babel-load-file (expand-file-name "~/.emacs.d/config.org")))

;; Buffers
(defun kill-current-buffer ()
  (interactive)
  (kill-buffer (current-buffer)))

(defun kill-all-buffers ()
  (interactive)
  (mapc 'kill-buffer (buffer-list)))

(defun indent-buffer ()
  "Indent an entire buffer using the default intenting scheme."
  (interactive)
  (save-excursion
    (delete-trailing-whitespace)
    (indent-region (point-min) (point-max))
    (tabify (point-min) (point-max)))
    )

  (defun create-tags (dir-name)
    "Create tags file."
    (interactive "DDirectory: ")
    (eshell-command
     (format "find %s -type f -name \"*.[ch]\" | etags -" dir-name)))
