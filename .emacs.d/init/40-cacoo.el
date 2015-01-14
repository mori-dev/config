
;; (require 'deferred)
;; (require 'concurrent)

;; (require 'cacoo)
;; (require 'cacoo-plugins)
;; (setq cacoo:api-key "APIKEY")

;; (global-set-key (kbd "M--") 'toggle-cacoo-minor-mode)

;; ;; 追加設定
;; ;(setq cacoo:img-dir-ok t) ; 画像フォルダは確認無しで作る


;; ;; キャッシュディレクトリを指定
;; (setq cacoo:img-dir "~/.emacs.d/cacoo-img-cache")
;; ;; y-or-no を省略
;; (setq cacoo:img-dir-ok t)

;; (setq cacoo:max-size 1000)

;; (setq cacoo:external-viewer nil)

;; ;; 
;; ;; [img:https://cacoo.com/diagrams/6m4ATG1ddlUiHPqd-0FAF7.png]
;; ;; [img:file://~/.emacs.d/image-dired/django1.png]



;; ;; *   バッファ全体に対して
;; ;;       o C-c , T : バッファのすべての図をテキストに戻す
;; ;;       o C-c , D : バッファのすべての図を表示する（キャッシュがあればネットワークに接続しない）
;; ;;       o C-c , R : バッファのすべての図を取得し直す
;; ;; * カーソール直後の図に対して
;; ;;       o C-c , t : テキストに戻す
;; ;;       o C-c , d : 図を表示する（キャッシュがあればネットワークに接続しない）
;; ;;       o C-c , r : 図を取得し直して表示する
;; ;;       o C-c , e : 図の編集画面を表示する
;; ;;       o C-c , v : 図の詳細画面を表示する
;; ;;       o C-c , V : ローカルの図を外部ビューアーで開く
;; ;; * Cacooの機能に対して
;; ;;       o C-c , N : 新規図の作成画面をブラウザで開く
;; ;;       o C-c , l : 図の一覧画面をブラウザで開く
;; ;; * ナビゲーション、編集
;; ;;       o C-c , n : 次の図に移動
;; ;;       o C-c , p : 前の図に移動
;; ;;       o C-c , i : 図のマークアップを挿入
;; ;;       o C-c , y : クリップボードのテキストを使って図のマークアップを挿入
;; ;; * その他
;; ;;       o C-c , C : キャッシュディレクトリを空にする
;; ;;       o 図のクリック : 図の編集画面を表示する
