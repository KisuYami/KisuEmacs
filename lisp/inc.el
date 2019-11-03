(defgroup in nil
  "Increment/Decrement number like in vim."
  :group 'convenience
  :prefix "custom-binds-")

(provide 'inc)

(defun rcs/find-number-at-line (line)
  "Move the cursor to the first number of a line"
  (beginning-of-buffer)
  (line-move-visual (1- line))

  (search-forward-regexp "[-+]?[0-9][-+]?")
  (deactivate-mark)

  (backward-char)
  (string-to-number (current-word t t)))

(defun rcs/change-number (op)
  "Inc/Dec number by <op>"
  (interactive "nValue: ")
  (setq line (count-lines 1 (point)))
  (setq number (rcs/find-number-at-line line))

  (if (= op 1)
      (replace-match (number-to-string(1+ number)))
      (replace-match (number-to-string(1+ number))))

  (backward-char))

(defun rcs/inc-number-at-line (line)
  "Increment number at line"
  (interactive "nLine: ")
  (beginning-of-buffer)
  (line-move-visual (1- line))
  (rcs/change-number 1))

(defun rcs/dec-number-at-line (line)
  "Decrement number at line"
  (interactive "nLine: ")
  (beginning-of-buffer)
  (line-move-visual (1- line))
  (rcs/change-number -1))
