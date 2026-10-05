#lang racket/base

(require racket/file
         racket/match
         racket/runtime-path)

(define-runtime-path source-dir ".")

(define native-package-name
  (hash-ref #hash(("aarch64-macosx" . "egg-herbie-macosm1")
                  ("x86_64-macosx" . "egg-herbie-osx")
                  ("win32\\x86_64" . "egg-herbie-windows")
                  ("x86_64-linux" . "egg-herbie-linux")
                  ("x86_64-linux-natipkg" . "egg-herbie-linux"))
            (system-type 'platform)))

(define (stage-native-package output-dir)
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
                           (fprintf out "(define collection ~s)\n" native-package-name)
                           (fprintf out "(define version \"2.3\")\n")
                           (fprintf out "(define deps '((\"base\" #:version \"8.0\")))\n")
                           (fprintf out "(define pkg-desc \"Native egg_math library for Herbie\")\n")
                           (fprintf out "(define license 'MIT)\n"))))

(module+ main
  (match (vector->list (current-command-line-arguments))
    ['() (displayln native-package-name)]
    [(list output-dir) (stage-native-package output-dir)]))
