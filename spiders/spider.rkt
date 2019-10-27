#lang racket

(require
  json
  rapider
  html-parsing
  "items/article.rkt")

(define article-spider%
  (class spider%

    (init-field 
      (name "sensor")
      (header '("User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) 
              AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36"))
      (base-url "https://www.eefocus.com")
      (base-api-url "https://www.eefocus.com/article/index/more.articles?p=1&channel=")
      (start-urls (map 
        (lambda (x) 
          (string-append base-api-url (number->string x))) (range 1 14))))

    (define/public (start)
      (for ([url start-urls])
        (request this url (list 'save-mate-data   'parse-channel))))

    (define/public (save-mate-data rsp)
      (define url (response-url rsp))
      (define content (response-content rsp))
      (define channel (last (string-split url "=")))
      (define file-path (string-append "data/meta/" channel ".json"))
      (define out (open-output-file file-path #:exists 'append))
      (display content out)
      (close-output-port out))

    (define/public (parse-channel rsp)
      (define origin-url (response-url rsp))
      (define content (response-content rsp))
      (define ret-hash
        (with-input-from-string content (λ () (read-json))))
      (for ([data (hash-ref ret-hash 'data)])
        (let ([url (string-append base-url (hash-ref data 'url))])
         (request this url 'parse-page)))
      (void))

    (define/public (parse-page rsp)
      (define content (response-content rsp))
      (define aitem (article-item (html->xexp content)))
      (define save-to-file (string-append "data/meta/db.csv"))
      (define out (open-output-file save-to-file #:exists 'append))

      (define line
        (string-append 
          (string-join 
            (list 
              (hash-ref aitem "title" "") 
              (hash-ref aitem "author" "")
              (hash-ref aitem "date" "")
              (hash-ref aitem "tip" "")
              (hash-ref aitem "content" ""))
             ", ")
          "\n"))
      (display line out)
      (close-output-port out))

  (super-new)))

;

(provide article-spider%)