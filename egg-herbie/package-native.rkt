#lang racket/base

(require racket/cmdline
         racket/file
         racket/runtime-path)

;; The published platform package must not provide egg-herbie/main.rkt.
(define-runtime-path source-dir ".")

(define-values (package-name output-dir)
  (command-line #:args (package-name output-dir) (values package-name output-dir)))

(define library-name
  (string-append (if (equal? (system-type) 'windows) "egg_math" "libegg_math")
                 (bytes->string/utf-8 (system-type 'so-suffix))))

(make-directory output-dir)
(make-directory* (build-path output-dir "target" "release"))
(copy-file (build-path source-dir "target" "release" library-name)
           (build-path output-dir "target" "release" library-name))
(copy-file (build-path source-dir "LICENSE") (build-path output-dir "LICENSE"))

(call-with-output-file (build-path output-dir "info.rkt")
                       (lambda (out)
                         (fprintf out "#lang info\n")
                         (fprintf out "(define collection ~s)\n" package-name)
                         (fprintf out "(define version \"2.3\")\n")
                         (fprintf out "(define deps '((\"base\" #:version \"8.0\")))\n")
                         (fprintf out "(define pkg-desc \"Native egg_math library for Herbie\")\n")
                         (fprintf out "(define license 'MIT)\n")))
