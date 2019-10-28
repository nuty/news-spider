#lang racket

(require
  rapider
  html-parsing
  "../items/moore.rkt")

; 



(define moore-spider%
  (class spider%

    (init-field 
      (name "moore")
      (header '("User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) 
              AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36"))
      
      (base-url "http://news.moore.ren/industry/")
      ; (pages 2226)
      (pages 2)
      (start-urls 
        (map 
          (lambda (x) (string-append base-url "?p=" (number->string x))) (range 1 pages))))

    (define/public (start)
      ; (for ([url start-urls])
        (request this "http://news.moore.ren/industry/?p=1" 'parse-items))
        ; (displayln url)))

    (define/public (parse-items rsp)
      (displayln rsp)
      ; (define partern "//*[@class='pc-col-6 padding-right-content']")
      ; (define content (html->xexp (response-content rsp)))
      ; (for ([elem (extract-data content partern)])
      ;   (define before (moore-item elem))
      ;   (displayln before)
      ;   )
      )


  (super-new)))

;

(provide moore-spider%)