;;;;;;;;;;;;;required for consult;;;;;;;;;;;;;;;;;
;;; -*- lexical-binding: t; -*- 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; Set load-path here.
(let ((default-directory "/home/david/.emacs.d/packages"))
  (normal-top-level-add-to-load-path '("."))
  (normal-top-level-add-subdirs-to-load-path))

;;Emacs basic setup:
(global-visual-line-mode t) ;; word wrap
(delete-selection-mode t) ;; delete selected when typing
(tool-bar-mode 0) ;; disable tool bar
(menu-bar-mode 0) ;; disable menu bar
(blink-cursor-mode 0) ;; turn of cursor blinki
(set-scroll-bar-mode nil) ;; disable scroll bar
(visual-line-mode 1) ;; wrap long lines as a single line number
(tab-bar-mode) ;; turn on tabs for each buffer
(add-hook 'prog-mode-hook 'display-line-numbers-mode) ;; line numbers in programming modes
(put 'dired-find-alternate-file 'disabled nil) ;; use a to select files/folders in dired
(global-auto-revert-mode 1) ;; always refresh files when they've changed on disk. Don't ask.
(global-hl-line-mode 1) ;; always highlight the line containing point.

(setq backup-directory-alist '((".*" . "~/.local/share/Trash/files")) ;; ~ files go to trash
      inhibit-startup-message t ;; disable splash screen
      scroll-conservatively 101 ;; remove half page jump scrolling
      mouse-wheel-scroll-amount '(3 ((shift) . 3)) ;; adjust scroll amount for mouse wheel
      mouse-wheel-progressive-speed t ;; mouse wheel gets faster the more you do it
      mouse-autoselect-window t ;; window focus on mouse hover.
      echo-keystrokes 0.1 ;;decrease time for key-binding display in mini buffer
      bookmark-save-flag 1 ;; save bookmarks when new bookmark is created
      bookmark-use-annotations t ;; if bookmark annotations are available open bookmark in new buffer
      isearch-lazy-count t  ;; show current number of matches in isearch
      isearch-hide-immediately nil ;; text where matches were found stays on display until search/replace command exits.
      search-nonincremental-instead nil  ;; instead of using nonincremental search when no matches are found exit
	  fill-column 80) ;; Set at 80 chars for Python pep 8.
	  
(add-to-list 'Info-directory-list "/home/david/.emacs.d/py-info")
;;Add Melpa and GNU repositories:
(require 'package)
(require 'queue)
(require 'info+)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("e410458d3e769c33e0865971deb6e8422457fad02bf51f7862fa180ccc42c032"
	 default))
 '(package-selected-packages
   '(clang-format combobulate consult consult-company dap-mode
				  dap-variables ef-themes embark embark-consult
				  exec-path-from-shell flycheck-clang-tidy
				  flycheck-rust general go-mode lsp-pyright lsp-ui
				  markdown-preview-mode modus-themes nerd-icons
				  org-roam pdf-tools pet pkg-info quelpa
				  quelpa-use-package rust-mode tsc wgrep zig-mode))
 '(safe-local-variable-values
   '((devdocs-current-docs "cpp") (devdocs-current-docs "python~3.12")
	 (devdocs-current-docs "go") (devdocs-current-docs "rust")
	 (projectile-enable-cmake-presets . t))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("gnu"   . "https://elpa.gnu.org/packages/")
			 ("org"   . "https://orgmode.org/elpa/")))
(package-initialize)

;;Theme Settings:
(require 'modus-themes)

(setq modus-themes-bold-constructs t
	  modus-themes-to-toggle '(modus-vivendi modus-operandi-deuteranopia)
	  modus-operandi-deuteranopia-palette-overrides '((modus-themes-preset-overrides-cooler)
													  (bg-main "#fbf7f0")
													  (cursor "#000000")
													  (comment bg-term-green)
													  (bg-paren-match "#ffaa00")
													  (fringe "#d5d7ff")
													  (bg-tab-bar "#d5d7ff")
													  (bg-tab-current bg-main)
													  (bg-line-number-inactive "#ffffff")
													  (bg-line-number-active "#d5d7ff")
													  (fg-line-number-active "#000000")))

(load-theme 'modus-operandi-deuteranopia t)

;;Setup use-package:
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-and-compile
  (setq use-package-always-ensure t
		use-package-expand-minimally t))

