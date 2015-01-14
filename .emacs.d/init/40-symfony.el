;; ;; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-
;;  ;; * Controler <=> template 間の移動
;;  ;; * 関連したファイルへの移動
;;  ;; * 使いやすいインターフェイスでのプロジェクト全てのファイルを対象としたファイル検索
;;  ;; * プロジェクトのgrep
;;  ;; * 自動更新付きのログファイル閲覧
;;  ;; * ROOTディレクトリへのTAGSファイルの自動生成
;;  ;; * テストが充実している

;; (require 'symfony)
;; (setq sf:candidate-number-limit 9999)

;; ;(setq sf:project-cache t)にするとエラーになる。

;; (fset 'sftest 'sf-cmd:execute-test)

;; (setq sf:number-of-lines-shown-when-opening-log-file 100)


;; ;;;; Keybinds
;; (sf:define-key "C-c t" 'sf-action:switch-to-template)
;; (sf:define-key "C-c a" 'sf-template:switch-to-action)
;; ;; (sf:define-key "C-c p" 'sf-cmd:primary-switch)
;; (sf:define-key "C-c a" 'sf-validator:switch-to-action)
;; (sf:define-key "C-c v" 'sf-action:switch-to-validator)

;; ;;いまいち
;; (sf:define-key "C-p" 'sf-cmd:primary-switch)
;; (sf:define-key "<up>" 'sf-cmd:primary-switch)

;; (sf:define-key "C-n" 'sf-cmd:relative-files)
;; (sf:define-key "<down>" 'sf-cmd:relative-files)

;; (sf:define-key "C-q m" 'sf-cmd:model-files)
;; (sf:define-key "C-q a" 'sf-cmd:action-files)
;; (sf:define-key "C-q h" 'sf-cmd:helper-files)

;; (sf:define-key "C-q T" 'sf-cmd:test-files)

;; (sf:define-key "C-q l" 'sf-cmd:open-log-file)
;; (sf:define-key "C-q C-t" 'sf-cmd:create-or-update-tags)


;; ;(sf:define-key "C-c ]" 'sf-cmd:anything-symfony-el-command)
;; ;(sf:define-key "C-]" 'sf-cmd:anything-symfony-el-command)
