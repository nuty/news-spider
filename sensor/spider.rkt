#lang racket

(require 
  rapider)

; article-new-default-font


(define sensor-spider%
  (class spider%

    (init-field 
      (name "sensor")
      (pages 100)
      (header '("User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36"))
      (base-url "https://www.eefocus.com/sensor/"))

    (define/public (start)
      (request this base-url 'parse-list))

    (define/public (parse-list rsp)
      (display rsp))

  (super-new)))

(run-spider sensor-spider%)