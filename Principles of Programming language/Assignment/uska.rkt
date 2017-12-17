#lang racket

(define N (read))

(define D (read))

(define K (read))

(define e (read))

(define Min (read))

(define (inpd x)
	(if (= x 0)
		'()
		(cons (read) (inpd (- x 1)))
		)
	)

(define (inpn y)
	(if(= y 0)
		'()
		(cons (cons (- (+ N 1) y) (list (inpd D))) (inpn(- y 1)))
		)
	)

(define step1 (inpn N))


(define (datapoint z li)

	(if(= z 1)
		(car li)
		(datapoint (- z 1) (cdr li))
		)
 )

(define (dist li1 li2)
	(if(null? li1)
		0
		(+ (expt (- (car li2) (car li1)) 2) (dist (cdr li1) (cdr li2))) 
		)

	)

(define (matri j k)
	(if(= k (+ N 1))
		'()
		(if(= j k) (cons (list j +inf.0)  (matri j (+ k 1))) (cons (list k (sqrt (dist (car (cdr (datapoint j step1))) (car (cdr (datapoint k step1))))))  (matri j (+ k 1))) )
		)
	)

(define (step2last k)
	(if(= k (+ N 1))
		'()
		(cons (matri k 1) (step2last (+ k 1)))
		)
	)


(define step2 (step2last 1))

(define (selmat i li)
	(if(= i 1)
		(car li)
		(selmat (- i 1) (cdr li))
	)
	)

(define (crlist k)
	(if(= k 0)
	'()
	(cons (- (+ K 1) k) (crlist (- k 1)))
	)
	)

(define (ssort li)
	(if(null? (cdr li))
		li
		(if(< (car (cdr (car li))) (car (cdr (car (cdr li)))))
			(cons (car li) (ssort (cdr li)))
			(cons (car (cdr li)) (ssort (cons (car li)(cdr (cdr li)))))
			)
	)
	)
(define (ssortl N li)
	(cond ((= N 1) (ssort li))
		(else (ssortl (- N 1) (ssort li)))
	)
	)

(define (ssortlast li) (ssortl (length li) li))

(define (nsort li)
	(if(null? (cdr li))
		li
		(if(< (car li) (car (cdr li)))
			(cons (car li) (nsort (cdr li)))
			(cons (car (cdr li)) (nsort (cons (car li)(cdr (cdr li)))))
			)
	)
	)
(define (nsortl N li)
	(cond ((= N 1) (nsort li))
		(else (nsortl (- N 1) (nsort li)))
	)
	)

(define (nsortlast li) (nsortl (length li) li))

(define (takeo x li)
	(if(= x (+ K 1))
	'()
	(cons (car li) (takeo (+ x 1) (cdr li)))
	)
	)

(define (knn li x)
	(if(= x (+ K 1))
		'()
		(cons (car (car li)) (knn (cdr li) (+ x 1)))
	
	)
	)
(define (knnstep3 x)
	(if(= x (+ N 1))
		'()
		(cons (nsortl K (knn (takeo 1 (ssortl N (selmat x step2))) 1)) (knnstep3 (+ x 1)))
	)
	)

(define step3  (knnstep3 1))

(define (cmp nu li)
	(if(null? li)
		0
		(if(= nu (car li))
			1
			(cmp nu (cdr li))
			)
	)
	)

(define (cmpl li1 li2)
	(if(null? li1)
	0
	(+ (cmp (car li1) li2) (cmpl (cdr li1) li2))
	)
	)


(define (den x li)
	 (if(null? li)
		0
		(+ (cmp x (car li)) (den x (cdr li)))
		)
	)

(define (sng li li2 li1 x)
	(if(null? li1)
		'()
		(if(= (cmp x (selmat (car li1) li)) 1)
		(cons (cons (car li1) (list (cmpl (selmat (car li1) li) li2))) (sng li li2 (cdr li1) x))
		(sng li li2 (cdr li1) x)
	)
	)
	)

(define (rev li)
	(if(null? li)
	'()
	(append (rev (cdr li)) (list (car li)))
	)
	)


(define (sngsort li)
	(if(null? (cdr li))
		li
		(if(= (car (cdr (car li))) (car (cdr (car (cdr li)))))
			(if(< (car (car li)) (car (car (cdr li))))
				(cons (car li) (sngsort (cdr li)))
				(cons (car (cdr li)) (sngsort (cons (car li)(cdr (cdr li)))))
				)
			(cons (car li) (sngsort (cdr li)))
			)
	)
	)
(define (sngsortl N li)
	(cond ((= N 1) (sngsort li))
		(else (sngsortl (- N 1) (sngsort li)))
	)
	)

(define (sngsortlast li) (sngsortl (length li) li))


