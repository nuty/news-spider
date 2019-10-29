#lang racket
(require
    rapider
    net/base64
    txexpr)

(provide
  before-item)


(define before-item
  (item
    (item-field 
      #:name "url" 
      #:xpath "*//a/@href/text()"
      #:filter (λ (x) (car x)))
    (item-field 
      #:name "cover" 
      #:xpath "*//a/img/@src/text()"
      #:filter (λ (x) (car x)))
    (item-field 
      #:name "title" 
      #:xpath "*//a/img/@title/text()"
      #:filter (λ (x) (car x)))
    (item-field
      #:name "summary"
      #:xpath "//*[@class='p']/text()"
      #:filter (λ (x) (car x)))
    (item-field
      #:name "category"
      #:xpath "//*[@class='a-name']/a/@title/text()"
      #:filter (λ (x) (car x)))
    (item-field
      #:name "category-url"
      #:xpath "//*[@class='a-name']/a/@href/text()"
      #:filter (λ (x) (car x)))
    (item-field
      #:name "author" 
      #:xpath "//*[@class='a-author']/text()"
      #:filter (λ (x) (car x)))
    (item-field
      #:name "date"
      #:xpath "//*[@class='date']/text()"
      #:filter (λ (x) (car x)))))