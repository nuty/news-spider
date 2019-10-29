#lang racket
(require 
  rapider
  "spiders/eefocus.rkt"
  "spiders/moore.rkt"
  "spiders/semiinsights.rkt")


; (run-spider eefocus-spider%)
(run-spider semiinsights-spider%)
; (run-spider moore-spider%)