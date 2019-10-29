#lang racket

(require
  json
  rapider
  html-parsing
  "../items/eefocus.rkt")


(define eefocus-spider%
  (class spider%

    (init-field 
      (name "eefocus")
      (header '("User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) 
              AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36"))
      
      (base-url "https://www.eefocus.com")
      (base-api-url "https://www.eefocus.com/article/index/more.articles")
      (channels 15)
      (pages 3)
      (start-urls (send this gen-start-urls)) )


    (define/public (gen-start-urls)
      (map (lambda (x) 
        (map (lambda (url) (string-append url "&channel=" (number->string x))) 
          (map (lambda (x) (string-append base-api-url "?p=" (number->string x))) 
        (range 1 pages))))
      (range 1 channels)))

    (define/public (start)
      (for ([url-cons start-urls])
        (for ([start-url url-cons])
          (request this start-url 'parse-channel))))

    (define/public (parse-channel rsp)
      (define content (response-content rsp))
      (define ret-hash
        (with-input-from-string content (λ () (read-json))))
      (for ([data (hash-ref ret-hash 'data)])
        (let ([url (string-append base-url (hash-ref data 'url))])
         (request this url 'parse-page data)))
      (void))

    (define/public (parse-page rsp extra)
      (define content (response-content rsp))
      (define aitem (article-item (html->xexp content)))
      (next this rsp (list 'save-to-csv 'save-to-html) (list aitem extra)))

    (define/public (save-to-html rsp extra)
      (define html-file
        (string-append 
          "data/htmls/eefocus/"
          (last (string-split (response-url rsp) "/")) 
          ".html"))
      (define out-html (open-output-file html-file #:exists 'append))
      (define html (response-content rsp))
      (display html out-html)
      (close-output-port out-html))

    (define/public (save-to-csv rsp extra)
      (define csv-file "data/csv/eefocus.csv")
      (define out-csv (open-output-file csv-file #:exists 'append))
      (let* 
        ([item (first extra)]
          [meta (second extra)]
          [line (string-append
                (string-join 
                  (list
                    (hash-ref item "title" "")
                    (hash-ref item "author" "")
                    (hash-ref item "date" "")
                    (hash-ref item "tip" "")
                    (hash-ref meta 'channel "")
                    (hash-ref meta 'channel_slug "")
                    (hash-ref meta 'channel_title "")
                    (hash-ref meta 'channel_url "")
                    (hash-ref meta 'id "")
                    (hash-ref meta 'image "")
                    (hash-ref meta 'subject "")
                    (hash-ref meta 'summary "")
                    (hash-ref meta 'thumb "")
                    (string-join (hash-values (hash-ref meta 'tag '())) "|")
                    (hash-ref meta 'time_publish "")
                  ) ", ") "\n")])
        (display line out-csv)
        (close-output-port out-csv)))


  (super-new)))


(provide eefocus-spider%)