(define (step4final x li)
	(if(= x (+ N 1))
	'()
	(cons (sngsortlast (rev (ssortlast (sng li (selmat x li) (selmat x li) x)))) (step4final (+ x 1) li))
	)
	)

(define step4 (step4final 1 step3))

(define (pdens li v)
	(if(null? li)
		0
		(if(>= (car (cdr (car li))) v)
			(+ 1 (pdens (cdr li) v))
			(pdens (cdr li) v)
			)
	)
	)

(define (step5final li v x)
	(if(= x (+ N 1))
		'()
		(cons (pdens (selmat x li) v) (step5final li v (+ x 1)))
		)
	)

(define step5 (step5final step4 e 1))

(define (step6final li x m)
	(if(= x (+ N 1))
		'()
		(if(>= (car li) m)
			(cons x (step6final (cdr li) (+ x 1) m))
			(step6final (cdr li) (+ x 1) m)
		)
	)
	)

(define step6 (step6final step5 1 Min))

(define (step8final li x)
	(if(= x (+ N 1))
		'()
		(if(= (car li) 0)
			(cons x (step8final (cdr li) (+ x 1)))
			(step8final (cdr li) (+ x 1))
		)
	)
	)

(define step8 (step8final step5 1))


(define (step9final li x m)
	(if(= x (+ N 1))
		'()
		(if(and (< (car li) m) (not (= (car li) 0)))
			(cons x (step9final (cdr li) (+ x 1) m))
			(step9final (cdr li) (+ x 1) m)
		)
	)
	)

(define step9 (step9final step5 1 Min))

(define (spcore li1 li2)
	(if(null? li2)
		'()
		(if(= (cmp (car li2) li1) 1)
			(cons (car li2) (spcore li1 (cdr li2)))
			(spcore li1 (cdr li2))
			)
		)
	)

(define (spstep li1 li2 x)
	(if(= x (+ N 1))
		'()
		(cons (spcore li1 (selmat x li2)) (spstep li1 li2 (+ x 1)))
		)
	)

(define (nccat li1 li2)
	(if(null? li2)
		li1
		(if(= (cmp (car li2) li1) 1)
			(nccat li1 (cdr li2))
			(cons (car li2) (nccat li1 (cdr li2))) 
			)
		)
	)

(define (nsame li1 li2)
	(if(null? li2)
		'()
		(if(= (cmp (car li2) li1) 1)
			(nsame li1 (cdr li2))
			(cons (car li2) (nsame li1 (cdr li2))) 
			)
		)
	)

(define (linccat li1 li2)
	(if(null? (cdr li2))
		'()
		(nccat (nccat (selmat (car li2) li1) (selmat (car (cdr li2)) li1)) (linccat li1 (cdr li2)))
		)
	)

(define (xccat li1 li2 li23)
	(if(null? li2)
		'()
	(nccat (linccat li1 li23) (xccat li1 (nsame li2 (linccat li1 li2)) li23))
	)
	)

(define (rmv li1 x)
	(if(null? li1)
		'()
		(if(= (car li1) x)
			(rmv (cdr li1) x)
			(cons (car li1) (rmv (cdr li1) x))
	)
	)
	)

(define (rmvli li1 li2)
	(if(null? li2)
		(rmv li1 +inf.0)
		(rmvli (rmv li1 (car li2)) (cdr li2)) 
		)
	)



(define (step7final li1 li2 li4 x y)
	(if(null? li4)
	'()
	(if (or (= (cmp (car li4) (xccat li1 (selmat (car li2) li1) (selmat (car li2) li1))) 0) (= y 0))
		(cons (cons x (list (nsort (xccat li1 (selmat (car li2) li1) (selmat (car li2) li1))))) (step7final li1 (rmvli step6 (nsort (xccat step7in (selmat (car step6) step7in) (selmat (car step6) step7in)))) (rmvli step6 (nsort (xccat step7in (selmat (car step6) step7in) (selmat (car step6) step7in)))) (+ x 1) 0))
		(step7final li1 li2 (cdr li4) x 1)
		)
	)
	)

(define step7in (spstep step6 step3 1))


;(define pr (nsortlast (nccat (selmat 1 step7in) (selmat 5 step7in))))

;(define pr (linccat step7in (selmat 3 step7in)))

;(define pr (nsort (xccat step7in (selmat 1 step7in) (selmat 1 step7in))))

(define pr (step7final step7in step6 step6 1 0))

(display pr)

;(define pr (rmvli step6 (nsort (xccat step7in (selmat (car step6) step7in) (selmat (car step6) step7in)))));(nsort (xccat step7in (selmat (car step6) step7in) (selmat (car step6) step7in)))) ;(rmvli step6 )

;(display pr)

;'(1 5 8 12 14)
