#lang racket

(require
  json
  rapider
  html-parsing
  "../utils/main.rkt"
  "../items/semiinsights.rkt")


(define semiinsights-spider%
  (class spider%
    (init-field 
      (name "semiinsights")
      (header '("User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) 
              AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36"))
      (base-url "http://www.semiinsights.com")
      (pages 100)
      (start-urls 
        (map
          (lambda (x)
            (string-append 
              base-url "/index.php?m=content&c=index&a=showmore&page=" (number->string x))) 
                (range 1 pages))))

    (define/public (start)
      (for ([url start-urls])
        (request this url 'parse-list)))

    (define/public (parse-list rsp)
      (define partern "//*[@class='clearfix bor']")
      (define content (html->xexp (response-content rsp)))
      (for ([elem (extract-data content partern)])
        (define before (before-item elem))
        (request this (hash-ref before "url") 'parse-content before)))

    (define/public (parse-content rsp extra)
      (next this rsp 'save-to-html)
      (next this extra 'to-csv))

    (define/public (save-to-html rsp)
      (define url (response-url rsp))
      (define html-file
        (string-append 
          "data/htmls/semiinsights/"
          (string-replace (car (string-split (last (string-split url "//")) ".shtml")) "/" "-")
          ".html"))
      (define out-html (open-output-file html-file #:exists 'append))
      (define html (response-content rsp))
      (display html out-html)
      (close-output-port out-html))

    (define/public (to-csv data)
      (define out-csv (open-output-file "data/csv/semiinsights1.csv" #:exists 'append))
      (save-to-csv
        #:values-list (hash-values data)
        #:csv-port out-csv))

  (super-new)))


(provide semiinsights-spider%)