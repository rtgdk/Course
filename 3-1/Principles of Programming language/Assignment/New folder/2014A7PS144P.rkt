#lang racket
(provide (all-defined-out))
(define inputFile (vector-ref (current-command-line-arguments) 0))
;Step1
(define wordlist (file->list inputFile))
(define step1 wordlist)
;step1


;Global counter
(define id 0)
(define (increase_id x)(set! id (+ id 1)))
(define (nextid id) (increase_id id) (+ 1 id))

(define (finalinc x) (cond ((equal? (set! x (+ x 1)) 1234) 23)
                          (else x)))

;Step2
(define (clusterise x) (list (nextid id) (list (car x)) '()))
(define (createclusters x) ( cond ((> (length x) 1) (cons (clusterise x) (createclusters (cdr x))))
                                  ((= (length x) 1) (list (clusterise x)))))
(define step2 (createclusters wordlist))
;step2

;finding word to word distance
(define (member? u lst)
  (not (equal? (member u lst) #f)))

(define (dup l)
  (cond ((null? l) '())
        ((member (car l) (cdr l)) (dup (cdr l)))
        (else (cons (car l) (dup (cdr l))))))
(define (intersection1 x y) (cond ((null? y) y)
                                 ((member? (car y) x) (cons (car y) (intersection1 x (cdr y))))
                                 (else (intersection1 x (cdr y)))))
(define (intersection x y) (dup (intersection1 x y)))
(define (union1 x y) (cond ((null? y) x)
                          ((member? (car y) x) (union1 x (cdr y)))
        (else (union1 (cons (car y) x) (cdr y)))))
(define (union x y) (dup (union1 x y)))

                         
(define (WtoWdistance x y) (- 1 (/ (length (intersection (string->list (string-downcase (string->immutable-string(symbol->string x))))
                                   (string->list (string-downcase (string->immutable-string(symbol->string y))))))
                                   (length (union (string->list (string-downcase (string->immutable-string(symbol->string x))))
                                          (string->list (string-downcase (string->immutable-string(symbol->string y)))))))))
;Step3
(define (min lst)
    (cond ((null? (cdr lst)) (car lst))
          ((< (car lst) (min (cdr lst))) (car lst))
          (else (min (cdr lst)))) )

(define (distlst1 x ylist) (cond ((null? ylist) '())
                                 (else (append (list (WtoWdistance (car x) (car ylist))) (distlst1 x (cdr ylist))))))

(define (CtoCdistance1 x y) (cond 
                                 ((= (length x) 1) (min (distlst1 x y)))
                                 (else (min (list (min (distlst1 (list (car x)) y)) (CtoCdistance1 (cdr x) y))))))

(define (CtoCdistance x y) (cond ((= (car x) (car y)) 100)
                                 (else (CtoCdistance1 (car (cdr x)) (car (cdr y))))))

(define (cdistancelist x y) ( cond ((null? y) '())
                                    (else (cons (list (car (car y)) (CtoCdistance x (car y))) (cdistancelist x (cdr y))))))


                             
(define (initialise_cd x) (cond ( (null? x) '())
                                 (else (cons (list (car(car x)) (car(cdr(car x))) (cdistancelist (car x) step2)) (initialise_cd (cdr x))))))

(define step3 (initialise_cd step2))
;step3

;recognising the clusters to be merged
(define (findmin1 x) 
    (cond ((null? (cdr x)) (car (cdr (car x))))
          ((< (car (cdr (car x))) (findmin1 (cdr x))) (car (cdr (car x))))
          (else (findmin1 (cdr x)))) )
;(car (cdr (cdr x)))
(define (findmin2 x)( cond ((null? x) 1000)
                       (else (min (list (findmin1 (car (cdr (cdr (car x))))) (findmin2 (cdr x)))))))
  
(define (search_min1 x y) (cond ((null? y) -1)
                                 ((= x (car (cdr (car y)))) (car (car y)))
                                 (else (search_min1 x (cdr y)))))

(define (search_min2 x y) (cond 
                                 ((= -1 (search_min1 x (car (cdr (cdr (car y)))))) (search_min2 x (cdr y)))
                                 (else (list (car (car y)) (search_min1 x (car (cdr (cdr (car y)))))))))

(define merging_clusters (search_min2 (findmin2 step3) step3))

(define (tobemerged c) (search_min2 (findmin2 c) c))

(define (minab a b c) (cond ((null? a) (list (list id 100)))
                           ((or (= (car (car a)) (car (tobemerged c))) (= (car (car a)) (car (cdr (tobemerged c)))))( minab (cdr a) (cdr b) c))
                           (else (cons (list (car (car a)) (min (list (car (cdr (car a))) (car (cdr (car a)))))) ( minab (cdr a) (cdr b) c)))))

 (define (max c) (cond ((null? (cdr c)) (car (car c)))
                       (else (max (cdr c)))))



                  
(define (newcluster x y c)( list (+ 1 (max c)) (sort (append (car (cdr x)) (car (cdr y))) symbol<?) '())) ;(minab (car (cdr (cdr x))) (car (cdr (cdr y))) c)))

(define (searchcluster x y) (cond
                              ((= x (car (car y))) (car y))
                                  (else (searchcluster x (cdr y)))))
(define (addnew x y)  (reverse (cons   (newcluster (searchcluster (car x) y) (searchcluster (car (cdr x)) y) y)    (reverse y))))

;(define (remove x y ) (cond ((null? y) '())
 ;                           ((equal? (car (car y)) (car (searchcluster (car x) y))) (remove x (cdr y)) )
  ;                          (else (cons (car y) (remove (car x) (cdr y))))))

(define (deleteItem lst item)
  (cond ((null? lst) '())
        ((= item (car (car lst)))
         (cdr lst))
        (else
         (cons (car lst) 
               (deleteItem (cdr lst) item)))))
(define tp step3)
;(set! tp (addnew merging_clusters tp))
;(set! tp (append (car tp) (list (car (cdr tp)))))
;(set! tp (car tp))
;(deleteItem (deleteItem tp (car merging_clusters)) (car (cdr merging_clusters))) 

;(set! tp (deleteItem  (searchcluster (car (cdr merging_clusters)) tp)))
(define (removeandadd y) (deleteItem (deleteItem (addnew (tobemerged y) y ) (car (tobemerged y))) (car (cdr (tobemerged y))))) 

(define (getemptydist y)(cond ((null? y) '())
                                (else (cons (list (car (car y)) (car (cdr (car y))) '()) (getemptydist (cdr y))))))  

;(define (cluster initc) ( (tobemerged initc)

;(define fixed (getemptydist y))
;(define (getnew x) (cond ( (null? x) '())
 ;                                (else (cons (list (car(car x)) (car(cdr(car x))) (cdistancelist (car x) step2)) (initialise_cd (cdr x))))))

(define (initialise_cd1 x const) (cond ( (null? x) '())
                                 (else (cons (list (car(car x)) (car(cdr(car x))) (cdistancelist (car x) const)) (initialise_cd1 (cdr x) const)))))

(define (merger x) (initialise_cd1 (getemptydist (removeandadd x)) (getemptydist (removeandadd x))))

;(merger step3)
;(nextid id)
;(merger (merger (merger step3)))


(define (clustering c) (cond ((> (length c) 8) (clustering (merger c)))
                             (else c)))
  
(define step4 (clustering step3))
;step4

(define (printclus x) (cond ((null? (cdr x)) (string-append "" (symbol->string (car x))))
                            (else (string-append (symbol->string (car x)) " " (printclus (cdr x))))))

(define (printwords clus)
(cond ( (null? clus) "")
      ((=(length clus) 8) (string-append  (printclus (cadar clus)) (printwords (cdr clus))))
( else (string-append  "\n" (printclus (cadar clus))  (printwords (cdr clus)) )))
)


(define step5 (printwords step4))

