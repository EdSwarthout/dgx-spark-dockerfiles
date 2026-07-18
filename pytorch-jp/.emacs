;;; -*- lexical-binding: t -*-

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(dired-dwim-target t)
 '(dired-listing-switches "-alt")
 '(ring-bell-function 'ignore)
 '(server-kill-new-buffers nil)
 '(size-indication-mode t))

(define-key global-map "\C-x\C-b" 'buffer-menu)
(define-key global-map "\C-ct" 'toggle-truncate-lines)
