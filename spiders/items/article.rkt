#lang racket
(require
    rapider
    txexpr)

(provide
  article-item)

(define article-item
  (item
    (item-field #:name "title" #:xpath "/html/body/div[2]/div[2]/div/div[1]/h1/text()")
    (item-field #:name "date" #:xpath "/html/body/div[2]/div[2]/div/div[1]/div/div/div/span[1]/text()")
    (item-field #:name "author" #:xpath "/html/body/div[2]/div[2]/div/div[1]/div/div/div/span[2]/a/text()")
    (item-field #:name "tip" #:xpath "/html/body/div[2]/div[2]/div/div[1]/div/div/div/span[3]/text()")
    (item-field
      #:name "content"
      #:xpath "/html/body/div[2]/div[2]/div/div[2]/div[2]"
      #:filter (λ (x) (xexpr->string (car x))))))
