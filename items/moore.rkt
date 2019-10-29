#lang racket
(require
    rapider)


(provide
  moore-content-item
  moore-item)


(define moore-item
  (item
    (item-field
      #:name "title"
      #:xpath "//div[2]/a/h1/text()" 
      #:filter (λ (x) (car x)))
    (item-field
      #:name "summary"
      #:xpath "//div[2]/a/div/text()"
      #:filter (λ (x) (car x)))
    (item-field
      #:name "tags"
      #:xpath "//div[2]/summary/mark/ul/a/text()" 
      #:filter (λ (x) (string-join x "|")))
    (item-field
      #:name "date"
      #:xpath "//div[2]/summary/div[1]/div[1]/text()" 
      #:filter (λ (x) (car x)))
    (item-field
      #:name "url"
      #:xpath "//div[2]/a/@href/text()" 
      #:filter (λ (x) (car x)))))


(define moore-content-item
  (item
    (item-field
      #:name "author"
      #:xpath "/html/body/section/section/section/article/div/div[1]/span[1]/text()" 
      #:filter (λ (x) (car x)))
    (item-field
      #:name "source"
      #:xpath "/html/body/section/section/section/article/div/div[1]/span[4]/text()" 
      #:filter (λ (x) (car x)))
    (item-field
      #:name "read-count"
      #:xpath "/html/body/section/section/section/article/div/div[2]/span/text()" 
      #:filter (λ (x) (car x)))))
