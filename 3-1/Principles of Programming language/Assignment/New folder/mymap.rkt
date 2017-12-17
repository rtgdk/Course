;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname exercise2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ())))
(define (mymap function list)
  (cond ((null? list) '())
        ((list? (car list))(cons (mymap function (car list)) (mymap function (cdr list))))
        (else
         (cons (function (car list))(mymap function (cdr list))))))