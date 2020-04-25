;;; pop-man.el --- Popup manual pages  -*- lexical-binding: t -*-

;; License: GPLv2

;; Author: Reberti Carvalho Soares <6reberti6@gmail.com>
;; Created: 24 Apr 2020
;; Version: 0.1
;; Package-Requires: ((posframe))
;; Keywords: convenience popup documentation man
;; URL: www.github.com/KisuYami/KisuEmacs/lisp/pop-man/pop-man.el

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.	If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; This package provides an easy way to display man pages as an popup frame.

;;; Code:
(require 'posframe)

(define-minor-mode pop-man
  "Display the man page for the function at point.")

(defvar pop-man-buffer " *pop-man*")
(defvar pop-man-buffer-height 15)
(defvar pop-man-buffer-width 81)

(defun pop-man-show-man (name)
  "Create an popup man page."
  (interactive "sMan Page Name: ")

  ;; Aways delete older posframe
  (posframe-delete pop-man-buffer)
  (setq page (shell-command-to-string (format "man 3 %S" name)))

  ;; Only diplay popup if the manual existis
  (unless (equal (substring page 0 9) "No manual")
	(with-current-buffer (get-buffer-create pop-man-buffer)
	  (erase-buffer)
	  (insert page))

	(when (posframe-workable-p)
	  (posframe-show pop-man-buffer
			 :position 1
			 :x-pixel-offset 780 ;; TODO: change it to window-something
			 :width pop-man-buffer-width
			 :height pop-man-buffer-height
			 ;;:timeout 1
			 :internal-border-color "blue"
			 :internal-border-width 1))))

(defun pop-man-show-at-point ()
  "Show man page for function at point."
  (interactive)
  (setq function-name (thing-at-point 'filename 'no-properties))
  (pop-man-show-man function-name))

(provide 'pop-man)
