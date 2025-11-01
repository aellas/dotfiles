;;; init.el -*- lexical-binding: t; -*-
(doom!
 :completion
 (company +auto)
 (vertico +icons)

 :ui
 doom
 doom-dashboard
 doom-quit
 hl-todo
 modeline
 nav-flash
 ophints
 (popup +defaults)
 ligatures
 smooth-scroll
 tabs
 treemacs
 vi-tilde-fringe
 window-select
 
 :editor
 (evil +everywhere)
 file-templates
 fold
 (format +onsave)
 multiple-cursors
 snippets
 word-wrap

 :emacs
 tramp
 vc
 (dired +icons)
 electric
 (ibuffer +icons)
 (undo +tree)

 :term
 vterm

 :checkers
 (syntax +flymake)
 (spell +flyspell)
 grammar

 :tools
 (eval +overlay)
 (lookup +docsets)
 lsp
 (magit +forge)
 pdf
 tree-sitter

 :lang
 bash
 sh
 (c +lsp)
 css
 docker
 html
 (json +lsp)
 markdown
 (nix +tree-sitter +lsp)
 toml
 yaml
 (lua +lsp +treesitter)
 (python +lsp +treesitter)
 org
 emacs-lisp

 :config
 (default +bindings +smartparens))
