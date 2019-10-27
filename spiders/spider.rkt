#lang racket

(require
  json
  rapider
  html-parsing
  "items/article.rkt")

; article-new-default-font


(define tech-channel-hash
  (hash
    "可编程逻辑" 7
    "MEMS/传感技术" 2
    "嵌入式系统" 6
    "模拟/电源" 1
    "射频/微波" 3
    "测试测量" 4
    "控制器/处理器" 5
    "EDA/PCB" 8
    "基础器件"9))

(define industry-channel-hash
  (hash
    "医疗电子" 12
    "汽车电子" 11
    "消费电子" 13
    "工业电子" 14
    "通信/网络" 10))


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
        (request this url (list 
                            'save-mate-data
                            'parse-channel))))

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
      (define origin-url (response-url rsp))
      (define content (response-content rsp))
      (displayln (article-item (html->xexp content))))


  (super-new)))

;

(provide article-spider%)