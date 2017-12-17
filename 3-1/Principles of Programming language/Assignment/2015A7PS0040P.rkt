#lang racket
(provide (all-defined-out))
(define inputFile (vector-ref (current-command-line-arguments) 0))
(define myfileline (file->lines inputFile))
(define N (car (map string->number (string-split (list-ref myfileline 0)))))
(define D (list-ref (map string->number (string-split (list-ref myfileline 0))) 1))
(define K (list-ref (map string->number (string-split (list-ref myfileline 0))) 2))
(define e (list-ref (map string->number (string-split (list-ref myfileline 0))) 3))
(define MinPts (list-ref (map string->number (string-split (list-ref myfileline 0))) 4))

;Step-1
;Read input and make datapoints
(define (readrow i line) ; read ith row
	(cond
          ((= i 0)
		'())
		(else(cons (list-ref line (- D i)) (readrow (- i 1) line)))
		)
	)

(define (readMat j)   ; read and form matrix of datapoints
	(cond
          ((= j 0)
		'())
		(else(cons (cons (- (+ N 1) j) (list (readrow D (map string->number (string-split (list-ref myfileline (- (+ N 1) j))))))) (readMat(- j 1))))
		)
	)

(define step1 (readMat N ))

;Step-2
;Make Similarity matrix
(define (getDatapoint row ls)  ;returns (row-1)(th) index of ls (0-indexed list)
  (if (= row 1)
      (car ls)
      (getDatapoint (- row 1) (cdr ls))
      )
  )

(define (distance ls1 ls2)   ; returns square of euclidean distance b/w 2 points 
  (if (or (null? ls1) (null? ls2))
      0
      (+ (expt (- (car ls1) (car ls2)) 2)
         (distance ( cdr ls1 ) (cdr ls2))
         )
      )
  )

(define (simMatrixrow i j)     ; fills ith row of similarity matrix
  (cond
    ((= j (+ N 1)) '())
    ((= i j) (cons (list i +inf.0) (simMatrixrow i (+ j 1))))
    (else (cons (list j (sqrt (distance (car (cdr (getDatapoint i step1))) (car (cdr (getDatapoint j step1)))))) (simMatrixrow i (+ j 1))))  ; not car
    )
  )

(define (simMatrix i)      ;creates similarity matrix recursively
  (if (= i (+ N 1))
      '()
      (cons (simMatrixrow i 1) (simMatrix (+ i 1)))
      )
  )

(define mstep2 (simMatrix 1))
;Set precision
(define precision '6)

(define (mysetprecision n p)
  (if (= n +inf.0) +inf.0
      (string->number (~r n #:precision p))
  )
) 

(define (precision_util lst)
  (if (null? lst) '()
      (cons (list (car(car lst)) (mysetprecision (car(cdr(car lst))) precision))  (precision_util (cdr lst))))
)

(define (modify_precision lst)
  (if (null? lst) '()
  (cons (precision_util (car lst)) (modify_precision (cdr lst))))
)

(define step2 (modify_precision mstep2)) 

;Step-3
;Make KNN matrix
(define (sortMatrix pred mat i key)      ;creates ascedning sort matrix recursively (0-indexed)
  (if (= i N)
      '()
      (cons (sort (list-ref mat i) pred #:key key) (sortMatrix pred mat (+ i 1) key))
      )
  )

(define (KNN sortedMat i k)           ; get first k element from the matrix
  (if (= i N)
      '()
      (cons (take (list-ref sortedMat i) k) (KNN sortedMat (+ i 1) k))
      )
  )

(define (SortKNNrowindex ls i k)      ; get the first element (index) from the list ls
  (if (= i k)
      '()
      (cons (car (car ls)) (SortKNNrowindex (cdr ls) (+ i 1) k))
      )
  )
(define (getsortKNNindex mat i k)      ;get the first element from the matrix of list of list
  (if (= i N)
      '()
      (cons (SortKNNrowindex (list-ref mat i) 0 k) (getsortKNNindex mat (+ i 1) k))
      )
  )
  
(define step3 (getsortKNNindex (sortMatrix < (KNN (sortMatrix < step2 0 cadr) 0 K) 0 car) 0 K))

;Step-4
;Make Shared Neighbour graph
(define (weight ls1 ls2)   ;similarity
  (length (filter (lambda (x) (member x ls1)) ls2))
  )

(define (edge mat ls ls1 i)    ;edges for (i-1)th row
  (cond
    ((null? ls) '())
    ((member i (list-ref mat (- (car ls) 1))) (cons (cons (car ls) (list (weight ls1 (list-ref mat (- (car ls) 1))))) (edge mat (cdr ls) ls1 i)))
    (else (edge mat (cdr ls) ls1 i))
    )
  )

(define (graph mat i)       ; create graph
  (if (= i N)
      '()
      (cons (edge mat (list-ref mat i) (list-ref mat i) (+ i 1)) (graph mat (+ i 1)))
      )
  )

(define step4 (sortMatrix > (graph step3 0) 0 cadr))

;Step-5
;Output point density
(define (density ls1)   ;density
  (length (filter (lambda (x) (>= (car(cdr x)) e)) ls1))
  )

(define (graphdensity mat i)     ;create density of matrix
  (if (= i N)
      '()
      (cons (density (list-ref mat i)) (graphdensity mat (+ i 1)))
      )
  )

(define step5 (graphdensity step4 0))

;Step-6
;Output core points
(define (corepoints ls i)      ;get corepoints from list ls
  (cond
    ((null? ls) '())
    ((>= (car ls) MinPts) (cons i (corepoints (cdr ls) (+ i 1))))
    (else (corepoints (cdr ls) (+ i 1)))
    )
  )
(define step6 (corepoints step5 1))

;Step-7
;Do clustering
(define (checkCoreEdge ls elem)    ;checks whether element elem in the list ls and if exist weight>e
  (cond
    ((null? ls) #f)
    ((equal? elem (car (car ls))) (if (>= (cadar ls) e) #t #f))
    (else (checkCoreEdge (cdr ls) elem))
    )
  )

(define (checkKth mat k elem)       ;checks if elem exist in kth list of mat(1-indexed) by passing it to checkCoreEdge
  (if (equal? k 1) (checkCoreEdge (car mat) elem) (checkKth (cdr mat) (- k 1) elem)     
    )
  )
 
(define (sameCluster mat i j)      ; checks i and j belong to same cluster
  (if (checkKth mat j i) (checkKth mat i j) #f)
  )

(define (getMarklist marklist ls k)  ; check k and elements of list ls  if belong to same cluster append element of list to marklist and finally return marklist
  (if (null? ls) marklist
    (getMarklist (if (sameCluster step4 k (car ls)) (append marklist (list (car ls)))
                  marklist) (cdr ls) k)
    )
  )

(define (Cluster newlist ls1 ls2 marklist)     ; remove duplicates while adding to clusters
  (if (or (null? ls2) (null? ls1)) newlist
    (Cluster (remove-duplicates (append newlist (getMarklist (list marklist) ls2 marklist) )) (cdr (getMarklist (list marklist) ls2 marklist))
      (remove* (getMarklist (list marklist) ls2 marklist) ls2) (if (null? (cdr (getMarklist (list marklist) ls2 marklist))) '()
                                                                 (car(cdr (getMarklist (list marklist) ls2 marklist)))
                                                                 )
      )
    )
  )

(define (createCluster clust corelist nc)    ;nc is the no of the cluster -- creaates clusters from the elements in the core list
  (if (null? corelist) clust
    (createCluster (append clust (list (append (list nc) (list (sort (remove-duplicates (Cluster (list (car corelist)) (list (car corelist)) (cdr corelist) (car corelist))) <)))))
           (remove* (Cluster (list (car corelist)) (list (car corelist))  (cdr corelist) (car corelist)) corelist ) (+ nc 1)
           )
    )
  )
(define step7 (createCluster '() step6 1))

;Step-8
;Output noise points
(define (noisepoints ls i)    ; get noisepoints 
  (cond
    ((null? ls) '())
    (( member i step6) (noisepoints (cdr ls) (+ i 1)))
    (else (cond
            ((> (length (filter (lambda (x) (>= (car (cdr x)) e)) (list-ref step4 (- i 1)))) 0) (noisepoints (cdr ls) (+ i 1)))
            (else (cons i (noisepoints (cdr ls) (+ i 1))))
            )
          )
    )
  )

(define step8 (noisepoints step5 1))

;Step-9
;Output borderpoint points
(define (borderpoint i ls1 ls2)    ; get borderpoint
  (cond
    ((= i (+ N 1)) '())
    ((member i ls1) (borderpoint (+ i 1) ls1 ls2))
    ((member i ls2) (borderpoint (+ i 1) ls1 ls2))
    (else (cons i (borderpoint (+ i 1) ls1 ls2)))
    )
  )

(define step9 (borderpoint 1 step6 step8))

;Step-10
;Do final clustering of remaining border points
(define (maximum ls c)  ; find maximum in list
  (if (null? ls) c (maximum (cdr ls) (if (> (car ls) c) (car ls) c))
      )
  )
(define (getcadar ls i)  ; get cadar in from ith in ls
  (if (> i 1) (getcadar (cdr ls) (- i 1)) (cadar ls)          
    )
  )
(define (appendindex newls ls i) ; append index i to the elements of the list
  (if (null? ls) newls (appendindex (append newls (list (append (list i) (list (car ls))))) (cdr ls) (+ i 1) )
      )
  )
(define (appendintocluster ls elem newmx mx k)  ;finds the maximum distance append into cluster and create new cluter
  (if (null? ls) mx (appendintocluster (cdr ls) elem (maximum (map (lambda(x) (weight (getcadar (appendindex '() step3 1) x) (getcadar (appendindex '() step3 1) elem)))  (car (cdr (car ls)))) 0)
      (if (> (maximum (map (lambda(x) (weight (getcadar (appendindex '() step3 1) x) (getcadar (appendindex '() step3 1) elem)))  (cadar ls)) 0) newmx) k mx)
      (+ k 1))
      )
  )

(define (newCluster  mx ls1 ls2 elem k)     ; update cluster
  (if (null? ls2) ls1 (newCluster mx (if (equal? mx k)
                                            (append ls1 (list (append (list k) (list (sort (append (cadar ls2) (list elem)) <)))))
                                            (append ls1 (list (car ls2)))
                                            )
                                 (cdr ls2) elem (+ k 1)
                                 )
      )
  )


(define (createNewCluster ls1 ls2 ls3 count10)   ; create new cluster from ls2 and update into ls1
  (if (null? ls3) ls1 (createNewCluster (newCluster (appendintocluster ls2 (car ls3) 0 0 1) '() ls1 (car ls3) 1)
                                              ls2 (cdr ls3) (+ count10 1)
                                              )
      )
  )

(define step10 (createNewCluster step7 step7 step9 1))