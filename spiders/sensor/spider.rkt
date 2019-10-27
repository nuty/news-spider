#lang racket

(require 
  rapider)

; article-new-default-font


(define sensor-spider%
  (class spider%

    (init-field 
      (name "sensor")
      (header '("User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36"))
      (start-urls (list 
                    "https://www.eefocus.com/sensor/"
                    "https://www.eefocus.com/sensor/list-news"
                    "https://www.eefocus.com/sensor/list-product"
                    "https://www.eefocus.com/sensor/list-design")))

    (define/public (start)
      (for ([url start-urls])
        (request this url 'parse-sensor)))

    (define/public (parse-sensor url rsp)
      (void))



  (super-new)))

(run-spider sensor-spider%)