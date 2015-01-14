;;;  -*- coding: utf-8; mode: emacs-lisp; -*-
;;; ac-mysql.el -- ac-source for mysql

;; Copyright (C) 2009  IMAKADO <ken.imakado@gmail.com>

;; Author: IMAKADO <ken.imakado@gmail.com>
;; blog: http://d.hatena.ne.jp/IMAKADO (japanese)
;; Prefix: ac-mysql-

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; Installation:

;; put `ac-mysql.el' somewhere in your emacs load path.
;; add these lines to your .emacs file:
;; -------------- .emacs -----------------------------
;; (add-hook 'sql-mode-hook
;;           (lambda ()
;;             (require 'auto-complete)
;;             (require 'ac-mysql)
;;             (make-variable-buffer-local 'ac-sources)
;;             (add-to-list 'ac-sources
;;                          'ac-source-mysql)))

;; (add-hook 'sql-interactive-mode-hook
;;           (lambda ()
;;             (require 'auto-complete)
;;             (require 'ac-mysql)
;;             (make-variable-buffer-local 'ac-sources)
;;             (add-to-list 'ac-sources
;;                          'ac-source-mysql)))
;; ---------------------------------------------------

(require 'auto-complete)

;; funcs,keywords,types are stolen from sql.el
(defvar ac-mysql-functions
  (mapcar
   'upcase
   '("ascii" "avg" "bdmpolyfromtext" "bdmpolyfromwkb" "bdpolyfromtext"
     "bdpolyfromwkb" "benchmark" "bin" "bit_and" "bit_length" "bit_or"
     "bit_xor" "both" "cast" "char_length" "character_length" "coalesce"
     "concat" "concat_ws" "connection_id" "conv" "convert" "count"
     "curdate" "current_date" "current_time" "current_timestamp" "curtime"
     "elt" "encrypt" "export_set" "field" "find_in_set" "found_rows" "from"
     "geomcollfromtext" "geomcollfromwkb" "geometrycollectionfromtext"
     "geometrycollectionfromwkb" "geometryfromtext" "geometryfromwkb"
     "geomfromtext" "geomfromwkb" "get_lock" "group_concat" "hex" "ifnull"
     "instr" "interval" "isnull" "last_insert_id" "lcase" "leading"
     "length" "linefromtext" "linefromwkb" "linestringfromtext"
     "linestringfromwkb" "load_file" "locate" "lower" "lpad" "ltrim"
     "make_set" "master_pos_wait" "max" "mid" "min" "mlinefromtext"
     "mlinefromwkb" "mpointfromtext" "mpointfromwkb" "mpolyfromtext"
     "mpolyfromwkb" "multilinestringfromtext" "multilinestringfromwkb"
     "multipointfromtext" "multipointfromwkb" "multipolygonfromtext"
     "multipolygonfromwkb" "now" "nullif" "oct" "octet_length" "ord"
     "pointfromtext" "pointfromwkb" "polyfromtext" "polyfromwkb"
     "polygonfromtext" "polygonfromwkb" "position" "quote" "rand"
     "release_lock" "repeat" "replace" "reverse" "rpad" "rtrim" "soundex"
     "space" "std" "stddev" "substring" "substring_index" "sum" "sysdate"
     "trailing" "trim" "ucase" "unix_timestamp" "upper" "user" "variance")))

(defvar ac-mysql-keywords
  (mapcar
   'upcase
   '("action" "add" "after" "against" "all" "alter" "and" "as" "asc"
     "auto_increment" "avg_row_length" "bdb" "between" "by" "cascade"
     "case" "change" "character" "check" "checksum" "close" "collate"
     "collation" "column" "columns" "comment" "committed" "concurrent"
     "constraint" "create" "cross" "data" "database" "default"
     "delay_key_write" "delayed" "delete" "desc" "directory" "disable"
     "distinct" "distinctrow" "do" "drop" "dumpfile" "duplicate" "else"
     "enable" "enclosed" "end" "escaped" "exists" "fields" "first" "for"
     "force" "foreign" "from" "full" "fulltext" "global" "group" "handler"
     "having" "heap" "high_priority" "if" "ignore" "in" "index" "infile"
     "inner" "insert" "insert_method" "into" "is" "isam" "isolation" "join"
     "key" "keys" "last" "left" "level" "like" "limit" "lines" "load"
     "local" "lock" "low_priority" "match" "max_rows" "merge" "min_rows"
     "mode" "modify" "mrg_myisam" "myisam" "natural" "next" "no" "not"
     "null" "offset" "oj" "on" "open" "optionally" "or" "order" "outer"
     "outfile" "pack_keys" "partial" "password" "prev" "primary"
     "procedure" "quick" "raid0" "raid_type" "read" "references" "rename"
     "repeatable" "restrict" "right" "rollback" "rollup" "row_format"
     "savepoint" "select" "separator" "serializable" "session" "set"
     "share" "show" "sql_big_result" "sql_buffer_result" "sql_cache"
     "sql_calc_found_rows" "sql_no_cache" "sql_small_result" "starting"
     "straight_join" "striped" "table" "tables" "temporary" "terminated"
     "then" "to" "transaction" "truncate" "type" "uncommitted" "union"
     "unique" "unlock" "update" "use" "using" "values" "when" "where"
     "with" "write" "xor")))

(defvar ac-mysql-types
  (mapcar
   'upcase
   '("bigint" "binary" "bit" "blob" "bool" "boolean" "char" "curve" "date"
    "datetime" "dec" "decimal" "double" "enum" "fixed" "float" "geometry"
    "geometrycollection" "int" "integer" "line" "linearring" "linestring"
    "longblob" "longtext" "mediumblob" "mediumint" "mediumtext"
    "multicurve" "multilinestring" "multipoint" "multipolygon"
    "multisurface" "national" "numeric" "point" "polygon" "precision"
    "real" "smallint" "surface" "text" "time" "timestamp" "tinyblob"
    "tinyint" "tinytext" "unsigned" "varchar" "year" "year2" "year4"
    "zerofill")))

(defun ac-mysql-get-cands ()
  (let ((los (append
              ac-mysql-functions
              ac-mysql-keywords
              ac-mysql-types)))
    (ignore-errors
      (all-completions
       (upcase ac-target)
       los))))

(defvar ac-source-mysql
  '((candidates . ac-mysql-get-cands)))

(provide 'ac-mysql)
;;; ac-mysql.el ends here
