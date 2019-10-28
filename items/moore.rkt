#lang racket
(require
    rapider)

(provide
  moore-item)


(define moore-item
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
      #:name "cover"
      #:xpath "/html/body/div[2]/div[2]/div/div[1]/div/div/div/span[2]/a/text()"
      #:filter (λ (x) (if (empty? x) "" (string-trim (second x)))))
    (item-field
      #:name "summary"
      #:xpath "/html/body/div[2]/div[2]/div/div[1]/div/div/div/span[2]/a/text()"
      #:filter (λ (x) (if (empty? x) "" (string-trim (second x)))))
    (item-field
      #:name "tags" 
      #:xpath "/html/body/div[2]/div[2]/div/div[1]/div/div/div/span[3]/text()"
     #:filter (λ (x) (string-join x)))
))
