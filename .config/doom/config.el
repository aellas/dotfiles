;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Font settings
(setq doom-font (font-spec :family "Iosevka Nerd Font" :size 16))

(setq doom-theme 'doom-tokyo-night)

;; Line numbers
(setq display-line-numbers-type t)

;; Org directory
(setq org-directory "~/org/")

;; Mouse support in terminal
(xterm-mouse-mode 1)

;; Dired settings
(setq dired-listing-switches "-alh --group-directories-first")

;; Treemacs
(setq treemacs-show-hidden-files nil)

;; Image file handling
(add-to-list 'auto-mode-alist '("\\.png\\'"  . image-mode))
(add-to-list 'auto-mode-alist '("\\.jpe?g\\'" . image-mode))
(add-to-list 'auto-mode-alist '("\\.gif\\'"  . image-mode))

;; Use multi-vterm after vterm is loaded
(use-package! multi-vterm
  :after vterm)

;; Force vterm to use Doom font
(add-hook 'vterm-mode-hook
          (lambda ()
            (setq buffer-face-mode-face doom-font)
            (buffer-face-mode t)))

;; --- Custom Dashboard Banner ---
(defun my-weebery-is-always-greater ()
  (let* ((banner '(
                   "        ⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⣠⣶⠚⠛⠿⠷⠶⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀     "
                   "        ⠀⠀⠀⠀⠀⢀⣴⠟⠉⠀⠀⢠⡄⠀⠀⠀⠀⠀⠉⠙⠳⣄⠀⠀⠀⠀⠀⠀⠀⠀     "
                   "        ⠀⠀⠀⢀⡴⠛⠁⠀⠀⠀⠀⠘⣷⣴⠏⠀⠀⣠⡄⠀⠀⢨⡇⠀⠀⠀⠀⠀⠀⠀     "
                   "        ⠀⠀⠀⠺⣇⠀⠀⠀⠀⠀⠀⠀⠘⣿⠀⠀⠘⣻⣻⡆⠀⠀⠙⠦⣄⣀⠀⠀⠀      "
                   "        ⠀⠀⠀⢰⡟⢷⡄⠀⠀⠀⠀⠀⠀⢸⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⢻⠶⢤⡀     "
                   "        ⠀⠀⠀⣾⣇⠀⠻⣄⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣀⣴⣿     "
                   "        ⠀⠀⢸⡟⠻⣆⠀⠈⠳⢄⡀⠀⠀⡼⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠶⠶⢤⣬⡿⠁     "
                   "        ⠀⢀⣿⠃⠀⠹⣆⠀⠀⠀⠙⠓⠿⢧⡀⠀⢠⡴⣶⣶⣒⣋⣀⣀⣤⣶⣶⠟⠁⠀     "
                   "        ⠀⣼⡏⠀⠀⠀⠙⠀⠀⠀⠀⠀⠀⠀⠙⠳⠶⠤⠵⣶⠒⠚⠻⠿⠋⠁⠀⠀⠀⠀     "
                   "        ⢰⣿⡇⠀⠀⠀⠀⠀⠀⠀⣆⠀⠀⠀⠀⠀⠀⠀⢠⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀     "
                   "        ⢿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠘⣦⡀⠀⠀⠀⠀⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀     ⠀"
                   "        ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣷⡄⠀⠀⠀⠀⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀     ⠀"
                   "        ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢷⡀⠀⠀⠀⢸⣿⡄⠀⠀⠀⠀⠀⠀⠀     ⠀"
                   "          ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀     "
                   "                                           "
                   ))
         (longest-line (apply #'max (mapcar #'length banner)))
         (start (point)))
    (dolist (line banner)
      (insert (+doom-dashboard--center
               +doom-dashboard--width
               (concat line (make-string (max 0 (- longest-line (length line))) 32)))
              "\n"))
    (put-text-property start (point) 'face 'doom-dashboard-banner)))

(setq +doom-dashboard-ascii-banner-fn #'my-weebery-is-always-greater)
;; --- Custom Dashboard Banner ---
;;
(add-hook! '+doom-dashboard-functions :append
  (insert "\n" (+doom-dashboard--center +doom-dashboard--width "The Sky, The Earth & All Between")))
(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-footer)

;; --- Treemacs ---
(setq treemacs-show-hidden-files t)
(setq confirm-kill-emacs nil)

;; OPTIONAL
;; Integrate to `magit-tag'
(with-eval-after-load 'magit-tag
  (transient-append-suffix 'magit-tag
    '(1 0 -1)
    '("c" "changelog" git-cliff-menu)))

