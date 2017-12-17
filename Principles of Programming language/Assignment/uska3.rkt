#lang racket

(define in (open-input-file "t0.in"))

;(define ini (vector-ref (current-command-line-arguments) 0 ))

;(define in (open-input-file ini))

(define k (string-split (read-line in)))

(define N (string->number (list-ref k 0)))
(define D (string->number(list-ref k 1)))
(define K (string->number(list-ref k 2)))
(define e (string->number(list-ref k 3)))
(define MinPts (string->number(list-ref k 4)))

(define (s1 lis1 count1)
  (cond
    ((> count1 N) lis1)
    (else (s1
           (append lis1
            (list (append 
            	(list count1) (list (map (lambda(x) (string->number x)) (string-split (read-line in)))))
            )
           )
           (+ count1 1)
          )
    )
  )
)

(define (s22 lis221 lis222 lis223 count22)
  (cond
  ((> count22 N) lis221) 
  (else (s22
         (append lis221 (list (append (list count22) (list (cond
                                      ((equal? (car (car  lis222)) (car (car lis223))) +inf.0)
                                      (else (sqrt (apply + (map (lambda(x y) (abs (expt (- x y)  2))) (car (cdr (car lis223))) (car (cdr (car  lis222)))))))
                                     ))
                                    )	
                            ))
         lis222
         (cdr lis223)
         (+ count22 1)
         ))))

