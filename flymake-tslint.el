;; flymake-tslint.el --- A flymake handler for Typescript using tslint

;; Copyright (c) 2018 Mark H. Colburn

;; Author: Mark H. Colburn <colburn.mark@gmail.com>
;; Homepage: https://github.com/markcol/flymake-tslint
;; Package-Version: 0
;; Package-Requires: ((flymake-easy "0.1"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; References:
;;   https://github.com/palantir/tslint
;;
;; Usage:
;;   (require 'flymake-tslint)
;;   (add-hook 'ts-mode-hook 'flymake-tslint-load)
;;
;; Uses flymake-easy, from https://github.com/purcell/flymake-easy

;;; Code:

(require 'flymake-easy)

(defgroup flymake-tslint nil
  "Flymake checking of Typescript using tslint"
  :group 'programming
  :prefix "flymake-tslint-")

;;;###autoload
(defcustom flymake-tslint-command
  "tslint"
  "Name (and optionally full path) of tslint executable."
  :type 'string :group 'flymake-tslint)

;;;###autoload
(defcustom flymake-tslint-args
  (mapcar
   'symbol-name
   '())
  "Command-line args for tslint executable."
  :type '(repeat string) :group 'flymake-tslint)

(defcustom flymake-tslint-config
  "tslint.json"
  "Name of tslint configuration file."
  :type '(string) :group 'flymake-tslint)

(defcustom flymake-tslint-rulesdir
  nil
  "The directory of custom rules for TSLint.
The value of this variable is either a string containing the path
to a directory with custom rules, or nil, to not give any custom
rules to TSLint.
Refer to the TSLint manual at URL
`http://palantir.github.io/tslint/usage/cli/'
for more information about the custom directory."
  :group 'flymake-tslint
  :type '(choice (const :tag "No custom rules directory" nil)
                 (directory :tag "Custom rules directory"))
  :safe #'stringp)

(defconst flymake-tslint-err-line-patterns
  '(("^ERROR: \\(.+\\)\\[\\([0-9]+\\), \\([0-9]+\\)\\]: \\(.+\\)$" 1 2 3 4)
    ("^WARNING: \\(.+\\)\\[\\([0-9]+\\), \\([0-9]+\\)\\]: \\(.+\\)$" 1 2 3 4))
  "Patterns for matching error/warning lines.
Each pattern has the form (REGEXP FILE-IDX LINE-IDX COL-IDX
ERR-TEXT-IDX).")

(defun flymake-tslint-command (filename)
  "Construct a command that flymake can use to check Typescript source in FILENAME."
  (append
   (list flymake-tslint-command)
   flymake-tslint-args
   (when flymake-tslint-config
     `("--config" ,flymake-tslint-config))
   (when flymake-tslint-rulesdir
     `("--rules_dir" ,flymake-tslint-rulesdir))
   (list filename)))

;;;###autoload
(defun flymake-tslint-load ()
  "Configure flymake mode to check the current buffer's Typescript syntax."
  (interactive)
  (flymake-easy-load 'flymake-tslint-command
                     (append flymake-tslint-err-line-patterns)
                     'tempdir
                     "ts"))

(provide 'flymake-tslint)
;;; flymake-tslint.el ends here
