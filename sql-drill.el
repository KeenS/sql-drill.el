;;; sql-drill.el --- apache drill support for sql-mode  -*- lexical-binding: t -*-
;; Use of this source code is governed by a BSD-style
;; license that can be found in the LICENSE file.
;; Copyright (C) 2016 ¦Êeen

;; Author: Sunrin KIM(¦Êeen <3han5chou7@gmail.com
;; Maintainer: Sunrin KIM <3han5chou7@gmail.com
;; Version: 0.0.1
;; URL: https://github.com/KeenS/cssfmt.el
;; Keywords: comm languages processes
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;; This is an apache drill support for sql-mode. You can connect to Apache Drill following below
;; 1) set sql-product drill
;;    M-x sql-set-product RET drill
;; 2) connect to the drill server
;;    M-x sql-product-interactive RET (or C-c C-i)
;;    then, enter connection info
;;    server: the jdbc path to apache drill
;;            ex) jdbc:drill:zk=localhost:2181
;;            leave empty if you meant to standalone drill-embedded
;;    user: the user of apache drill.
;;          leave empty if there aren't.
;;    password: the password of apache drill.
;;          leave empty if there aren't.
;;; Bugs:
;;
;;; Code:
(require 'sql)

(defvar sql-mode-drill-font-lock-keywords
  (eval-when-compile
    (list
     (sql-font-lock-keywords-builder 'font-lock-keyword-face nil
"abs" "all" "allocate" "allow" "alter" "and" "any" "are" "array" "as"
"asensitive" "asymmetric" "at" "atomic" "authorization" "avg" "begin" "between" "bigint"
"binary" "bit" "blob" "boolean" "both" "by" "call" "called" "cardinality"
"cascaded" "case" "cast" "ceil" "ceiling" "char" "character" "character_length"
"char_length" "check" "clob" "close" "coalesce" "collate" "collect" "column"
"commit" "condition" "connect" "constraint" "convert" "corr" "corresponding" "count"
"covar_pop" "covar_samp" "create" "cross" "cube" "cume_dist" "current" "current_catalog"
"current_date" "current_default_transform_group" "current_path" "current_role"
"current_schema" "current_time" "current_timestamp" "current_transform_group_for_type"
"current_user" "cursor" "cycle" "databases" "date" "day" "deallocate" "dec"
"decimal" "declare" "default" "default_kw" "delete" "dense_rank" "deref" "describe"
"deterministic" "disallow" "disconnect" "distinct" "double" "drop" "dynamic" "each"
"element" "else" "end" "end_exec" "escape" "every" "except" "exec" "execute" "exists"
"exp" "explain" "external" "extract" "false" "fetch" "files" "filter" "first_value"
"float" "floor" "for" "foreign" "free" "from" "full" "function" "fusion" "get" "global"
"grant" "group" "grouping" "having" "hold" "hour" "identity" "import" "in" "indicator"
"inner" "inout" "insensitive" "insert" "int" "integer" "intersect" "intersection"
"interval" "into" "is" "join" "language" "large" "last_value" "lateral" "leading"
"left" "like" "limit" "ln" "local" "localtime" "localtimestamp" "lower" "match" "max"
"member" "merge" "method" "min" "minute" "mod" "modifies" "module" "month" "multiset"
"national" "natural" "nchar" "nclob" "new" "no" "none" "normalize" "not" "null"
"nullif" "numeric" "octet_length" "of" "offset" "old" "on" "only" "open" "or" "order"
"out" "outer" "over" "overlaps" "overlay" "parameter" "partition" "percentile_cont"
"percentile_disc" "percent_rank" "position" "power" "precision" "prepare" "primary"
"procedure" "range" "rank" "reads" "real" "recursive" "ref" "references" "referencing"
"regr_avgx" "regr_avgy" "regr_count" "regr_intercept" "regr_r2" "regr_slope" "regr_sxx"
"regr_sxy" "release" "replace" "result" "return" "returns" "revoke" "right" "rollback"
"rollup" "row" "rows" "row_number" "savepoint" "schemas" "scope" "scroll" "search"
"second" "select" "sensitive" "session_user" "set" "show" "similar" "smallint" "some"
"specific" "specifictype" "sql" "sqlexception" "sqlstate" "sqlwarning" "sqrt" "start"
"static" "stddev_pop" "stddev_samp" "submultiset" "substring" "sum" "symmetric" "system"
"system_user" "table" "tables" "tablesample" "then" "time" "timestamp" "timezone_hour"
"timezone_minute" "tinyint" "to" "trailing" "translate" "translation" "treat" "trigger"
"trim" "true" "uescape" "union" "unique" "unknown" "unnest" "update" "upper" "use"
"user" "using" "value" "values" "varbinary" "varchar" "varying" "var_pop" "var_samp"
"when" "whenever" "where" "width_bucket" "window" "with" "within" "without" "year"))))


(defcustom sql-drill-program
  (or (executable-find "drill-embedded")
      (executable-find "sqlline"))
  "Command to start drill client")

(defcustom sql-drill-options nil
  "List of additional options for `sql-drill-program'."
  :type '(repeat string)
  :group 'SQL)

(defcustom sql-drill-login-params '(server user password)
  "List of login parameters needed to connect to Apache Drill."
  :type 'sql-login-params
  :group 'SQL)

(defun sql-comint-drill (product options)
  "Connect to apache drill in a comint buffer."
  (let ((params
         (append
          (if (not (string= "" sql-user))
              (list "-n" sql-user))
          (if (not (string= "" sql-password))
              (list "-p" sql-password))
          (if (not (string= "" sql-server))
              (list "-u" sql-server))
          options)))
    (sql-comint product params)))


(add-to-list 'sql-product-alist
  '(drill
    :name "Apatch Drill"
    :free-software t
    :font-lock sql-mode-drill-font-lock-keywords
    :sqli-program sql-drill-program
    :sqli-options sql-drill-options
    :sqli-login sql-drill-login-params
    :sqli-comint-func sql-comint-drill
    :list-all "SHOW TABLES;"
    :list-table "DESCRIBE %s;"
;    :completion-object sql-drill-completion-object
    :prompt-regexp ".*?> "
    :prompt-cont-regexp "^\\(\\. \\)*\\.> "
    :terminator ";"))


(provide 'sql-drill)

;;; sql-drill.el ends here

; LocalWords:  sql SQL ApacheDrill Drill
