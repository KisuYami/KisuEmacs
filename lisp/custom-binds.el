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
(defun config-visit()
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

;; Email
;"rm $(notmuch search --output=files --exclude=false tag:deleted)"
(defun notmuch-delete-tagged ()
  "Delete emails tagged with deleted"
  (interactive)
  (shell-command "notmuch search --output=files --exclude=false tag:deleted > email_list")
  (shell-command "xargs rm < email_list")
  (message "%s Emails removed" (shell-command "wc ./email_list -l"))
  (shell-command "rm email_list")
  (shell-command "notmuch new"))