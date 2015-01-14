

;; (setq uwpn-project-root-alist
;;       '(("/path/to/project_a/" . "プロジェクトA")
;;         ("/path/to/project_b/" . "プロジェクトB")
;;         ;; ("" . "")
;;         ))

(setq uwpn-project-root-alist
      '(("/opt/t/prj1" . "プロジェクトA")
        ("/opt/t/prj2" . "プロジェクトB")
        ;; ("" . "")
        ))

(setq uwpn-project-root-alist
      '(("/opt/phpmyadmin/" . "phpmyadmin")
        ("/opt/elevi/" . "elevi")
        ("/opt/parco/" . "parco")
        ("/opt/scoo/" . "scoo")
        ("/opt/blokan/" . "blokan")
        ("/opt/ntv/" . "ntv")
        ;; ("" . "")
        ))

(require 'uniquify_with_project_name)
