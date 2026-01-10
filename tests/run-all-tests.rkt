#lang racket/gui

;; 运行所有测试的主文件
;; 该文件会自动查找并运行 tests 目录下的所有测试文件

(require rackunit/text-ui
         racket/file
         racket/path)

;; 获取所有测试文件的路径
(define (get-all-test-files base-dir)
  (let loop ([dir base-dir] [result '()])
    (for/fold ([res result])
              ([file (directory-list dir #:build? #t)])
      (cond
        [(directory-exists? file)
         (loop file res)]
        [(and (file-exists? file)
              (path-has-extension? file #".rkt")
              (regexp-match? #rx"test-" (path->string file)))
         (cons file res)]
        [else res]))))

;; 运行所有测试
(define (run-all-tests)
  (printf "=== 开始运行所有测试 ===\n")
  (let* ([test-dir (current-directory)]
         [test-files (get-all-test-files test-dir)])
    
    (printf "找到 ~a 个测试文件\n\n" (length test-files))
    
    (for ([file test-files])
      (printf "--- 运行 ~a ---\n" (path->string file))
      (with-handlers ([exn:fail? (lambda (e) 
                                   (printf "错误: ~a\n\n" (exn-message e)))])
        ;; 切换到测试文件所在目录，确保相对路径正确
        (parameterize ([current-directory (path-only file)])
          ;; 使用动态加载来运行测试文件
          (dynamic-require file #f)
          (printf "完成\n\n"))))
    
    (printf "=== 所有测试运行完成 ===\n")))

;; 主入口
(run-all-tests)