;;Exec Package Settings:
(use-package exec-path-from-shell
  :if (memq (window-system) '(mac ns x))
  :config
  (exec-path-from-shell-initialize))

;;Recentf Settings:
 (setq recentf-max-menu-items 30
	  recentf-max-saved-items 20
	  recentf-auto-cleanup 'never)
(recentf-mode 1)
(add-hook 'kill-emacs-hook (lambda() (recentf-cleanup)))

;;Dired Settings:
(setq dired-dwim-target t
	  dired-recursive-copies 'top
	  dired-recursive-deletes 'top
	  dired-kill-when-opening-new-dired-buffer t)

;;Save-hist Settings:
(savehist-mode 1)

;;Garbage collection:
(setq gc-cons-threshold (* 2 1000 1000)
      gc-cons-percentage 0.6
      read-process-output-max (* 1024 1024))

(require 'gcmh)
(gcmh-mode 1)

;;Helpful Settings
(require 'elisp-refs) ;; required for helpful
(require 'helpful)

;;Sudo edit Settings:
(require 'sudo-edit)

;;(require 'smartparens-config)
;;(smartparens-global-mode)

;;General Key-binding Settings:
(require 'general)

(general-unbind
  :keymaps 'global-map
  "C-z"
  "M-'"
  "M-z"
  "M-l")
 

(general-def
  :keymaps 'lsp-mode-map
  :prefix "M-l"
  "r" 'lsp-rename
  "s" 'lsp
  "f" 'lsp-format-buffer
  "d" 'lsp-find-definition
  "a" 'lsp-avy-lens)

(general-def
  :keymaps 'global-map
  "C-M-;" 'org-roam-node-insert
  "C-M-<tab>" 'other-window
  "C-\\" 'embark-act
  "C-|" 'embark-act-all
  "M-\\" 'embark-dwim
  "C-M-y" 'embark-kill-ring-remove
  "C-<return>" 'save-buffer
  "C-y" 'consult-yank-from-kill-ring
  "M-y" 'consult-yank-pop
  "C-;" 'consult-register-load
  "M-;" 'consult-register-store

  "M-z" 'zap-up-to-char
  "C-w" 'copy-region-or-lines
  "C-q" 'cut-region-or-lines
  "C-'" 'company-complete
  "M-`" 'kmacro-call-macro
  "M-p" 'forward-or-backward-sexp)

;;Modified Emacs Prefix Keybindings:
(general-def
  :keymaps 'help-map
  "B" 'embark-keybinding
  "f" #'helpful-callable
  "v" #'helpful-variable
  "k" #'helpful-key
  "x" #'helpful-command
  "F" #'helpful-function
  "D" #'devdocs-lookup)

(general-def
  :keymaps 'goto-map
  "s" 'avy-goto-symbol-1
  "p" 'avy-prev
  "n" 'avy-next
  "w" 'avy-goto-word-or-subword-1
  "c" 'avy-goto-char
  "C" 'avy-goto-char-2
  "g" 'avy-goto-line
  "m" 'avy-move-line
  "r" 'avy-move-region
  "k" 'avy-kill-region
  "i" 'consult-imenu)

(general-def
  :keymaps 'mode-specific-map
  "B" 'embark-become
  "C-f" 'sudo-edit
  "C-r" 'sudo-edit-find-file
  "F" 'dap-continue
  "dq" 'dap-disconnect
  "e" 'embark-export
  "i" 'consult-info
  "p" 'projectile-command-map)

(general-def
  :keymaps 'lsp-command-map
  "e" 'lsp-ui-flycheck-list
  "R" 'lsp-ui-peek-find-references
  "Gm" 'gdb-toggle-breakpoint)

(general-def
  :keymaps 'ctl-x-map
  "b" 'consult-buffer
  "B" 'consult-bookmark
  "C-b" 'ibuffer
  "m" 'consult-mark
  "M-:" 'consult-complex-command
  "tb" 'consult-buffer-other-tab
  "tf" 'consult-buffer-other-frame
  "tw" 'consult-buffer-other-window
  "tq" 'tab-close
  "tn" 'tab-new
  "Kh" 'helpful-kill-buffers
  "f" 'consult-recent-file
  "co" 'consult-outline
  "cr" 'consult-register)

;;Consult keymap integration:
(general-unbind
  :keymaps 'projectile-command-map
   "p"
   "b" 
   "5b"
   "4b"
   "e" 
   "d" 
   "f" 
   "5f"
   "4f"
   "D")

(general-def
  :keymaps 'projectile-command-map
  "p" 'consult-projectile-switch-project
  "b" 'consult-projectile-switch-to-buffer
  "5b" 'consult-projectile-switch-to-buffer-other-frame
  "4b" 'consult-projectile-switch-to-buffer-other-window
  "e" 'consult-projectile-recentf
  "d" 'consult-projectile-find-dir
  "f" 'consult-projectile-find-file
  "5f" 'consult-projectile-find-file-other-frame
  "4f" ''consult-projectile-find-file-other-window
  "D" 'projectile-remove-known-project)

(general-def 
  :keymaps 'search-map
  "l" 'consult-line
  "L" 'consult-multi-line
  "r" 'consult-ripgrep
  "k" 'consult-keep-lines
  "f" 'consult-focus-lines
  "d" 'consult-fd)

(general-def
  :keymaps 'minibuffer-local-map
  "M-s" 'consult-history)


(general-def
  :keymaps 'isearch-mode-map
  "M-e" 'consult-isearch-history
  "M-s" 'consult-line)

(general-def
  :keymaps 'embark-region-map
  "C-n" 'lsp-rust-analyzer-move-item-down
  "C-p" 'lsp-rust-analyzer-move-item-up)

(general-def
  :keymaps 'embark-expression-map
  "1" 'python-shell-send-buffer
  "2" 'python-shell-send-region
  "3" 'python-shell-send-string
  "f" 'clang-format-buffer
  "I" 'embark-insert)

(general-def
  :keymaps 'embark-defun-map
  "N" 'narrow-to-defun
  "W" 'widen
  "0" 'eval-buffer
  "9" 'eval-region)

(general-def
  :keymaps 'embark-identifier-map
  "b" 'dap-breakpoint-toggle
  "i" 'lsp-pyright-organize-imports
  "r" 'lsp-rename
  "R" 'lsp-find-references
  "d" 'sphinx-doc
  "p" 'python-pytest
  "l" 'pylint
  "n" 'dap-step-in
  "d" 'dap-debug
  "D" 'eldoc-print-current-symbol-info
  "W" 'wgrep-change-to-wgrep-mode)

(general-def
  :keymaps 'rust-ts-mode-map
  "C-c C-k" 'rust-check
  "C-c L" 'rust-format-buffer)


;;Wgrep Settings:
(require 'wgrep)

;;Consult Settings:
(setq xref-show-xrefs-function #'consult-xref
      xref-show-definitions-function #'consult-xref
      consult-narrow-key "<"
      consult-line-start-from-top t
	  consult-projectile-use-projectile-switch-project t)
(require 'consult)

;;vertico Settings:
(setq vertico-cycle t
      vertico-count 15)
(require 'vertico)
(vertico-mode 1)

;;Orderless Settings:
(setq completion-styles '(orderless)
      orderless-matching-styles '(orderless-prefixes))
(require 'orderless)
(icomplete-mode 1)

(add-to-list 'orderless-affix-dispatch-alist '(35 . orderless-regexp))
(add-to-list 'orderless-affix-dispatch-alist '(64 . orderless-annotation))


;;Marginalia settings:
(setq marginalia-field-width 120
      marginalia-align 'right)
(require 'marginalia)
(marginalia-mode 1)

;;Embark Settings:
(setq prefix-help-command #'embark-prefix-help-command
	  embark-quit-after-action nil)
(require 'embark)
(require 'embark-consult)

(add-hook 'embark-collect-mode-hook #'consult-preview-at-point)

(add-to-list 'display-buffer-alist
 			 '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*" nil
 			   (window-parameters (mode-line-format . none))))
;;embark-verbose-indicator-display-action

;;consult project testing:
(require 'consult-project-extra)

;;Projectile Settings:
(setq projectile-completion-system 'auto
      projectile-indexing-method 'hybrid
      projectile-sort-order 'recently-active
      projectile-enable-caching t
      projectile-project-search-path '(("/home/david/Programming/py/")
				       ("/home/david/Programming/cpp_dev/"))
      projectile-project-root-files-top-down-recurring '(".git" "venv" ".projectile")
      projectile-switch-project-action #'projectile-find-file
      projectile-auto-discover nil)

;;(add-to-list 'projectile-globally-ignored-directories "^\\docs$")
;;(add-to-list 'projectile-globally-ignored-directories "^\\_static$")
;;(add-to-list 'projectile-globally-ignored-directories "^\\_templates$")
;;(add-to-list 'projectile-globally-ignored-directories "^\\dist$")
;;(add-to-list 'projectile-globally-ignored-directories "^\\build$")

(require 'projectile)
(require 'consult-projectile)
(projectile-mode +1)

;;Company Completion Settings:
	;;Consistant completion-ignore-case requires you to edit company-capf.elh
	;;Add the following line after (@109) (pcase command (some text)):
	;; ('ignore-case completion-ignore-case)
(setq company-minimum-prefix-length 1
      company-keywords-ignore-case t
      company-selection-wrap-around t
      company-idle-delay nil
      company-frontends '(company-preview-frontend company-echo-metadata-frontend))

(require 'company)
(require 'consult-company)

(advice-add 'company-capf :around #'company-completion-styles)
(add-hook 'after-init-hook 'global-company-mode)
(add-to-list 'company-backends 'company-capf)

(defun company-completion-styles (capf-fn &rest args)
  (let ((completion-styles '(orderless basic)))
    (apply capf-fn args)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;My-Functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my-cleanup-roam-buffers (&optional args)
  "Used to help auto clear org then don't need again.
   Use ARGS for optional arguments."
  (interactive)
  (mapc
   (lambda (buf)
     (when
         (and
          (buffer-live-p buf)
          (eq 'org-mode
              (with-current-buffer buf major-mode))
          (not (buffer-modified-p buf))
          (with-current-buffer buf
            (save-excursion
              (goto-char (point-min))
              (org-roam-node-at-point)))
          (not (get-buffer-window-list buf nil t)))
       (kill-buffer buf)))
   (buffer-list)))

(defun copy-region-or-lines (n &optional beg end)
  "Copy region or the next N lines into the kill ring.
  When called repeatedly, move to the next line and append it to
  the previous kill."
  (interactive "p")
  (let* ((repeatp (eq last-command 'copy-region-or-lines))
         (kill-command
          (if repeatp
              #'(lambda (b e) (kill-append (concat "\n" (buffer-substring b e)) nil))
            #'(lambda (b e) (kill-ring-save b e (use-region-p)))))
         beg
         end)
    (if repeatp
        (let ((goal-column (current-column)))
          (next-line)))
    (setq beg (or beg
                  (if (use-region-p)
                      (region-beginning)
                    (line-beginning-position))))
    (setq end (or end
                  (if (use-region-p)
                      (region-end)
                    (line-end-position n))))
    (funcall kill-command beg end)
    ;; (if repeatp (message "%s" (car kill-ring)))
    ))

(defun cut-region-or-lines (n &optional beg end)
  "Copy region or the next N lines into the kill ring.
  When called repeatedly, move to the next line and append it to
  the previous kill."
  (interactive "p")
  (let* ((repeatp (eq last-command 'copy-region-or-lines))
         (kill-command
          (if repeatp
              #'(lambda (b e) (kill-append (concat "\n" (buffer-substring b e)) nil)
				  (delete-region b e))
            #'(lambda (b e) (kill-ring-save b e (use-region-p))
				(delete-region b e))))
         beg
         end)
    (if repeatp
        (let ((goal-column (current-column)))
          (next-line)))
    (setq beg (or beg
                  (if (use-region-p)
                      (region-beginning)
                    (line-beginning-position))))
    (setq end (or end
                  (if (use-region-p)
                      (region-end)
                    (line-end-position n))))
    (funcall kill-command beg end)
    ))

(defun forward-or-backward-sexp (&optional arg)
  "Go to the matching parenthesis character if one is adjacent to point."
  (interactive "^p")
  (cond ((looking-at "\\s(") (forward-sexp arg))
        ((looking-back "\\s)" 1) (backward-sexp arg))
        ((looking-at "\\s)") (forward-char) (backward-sexp arg))
        ((looking-back "\\s(" 1) (backward-char) (forward-sexp arg))))

(defun lsp-if-supported (&optional args)
  "Exclude elisp-mode from all prog-mode Settings.
   Use ARGS for optional arguments."
  (unless (derived-mode-p 'emacs-lisp-mode)
	(lsp)))

(defun lsp-booster--advice-json-parse (old-fn &rest args)
  "Try to parse bytecode instead of json."
  (or
   (when (equal (following-char) ?#)
     (let ((bytecode (read (current-buffer))))
       (when (byte-code-function-p bytecode)
         (funcall bytecode))))
   (apply old-fn args)))

(defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
  "Prepend emacs-lsp-booster command to lsp CMD."
  (let ((orig-result (funcall old-fn cmd test?)))
    (if (and (not test?)                             ;; for check lsp-server-present?
             (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
             lsp-use-plists
             (not (functionp 'json-rpc-connection))  ;; native json-rpc
             (executable-find "emacs-lsp-booster"))
        (progn
          (message "Using emacs-lsp-booster for %s!" orig-result)
          (cons "emacs-lsp-booster" orig-result))
      orig-result)))

(defun exit-cmake-mode-and-venv ()
  "Exit major mode function to deactivate pyvenv"
  (interactive)
  (when (eq major-mode 'cmake-ts-mode)
    (pyvenv-deactivate)))
    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;IDE-Settings;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;x;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'python)
(require 'eldoc)
(global-eldoc-mode -1)
(require 'semgrep)

;;Guess-style Settings:
(require 'guess-style)
(autoload 'guess-style-set-variable "guess-style" nil t)
(autoload 'guess-style-guess-variable "guess-style")
(autoload 'guess-style-guess-all "guess-style" nil t)

;;Treesitter Settings:
(setq treesit-language-source-alist
	  '((cpp "https://github.com/tree-sitter/tree-sitter-cpp")
		(c "https://github.com/tree-sitter/tree-sitter-c")
		(python "https://github.com/tree-sitter/tree-sitter-python")
		(bash "https://github.com/tree-sitter/tree-sitter-bash")
		(elisp "https://github.com/Wilfred/tree-sitter-elisp")
		(json "https://github.com/tree-sitter/tree-sitter-json")
		(toml "https://github.com/ikatyang/tree-sitter-toml")
		(rust "https://github.com/tree-sitter/tree-sitter-rust.git")
		(go "https://github.com/tree-sitter/tree-sitter-go")
		(gomod "https://github.com/camdencheek/tree-sitter-go-mod.git")
		(cmake "https://github.com/uyha/tree-sitter-cmake")))

(dolist (mapping '(
;;				   (c++-mode . c++-ts-mode)
				   (c-mode . c-ts-mode)
				   (cmake-mode . cmake-ts-mode)
				   (python-mode . python-ts-mode)
				   (js-json-mode . json-ts-mode)
				   (conf-toml-mode . toml-ts-mode)
				   (rust-mode . rust-ts-mode)
				   (go-mode . go-ts-mode)
				   (sh-mode . bash-ts-mode)))
  (add-to-list 'major-mode-remap-alist mapping))

;; (setq python-ts-mode-hook python-base-mode-hook 
;;       c++-ts-mode-hook c++-mode-hook)

;; 	  sh-ts-mode-hook sh-mode-hook)
	  
(treesit-font-lock-rules
 :language 'python
 :override t
;; :language 'c++
;; :override t
 :language 'bash
 :override t
 :language 'elisp
 :override t
 :language 'json
 :override t
 :language 'toml
 :override t
 :language 'cmake
 :override t
 :language 'rust
 :override t
 :language 'c
 :override t
 :language 'go
 :override t)


(require 'combobulate)
(add-hook 'python-ts-mode-hook #'combobulate-mode)
(add-hook 'json-ts-mode-hook #'combobulate-mode)
(add-hook 'go-mode-hook #'combobulate-mode)

;; ;;C++ Settings
;; (defun my-c-mode-common-hook ()
;;  (c-set-offset 'substatement-open 0)
;;  (setq c++-tab-always-indent t)
;;  (setq c-basic-offset 4)                  ;; Default is 2
;;  (setq c-indent-level 4)                  ;; Default is 2

;;  (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
;;  (setq tab-width 4)
;;  (setq indent-tabs-mode t)  ; use spaces only if nil
;;  )

;; (add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;;Go Settings
 (use-package go-mode
  :init
  (setq lsp-go-analyses '((nilness . t)
						(shadow . t)
						(unusedwrite . t)
						(fieldalignment . t)
						(escape . t))))

(require 'flycheck-golangci-lint)

(setq go-ts-mode-indent-offset 4)


(eval-after-load 'flycheck                                       
  '(add-hook 'go-mode-hook #'flycheck-golangci-lint-setup))

;;LSP Settings:
(use-package lsp-mode
  :init
  (setq lsp-log-io nil
		lsp-file-watch-threshold 2000
		lsp-idle-delay 0.1
		lsp-enable-file-watchers nil
		eldoc-documentation-strategy 'eldoc-documentation-compose-eagerly
		flycheck-clang-include-path (list (expand-file-name "~/Programming/cpp/local_includes"))
		lsp-diagnostics-provider :auto
		lsp-eldoc-render-all t)
  :hook
  ((c++-mode .    lsp)
   (python-ts-mode . lsp)
   (bash-ts-mode .   lsp)
   (go-mode .        lsp)
   (zig-mode .       lsp)
   (c-ts-mode .      lsp)
   (rust-ts-mode .   lsp)
   (json-ts-mode .   lsp)
   (toml-ts-mode . lsp)
   (go-ts-mode . lsp)
   (T-mode . lsp)
   (cmake-ts-mode . lsp))
  :commands lsp)

;;T-mode Settings for LSP Dev:

(add-to-list 'auto-mode-alist '("\\.T" . T-mode))

(require 'T-mode)

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-language-id-configuration
               '(T-mode . "T"))

  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection "my_lsp")
                    :activation-fn (lsp-activate-on "T")
                    :server-id 'my_lsp)))

;;Taplo LSP Settings:
(add-hook 'toml-ts-mode-hook #'exec-path-from-shell-initialize)

;;emacs-lsp-booster settings:
(advice-add (if (progn (require 'json)
		       (fboundp 'json-parse-buffer))
		'json-parse-buffer
	      'json-read)
	    :around
	    #'lsp-booster--advice-json-parse)

(advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)

;;LSP-UI Settings:
(use-package lsp-ui
  :init
  (setq lsp-ui-doc-show-with-mouse nil
		lsp-ui-doc-position 'at-point
		lsp-keymap-prefix "M-l")
  :commands lsp-ui-peek-mode
  :after lsp-mode)

;;Dap-Mode Settings:
(require 'dap-python)
(setq dap-python-debugger 'debugpy)

(dap-register-debug-template "Python Template 1"
  (list :type "python"
        :args ""
        :env '(("DEBUG" . "1"))
        :request "launch"
		:debugger 'debugpy
        :name "Debugpy 1"))

;;Rust Mode Settings:
(defun my-rust-settings ()
  (flycheck-rust-setup)
  (lsp-ui-sideline-mode 1)
)

(with-eval-after-load 'lsp-rust
  (require 'dap-cpptools))

(with-eval-after-load 'dap-cpptools
    (dap-register-debug-template "Rust::CppTools Run Configuration"
                                 (list :type "cppdbg"
                                       :request "launch"
                                       :name "Rust::Run"
                                       :MIMode "gdb"
                                       :miDebuggerPath "rust-gdb"
                                       :environment []
                                       :program "${workspaceFolder}/target/debug/monkey"
                                       :cwd "${workspaceFolder}"
                                       :console "external"
                                       :dap-compilation "cargo build"
                                       :dap-compilation-dir "${workspaceFolder}")))

(add-hook 'rust-ts-mode #'my-rust-settings)
(add-hook 'before-save-hook (lambda () (when (eq major-mode 'rust-ts-mode))
							  #'rust-format-buffer))



;;Clang-Tidy Flycheck Settings:
(require 'flycheck-clang-tidy)
(setq flycheck-c/c++-clang-tidy-executable "/usr/lib/llvm/19/bin/clang-tidy"
	  flycheck-clang-tidy-executable "/usr/lib/llvm/19/bin/clang-tidy")
(eval-after-load 'flycheck
  (when (eq major-mode 'c++-mode)
	'(add-hook 'flycheck-mode-hook #'flycheck-clang-tidy-setup)))

;;Clang-format Settings:
(setq clang-format-fallback-style "llvm")

;;Yapf Settings:
(require 'yapfify)
(add-hook 'python-base-mode-hook 'yapf-mode)

;;Yasnippet
(require 'yasnippet)
(yas-global-mode 1)


;;Python Language server:
(use-package lsp-pyright
  :ensure t
  :init
  (setq-default indent-tabs-mode t
				tab-width 4
				py-indent-tabs-mode t)
  
  (setq python-indent-guess-indent-offset nil)
  :hook (python-base-mode-hook . (lambda ()  (require 'lsp-pyright)))
											
  :after lsp-mode)

;;Python Doc tool Settings:
(require 'sphinx-doc)
(require 'python-docstring)
(add-hook 'python-base-mode-hook (lambda () (sphinx-doc-mode t)
								   (python-docstring-mode t)))

;;Pylint Settings:
(require 'pylint)

;;Pytest Settings:
(require 'python-pytest)

;;Dev Docs Settings:
(require 'devdocs)
(add-hook 'c++-mode-hook (lambda() (setq devdocs-current-docs '("cpp"))))
(add-hook 'python-base-mode-hook (lambda() (setq devdocs-current-docs '("python~3.12"))))

;;Python Venv Settings:
(require 'pyvenv)
(pyvenv-mode 1)

;;Python Pet-mode Settings:
(require 'pet)
(add-hook 'python-base-mode-hook 'pet-mode -10)

;;GDB Settings:
(require 'gdb-mi)
(gdb-many-windows 1)

;;Beardbolt Settings:
(require 'beardbolt)
(setq beardbolt--shell "zsh")	  
(add-to-list 'beardbolt-languages '(c++-ts-mode beardbolt--c/c++-setup :base-cmd "clang++" :language "c++"))

(use-package cmake-ts-mode
   :mode "\\CMakeLists.txt\\'")

(defun venv-when-cmake-mode-function ()
  "Put some bullshit here"
  (when (eq major-mode 'cmake-ts-mode)
	(pyvenv-activate "/home/david/Programming/py/scratch-pad")(lsp)))
  
(add-hook 'cmake-ts-mode-hook #'venv-when-cmake-mode-function)

;;(add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Org-Mode-Settings;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'Info-default-directory-list
              "/home/david/.emacs.d/packages/org-info-files")

(add-to-list 'auto-mode-alist
			 '("\\.org\\'" . org-mode))

(use-package org
  :pin gnu
  :init
  (setq org-todo-keywords
		'((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE"))
		org-indent-indentation-per-level 3
		org-adapt-indentation nil
		org-hide-leading-stars t
		org-startup-folded t
		org-startup-indented t
		org-agenda-files '("/home/david/Org_Docs")
		org-log-done 'note
		org-cycle-separator-lines 1
		org-hide-emphasis-markers t
		org-blank-before-new-entry '((heading         . t)
									 (plain-list-item . nil))
		org-tag-alist '((:startgroup       . nil)
						("@C++"            . 1)
						("@Python"         . 2)
						("@Elisp"          . 3)
						(:endgroup         . nil)
						("C++ Definitions" . c))))

(add-hook 'org-mode-hook (lambda()  (org-indent-mode 1)))

;; Org Roam Settings:
(setq org-roam-directory (file-truename "~/Documents/Org-Roam")
	  find-file-visit-truename t
	  org-roam-auto-replace-fuzzy-links nil
	  org-roam-database-connector 'sqlite-builtin
	  org-roam-completion-everywhere t
	  org-roam-db-gc-threshold most-positive-fixnum)

(add-to-list 'recentf-exclude (recentf-expand-file-name "~/Documents/Org-roam/"))

(require 'org-roam)
(require 'info)

(org-roam-db-autosync-mode 1)
(setq org-roam-capture-templates
	  '(("d" "default" plain "%?" :target
 		 (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
		 :unnarrowed t)
 		("t" "C++ Term" plain "Term: %?\nDefinition: \nReference: "
 		 :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: C++ Definition")
		 :unnarrowed t
 		 :kill-buffer t)
 		("q" "Quick Note" plain "Thought: %?\nLink: "
 		 :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
 		 :unnarrowed t)))

(setq my-cleanup-roam-buffers--timer
      (run-with-idle-timer
       30 30 #'my-cleanup-roam-buffers))

(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
