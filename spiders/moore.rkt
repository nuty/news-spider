#lang racket

(require
  rapider
  html-parsing
  "../items/moore.rkt")


(define moore-spider%
  (class spider%

    (init-field 
      (name "moore")
      (header '("User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) 
              AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36"))
      
      (base-url "http://news.moore.ren")
      (pages 200)
      (start-urls 
        (map 
          (lambda (x) (string-append base-url "/industry/?p=" (number->string x))) (range 1 pages))))

    (define/public (start)
      (for ([url start-urls])
        (request this url 'parse-items)))

    (define/public (parse-items rsp)
      (define partern "//*[@class='article']")
      (define content (html->xexp (response-content rsp)))
      (for ([elem (extract-data content partern)])
        (define before (moore-item elem))
        (define url (string-append base-url (hash-ref before "url")))
        (request this url 'parse-content before)))

    (define/public (parse-content rsp extra)
      (define content (html->xexp (response-content rsp)))
      (define content-item (moore-content-item content))
      (next this (list extra content-item) 'save-to-csv))
      ; (next this rsp 'save-to-html))

    (define/public (save-to-html rsp)
      (define url (response-url rsp))
      (define html-file
        (string-append 
          "data/htmls/moore/"
         (last (string-split url "/"))
          "l"))
      (define out-html (open-output-file html-file #:exists 'append))
      (define html (response-content rsp))
      (display html out-html)
      (close-output-port out-html))

    (define/public (save-to-csv data)
      (define csv-file "data/csv/moore1.csv")
      (define out-csv (open-output-file csv-file #:exists 'append))
      (let* ([before (first data)]
          [after (last data)]
          [line (string-append
            (string-join 
              (list 
                (hash-ref before "title" "暂无") 
                (hash-ref before "summary" "暂无") 
                (hash-ref before "date" "暂无") 
                (hash-ref before "tags" "暂无") 
                (hash-ref before "url" "暂无") 
                (hash-ref after "author" "暂无") 
                (hash-ref after "source" "暂无") 
                (hash-ref after "read-count" "暂无"))
            "Λ ") "\n")])
        (display line out-csv)
        (close-output-port out-csv)))

  (super-new)))

(provide moore-spider%)