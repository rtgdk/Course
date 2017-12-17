#lang racket
(provide (all-defined-out))
(define inputFile (vector-ref (current-command-line-arguments) 0))

;; Author - Rishabh Joshi

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Step 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(define inputFile "chutiyapa.txt")
(define wordlist (file->list inputFile))
(define step1 wordlist)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Step 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (initCluster wordlist nu)
  (if (null? wordlist)
      '()
      (cons
       (list nu (list (car wordlist)) '())
        (initCluster (cdr wordlist) (+ 1 nu))
      )
  )
)
(define step2 (initCluster wordlist 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Step 3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Word to word distance returns a number
(define (WtoWdistance aa bb)
 (-
  1
  (/
   (set-count (set-intersect (list->set (string->list (string-downcase (symbol->string aa)))) (list->set (string->list (string-downcase (symbol->string bb))))))
   (set-count (set-union     (list->set (string->list (string-downcase (symbol->string aa)))) (list->set (string->list (string-downcase (symbol->string bb))))))
  )
 )
)

;; distance b/w one word and another word list : (is) vs (to the him) returns dList
; Optimized using accumulator
(define (distWordxList xword ylist acc)
  (cond
    ;((null? ylist) '())
    ;(else
    ; (cons
    ;  (WtoWdistance xword (car ylist))
    ;  (distWordxList xword (cdr ylist) '())
    ; )
    ;)
    ((null? ylist) acc)
    (else
     (append (distWordxList xword (cdr ylist) (list (WtoWdistance xword (car ylist)))) acc)
    )
  )
)
;; distance b/w xlist and ylist, each word of xlist is passed in above function
; Optimized using accumulator
(define (distWordList xlist ylist acc)
  (cond
    ;((null? xlist) '())
    ;((null? ylist) '())
    ;(else
    ; (append
    ;  (distWordxList (car xlist) ylist '())
    ;  (distWordList (cdr xlist) ylist )
    ; )
    ;)
    ((null? xlist) acc)
    ((null? ylist) acc)
    (else
     (append (distWordList (cdr xlist) ylist (distWordxList (car xlist) ylist '())) acc)
    )
  )
)
;(distWordList '(abcabc abc) '(bde ca) )

;; Returns min value from a list
; Optimized to remove exponential dependency
;(define (minvallist lst)
;    (cond ((null? (cdr lst)) (car lst))
;          ((< (car lst) (minvallist (cdr lst))) (car lst))
;          (else (minvallist (cdr lst)))) )
(define (minvallist lst)
    (cond ((null? (cdr lst)) (car lst))
          (else
           (define minvallistleft (minvallist (cdr lst)))
           (if (< (car lst) minvallistleft) (car lst) minvallistleft))))


;; distance b/w cluster each pair of word in cluster a and cluster b
(define (CtoCdistance a b)
  (cond
   ((eq? (car a) (car b)) 100)  ;car a is ID of a
   (else (minvallist (distWordList (cadr a) (cadr b) '())))
  )
)

;(CtoCdistance '(1 ("abcabc" "abc") ()) '(2 ("bde" "ca") ()))

;; Distance b/w each cluster with each other
; Optimize using accumulator
(define (pairWiseClusterdist clist1 clist2 acc)
  (cond
   ;((null? clist1) '())
   ;((null? clist2) '())
   ;(else
   ; (define id1 (caar clist1))
   ; (define word1 (cadar clist1))
   ; (cons (list id1 word1 (oneClusterListdist (car clist1) clist2)) (pairWiseClusterdist (cdr clist1) clist2 '()))
   ;)
    ((null? clist1) acc)
    ((null? clist2) acc)
    (else
     (append acc (pairWiseClusterdist (cdr clist1) clist2 (list (list (caar clist1) (cadar clist1) (oneClusterListdist (car clist1) clist2 '()) ))) )
    )
  )
)

;; Distance of one cluster with a list of clusters
; Optimize using accumulator
(define (oneClusterListdist c clist acc)
  (cond
    ;((null? clist) '())
    ;(else
    ; (define dist (CtoCdistance c (car clist)))
    ; (define id2 (caar clist))
    ; (cons (list id2 dist) (oneClusterListdist c (cdr clist)))
    ;)
    ((null? clist) acc)
    (else
     (append acc (oneClusterListdist c (cdr clist) (list (list (caar clist) (CtoCdistance c (car clist))))) )
    )
  )
)

(define step3 (pairWiseClusterdist step2 step2 '()))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; STEP 4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; The gaandfaadu function
; This is so gaand faadu that I cant optimize in one lifetime
(define (bigloop clist newcid)
  (cond
    ((< (length clist) 9) clist)
    (else
     (define minclusterstoeachlist (findminclusters clist '()))   ; ( (1 (1 dist)) (1 (2 dist)) (1 (3 dist)) )
     (define globalminclusters (globalminc minclusterstoeachlist))  ; (1 (3 dist))
     (define id1 (car globalminclusters))
     (define id2 (caadr globalminclusters))
     (define newcluster (createnewcluster id1 id2 newcid clist))  ; return a new cluster of the form (newcid (wlist1 wlist2) (newdist))
     (define cleanedclist (cleanlist id1 id2 clist))
     (define updatedclist (updateclist cleanedclist newcid (caddr newcluster)))
     (define finalappendedclist (append updatedclist (list newcluster)))
     (bigloop finalappendedclist (+ 1 newcid))
    )
  )
)

; Function takes the clist and returns a list of clusterids and min clusters to them each.
; Optimized by putting accumulator
(define (findminclusters clist acc)
  (cond
    ((null? clist) acc)
    (else
     ;(define c1 (car clist))
     ;(define idc1 (car c1))
     ;(define distlistc1 (caddr c1))
     ;(cons (list idc1 (mindistone distlistc1)) (findminclusters (cdr clist))) ;car c1 is id of c1
     (append acc (findminclusters (cdr clist) (list (list (caar clist) (mindistone (caddr (car clist)) '())))) ) ;car c1 is id of c1
    )
  )
)

; Takes a ((id dist) (id dist)) definition and returns (id dist) such that dist is min
; Optimized by removing the exponential dependency
(define (mindistone distlist acc)
  (cond
    ;((null? (cdr distlist)) (car distlist))  ;only one element return it
    ;((<= (cadar distlist) (cadr (mindistone (cdr distlist)))) (car distlist))   ;cdar dislist gives dist of 1st node
    ;(else (mindistone (cdr distlist)))
    ((null? (cdr distlist)) (car distlist))
    (else
     (define minleft (mindistone (cdr distlist) '()))
     (if (<= (cadar distlist) (cadr minleft)) (car distlist) minleft)
    )
  )
)

; returns a global min cluster choice and the  distance between them.
; Optimized to remove exponential nature
(define (globalminc minclist)  ;returns of the form (1 (2 dist))
  (cond
    ((null? (cdr minclist)) (car minclist))
    (else
     (define mincfromleft (globalminc (cdr minclist)))
     (if (<= (car (cdadar minclist)) (cadadr mincfromleft))
         (car minclist)
         mincfromleft
     )
    )
  )
)

; Creates new cluster by combining clusters with id1 and id2 into a cluster of newid
; Too fu*kin' complex to optimize shit
(define (createnewcluster id1 id2 newcid clist)
  (define ca (getcluster id1 clist))
  (define cb (getcluster id2 clist))
;  (define newwordlist (set->list (set-union (list->set (cadr ca)) (list->set (cadr cb)))))
  (define newwordlist (append (cadr ca) (cadr cb)))
  (define sortedwordlist (sort newwordlist comparator))
  (define newdistlist (getnewdistlist (caddr ca) (caddr cb)))
  (list newcid sortedwordlist (append (cleandistlist id1 id2 newdistlist) (list (list newcid 100))))
)

; Givent the distance lists it merges the distance lists by taking the min at every step, for each id, among the two
(define (getnewdistlist distl1 distl2)
  (cond
    ((null? distl1) '())
    (else
     (define id (caar distl1))
     (define d1 (cadar distl1))
     (define d2 (cadar distl2))
     (if (<= d1 d2)
         (cons (list id d1) (getnewdistlist (cdr distl1) (cdr distl2)))
         (cons (list id d2) (getnewdistlist (cdr distl1) (cdr distl2))))
    )
  )
)

(define (comparator a b)
  (cond
    ((string<? (string-downcase (symbol->string a)) (string-downcase (symbol->string b))) #t)
    (else #f)
  )
)

; Returns the cluster with id given
(define (getcluster id clist)
  (cond
    ((null? clist) '())
    ((= (caar clist) id) (car clist))
    (else (getcluster id (cdr clist)))
  )
)


;; cleanlist takes two ids and removes clusters with those ids and removes the distances of these from all others
(define (cleanlist remid1 remid2 clist)
  (cond
    ((null? clist) '())
    ((= (caar clist) remid1) (cleanlist remid1 remid2 (cdr clist)))
    ((= (caar clist) remid2) (cleanlist remid1 remid2 (cdr clist)))
    (else
     ;(define id (caar clist))
      ;(define wlist (cadar clist))
      ;(define newdistlist (cleandistlist remid1 remid2 (caddar clist) newdistl))
      ;(cons (list id wlist newdistlist) (cleanlist remid1 remid2 (cdr clist) newlist))
      (cons (list (caar clist) (cadar clist) (cleandistlist remid1 remid2 (caddar clist))) (cleanlist remid1 remid2 (cdr clist)))
     
    )
  )
)
      

; This funtion takes a dist list of a cluster and removes distances of remid clusters and returns a new cleaned distlist
(define (cleandistlist remid1 remid2 distlist)
  (cond
    ((null? distlist) '())
    ((= (caar distlist) remid1) (cleandistlist remid1 remid2 (cdr distlist)))
    ((= (caar distlist) remid2) (cleandistlist remid1 remid2 (cdr distlist)))
    (else
     (cons (car distlist) (cleandistlist remid1 remid2 (cdr distlist)))
    )
  )
)


; This function takes the new clist and the newcid and the dlist of the new cluster. It then takes the distances from the newcdlist and then
; appends them to the dlist of the clusters. The function returns the updated cluster list
(define (updateclist clist newcid newcdlist)
  (cond
    ((null? clist) '())
    (else
     (define id (caar clist))
     (define wordlist (cadar clist))
     (define updateddistlist (append (caddar clist) (list (list newcid (cadar newcdlist)))))
     (cons (list id wordlist updateddistlist) (updateclist (cdr clist) newcid (cdr newcdlist)))
    )
  )
)


; the next comment is a cluster list for step 3 temp  
;; ((1 (is) ((1 100) (2 1) (3 1) (4 1))) (2 (am) ((1 1) (2 100) (3 3/4) (4 1))) (3 (are) ((1 1) (2 3/4) (3 100) (4 4/5))) (4 (the) ((1 1) (2 1) (3 4/5) (4 100))))


; Test the bull shit but beautiful language
(define step4 (bigloop step3 (+ 1 (length step3))))



;(define (finalprint clist)
;  (cond
;    ((null? clist) (display ""))
;    (else (displayln (car clist)) (finalprint (cdr clist)))
;  )
;)

(define (converttostring any) 
  (with-output-to-string (lambda () (write any))))

(define (finalprint clist acc)
  (cond
    ((null? clist) acc)
    ;(else (displayln (car clist)) (finalprint (cdr clist)))
;    (else (string-append acc (finalprint (cdr clist) (string-append (converttostring (cadar clist)) "\n")))) convert to list remove last ele convert back to str
    (else (string-append 
            acc 
            (finalprint 
              (cdr clist) 
              (string-append 
                (list->string (removewhitespace (string->list (getlist (cadar clist) '"")) '())) 
                "\n"
              )
            )
          )
    )
  )
)

(define (getlist wlist acc)
  (cond
    ((null? wlist) acc)
    (else (string-append acc (getlist (cdr wlist) (string-append (converttostring (car wlist)) " "))))
  )
)

; Takes a list of characters and returns a list without the last element
(define (removewhitespace str acc)
  (cond 
    ((null? (cdr str)) acc)
    (else (append acc (removewhitespace (cdr str) (list (car str)))))
  )
)


;(define (print arr)
;  (display (finalprint arr '""))
;)

(define step5 (finalprint step4 '""))
;(display step5)
