#lang racket
(require
    rapider
    net/base64
    txexpr)

(provide
  article-item)

(define article-item
  (item
    (item-field 
      #:name "title" 
      #:xpath "/html/body/div[2]/div[2]/div/div[1]/h1/text()" 
      #:filter (λ (x) (string-trim (second x))))
    (item-field 
      #:name "date" 
      #:xpath "/html/body/div[2]/div[2]/div/div[1]/div/div/div/span[1]/text()"
      #:filter (λ (x) (string-trim (second x))))
    (item-field
      #:name "author"
      #:xpath "/html/body/div[2]/div[2]/div/div[1]/div/div/div/span[2]/a/text()"
      #:filter (λ (x) (if (empty? x) "" (string-trim (second x)))))
    (item-field
      #:name "tip" 
      #:xpath "/html/body/div[2]/div[2]/div/div[1]/div/div/div/span[3]/text()"
     #:filter (λ (x) (string-join x)))
    (item-field
      #:name "content"
      #:xpath "/html/body/div[2]/div[2]/div/div[2]/div[2]"
      #:filter (λ (x) 
        (bytes->string/utf-8 
          (base64-encode (string->bytes/utf-8 (xexpr->string (car x)))))))))