(define (s21 lis21 lis22 count2)
  (cond
    ((> count2 N) lis21)
    (else (s21
           (append lis21 (list (s22 '() (list (car lis22)) step1 1)))

           (cdr lis22)
           
           (+ count2 1)
          )
    )
  )
)

(define (s3 lis31 lis32 count3)
  (cond
    ((> count3 N) lis31)
    (else (s3
           (append lis31 (list (sort (take (filter-map (lambda (x) (car x)) (sort  (car lis32) (
                                                                 lambda (m n)
                                                                  (< (car (cdr m)) (car (cdr n))))
                                                              )
                                                       ) K) <)))

           (cdr lis32)
           
           (+ count3 1)
          )
    )
  )
  )
 





(define (i3 a3 l3 co3)
  (cond
    ((null? l3) a3)
    (else (i3 (append a3 (list (append (list co3) (list (car l3))))) (cdr l3) (+ co3 1) )
  )
  )
  )

(define (i32 li co32)
  (cond
    ((> co32 1) (i32 (cdr li) (- co32 1)) )
    (else (car(cdr (car li))))          
    )
  )

(define (sim l1 l2)
   (length (filter (lambda (x) (member x l1)) l2))
   )



(define (s42 lis421 ele lis422 lis423 count42) 
  (cond
    ((> count42 K) lis421)
    (else (s42 (cond
            
                 ((member ele (i32 lis423 (car lis422))) (append lis421 (list (append (list (car lis422) ) (list (sim (i32 lis423 (car lis422)) (i32 lis423 ele)))))))
                  (else lis421)) 

            ele   

            (cdr lis422)
           
           lis423
           
           (+ count42 1)
          )
    )
  ))
  

(define (s41 lis41 lis42 count4)
  (cond
    ((> count4 N) lis41)
    (else (s41
           (append lis41 (list (sort (s42 '() (car (car lis42)) (car (cdr (car lis42))) (i3 '() step3 1) 1)
                               (lambda (m n)
     (> (car (cdr m)) (car (cdr n)))))))

           (cdr lis42)
           
           (+ count4 1)
          )
    )
  )
  )

(define (s51 count51 lis522)
  (cond
    ((null? lis522) count51)
    (else (s51
           (cond
             ((>= (car (cdr (car lis522))) e)(+ count51 1))
             (else count51))

           (cdr lis522)
          )
    )
  )
)

(define (s5 lis51 lis52 count5)
  (cond
    ((> count5 N) lis51)
    (else (s5
           (append lis51 (list (s51 0 (car lis52))))

           (cdr lis52)
           
           (+ count5 1)
          )
    )
  )
)
                                                              
(define (s6 lis61 lis62 count6)
  (cond
    ((> count6 N) lis61)
    (else (s6
           (cond
             ((>= (car lis62) MinPts) (append lis61 (list count6)))
             (else lis61))

           (cdr lis62)

           (+ count6 1)
          )
    )
  )
)

(define (i71 lis711 ele)
  (cond
    ((null? lis711) #f)
    ((equal? ele (car (car lis711))) (cond
                                       ((>= (car(cdr(car lis711))) e) #t)
                                       (else #f)))
    (else
     (i71
      
      (cdr lis711)
      
      ele))
    ))

(define (i7 lisi71 elei71 elei72)
  (cond
    ((equal? elei71 1) (i71 (car lisi71) elei72))
    (else
     (i7
      (cdr lisi71)
      
      (- elei71 1)
      
      elei72))      
    ))
 
(define (checker lische lchek lele)
  (cond
    ((i7 lische lele lchek) (i7 lische lchek lele))
   (else #f))
 )

(define (cluster1 lisclue11 lisclue21 cluel1)
  (cond
    ((null? lisclue21) lisclue11)
    (else (cluster1

           (cond
             ((checker step4 cluel1 (car lisclue21)) (append lisclue11 (list (car lisclue21))))
             (else lisclue11)
             )

           (cdr lisclue21)

           cluel1
          )
    )
  )
)

(define (cluster lisclue1 lisclue2 lisclue3 clue4)
  (cond
    ((null? lisclue3) lisclue1)
    ((null? lisclue2) lisclue1)
    (else
     (
      cluster
      
      (remove-duplicates (append lisclue1 (cluster1 (list clue4) lisclue3 clue4) ))
      
      (cdr (cluster1 (list clue4) lisclue3 clue4))
      
      (remove* (cluster1 (list clue4) lisclue3 clue4) lisclue3)

      (cond
        ((null? (cdr (cluster1 (list clue4) lisclue3 clue4))) '())
      (else (car(cdr (cluster1 (list clue4) lisclue3 clue4))))
      )
     )
    )))

(define (s7 lis71 lis72 count7)
  (cond
    ((null? lis72) lis71)
    (else (s7
           (append lis71  (list (append (list count7) (list (sort (remove-duplicates (cluster (list (car lis72)) (list (car lis72)) (cdr lis72) (car lis72))) <)))))

           (remove* (cluster (list (car lis72)) (list (car lis72))  (cdr lis72) (car lis72)) lis72 )

           (+ count7 1)
          )
    )
  )
)

(define (s8 lis81 lis82 lis83 count8)
  (cond
    ((> count8 N) lis81)
    (else (s8
             (cond
                  ((not (equal? (cond
                                  ((null? lis82) (+ count8 1))
                                  ((null? (car lis82)) (+ count8 1))
                                  (else (car lis82))) count8)) (cond
                                                       ((equal? (car lis83) 0) (append lis81 (list count8)))
                                                       (else lis81)
                                                       ))
                  (else lis81))

           (cond
             ((equal? (cond
                                  ((null? lis82) (+ count8 1))
                                  ((null? (car lis82)) (+ count8 1))
                                  (else (car lis82))) count8) (cdr lis82))
             (else lis82)
             )
           
           (cdr lis83)

           (+ count8 1)
          )
    )
  )
  )

(define (s9 lis91 lis92 lis93 count9)
  (cond
    ((> count9 N) lis91)
    (else (s9

           (cond
                  ((not (equal? (cond
                                  ((null? lis92) (+ count9 1))
                                  (else (car lis92))) count9))
                   (cond
                                                       ((not (equal?
                                                              (cond
                                                              ((null? lis93) (+ count9 1))
                                                              (else (car lis93))
                                                              ) count9)) (append lis91 (list count9)))
                                                       (else lis91)
                                                       ))
                  (else lis91))
           

           (cond
             ((equal? (cond
                                  ((null? lis92) (+ count9 1))
                                  (else (car lis92))
                                  ) count9) (cdr lis92))
             (else lis92)
             )
           
           (cond
             ((equal? (cond
                                  ((null? lis93) (+ count9 1))
                                  (else (car lis93))) count9) (cdr lis93))
             (else lis93)
             )
           
           (+ count9 1)
           ))
    )
  )

(define (max ls c)
  (cond
    ((null? ls) c)
    (else
     (max
      (cdr ls)
      (cond
        ((> (car ls) c) (car ls))
        (else c)
     )))))

(define (i10 lis1011 ele1012 c1 c2 count101)
  (cond
    ((null? lis1011) c2)
    (else
     (i10

      (cdr lis1011)

      ele1012

      (max (map (lambda(x) (sim (i32 (i3 '() step3 1) x) (i32 (i3 '() step3 1) ele1012)))  (car (cdr (car lis1011)))) 0)
      
      (cond
        ((> (max (map (lambda(x) (sim (i32 (i3 '() step3 1) x) (i32 (i3 '() step3 1) ele1012)))  (car (cdr (car lis1011)))) 0) c1) count101)
        (else c2)
 )
  (+ count101 1)
  ))))

(define (i11  pos110 lis110 lis111 ele110 count11)
  (cond
    ((null? lis111) lis110)
    (else
     (i11

      pos110

      (cond
        ((equal? pos110 count11) (append lis110 (list (append (list count11) (list (sort (append (car (cdr (car lis111))) (list ele110)) <))))))
        (else (append lis110 (list (car lis111)))))

      (cdr lis111)

      ele110

      (+ count11 1)

      )
     )
    ))


(define (s10 lis101 lis102 lis103 count10)
  (cond
    ((null? lis103) lis101)
    (else

     (s10

     (i11 (i10 lis102 (car lis103) 0 0 1) '() lis101 (car lis103) 1)

      lis102
      
     (cdr lis103)

     (+ count10 1)
     ))))

(define step1 (s1 '() 1))
;(display step1)
(define step2 (s21 '() step1 1))
(define step3 (s3 '() step2 1))

;(display (sim (i32 (i3 '() step3 1) 8) (i32 (i3 '() step3 1) 1)))
;(display   (i3 '() step3 1))
;(display (sim ))
(define step4 (s41 '() (i3 '() step3 1) 1))
(define step5 (s5 '() step4 1))
(define step6 (s6 '() step5 1))
(define step7 (s7 '() step6 1))
(define step8 (s8 '() step6 step5 1))
(define step9 (s9 '() step6 step8 1))
(define step10 (s10 step7 step7 step9 1))

(provide step1)
(provide step2)
(provide step3)
(provide step4)
(provide step5)
(provide step6)
(provide step7)
(provide step8)
(provide step9)
(provide step10)



