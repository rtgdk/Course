#lang racket


(define inputFile "chutiyapa.txt")
(define wordlist (file->list inputFile))
(define step1 wordlist)

;(define (cluster count words)
; (cond
;    ((null? words) '())
;    (else (cons (list count (list (car words)) '()) (cluster (+ count 1) (cdr words))))
;  )
;)

;(define step2 (cluster 1 wordlist))

(define (cluster count words acc)
  (cond
    ((null? words) (reverse acc))
    (else(cluster (+ count 1) (cdr words) (cons (list count (list (car words)) '()) acc)))
  )
)

(define step2 (cluster 1 wordlist '()))

(define (WtoWdistance worda wordb)
  (define seta (list->set (string->list (string-upcase (symbol->string worda)))))
  (define setb (list->set (string->list (string-upcase (symbol->string wordb)))))
  (- 1 (/ (set-count(set-intersect seta setb)) (set-count(set-union seta setb))))
)

(define (min listm)
  (cond
    ((null? listm) '())
    ((= (length listm) 1) (car listm))
    ((< (car listm) (min (cdr listm)))(car listm))
    (else (min (cdr listm)))
  )
)


(define (CtoCdistance clusta clustb)
  (define lista (cadr clusta))
  (define listb (cadr clustb))
  (cond
    ((= (car clusta) (car clustb)) '100)
    (else(min(func1 lista listb)))  ;extracts the word list in cluster and sends both to func1
  )
)


(define (func1 lista listb)
  (cond
    ((null? lista) '())
    (else (append (list (min(func2 (car lista) listb))) (func1 (cdr lista) listb)))
  )
);func2 is called which returns a list of distances of a word with all the words of a list

(define (func2 word listb)
  (cond
    ((null? listb) '())
    (else(append(list(WtoWdistance word (car listb)))(func2 word (cdr listb))))
  )
)

(define (somefunc lista listb)
  (cond
    ((null? lista) '())
    (else (cons (list (car (car lista)) (cadr (car lista)) (someotherfunc (car lista) listb))(somefunc (cdr lista) listb)))
  )
)
;someotherfunc is expected to return ((1 100)(2 1/3)(3 2/4))
(define (someotherfunc word listb) ;word is of the form (1 (is) ()) and list is form ( (1 (is) ()) (2 (the) ()) (3 (hi) ()) )
  (cond
    ((null? listb) '())
    (else(cons (list (car (car listb)) (CtoCdistance word (car listb)))(someotherfunc word (cdr listb))))
  )
)

(define step3 (somefunc step2 step2))

(define (baharwalaloop biglist nextid) ;should return list of 8 clusters
  (cond
    ((> (length biglist) 8) (baharwalaloop (aagebadho biglist (+ 1 nextid)) (+ 1 nextid)))
    (else biglist)
  )
)

(define uniqid (length step2))

;biglist has n clusters
(define (aagebadho biglist nextid) ;should return new cluster list with n-1 clusters
  (define twoclusters (minclust (minidistclust biglist '())));find min clusters
  (define ida (car twoclusters))
  (define idb (cadr twoclusters))
  (define newclust (createclust ida idb nextid biglist))
  (define cleanedlist (cleanclust ida idb biglist))
  (define updatedlist (update (cadr (cdr newclust)) cleanedlist nextid))
  (append updatedlist (list newclust))
)


(define (update newdistlist cleanedlist nextid) ;newclustlist distlist of new formed cluster, cleaned list is list of cleaned clusters
  (cond
    ((null? cleanedlist) '())
    (else (append (list(list
                   (caar cleanedlist) ;id of cluster
                   (cadar cleanedlist) ;words of cluster
                   (append ;updated distlist of func
                    (caddar cleanedlist)
                    (list(cons nextid (cdar newdistlist)))
                   )
                  ))
                  (update (cdr newdistlist) (cdr cleanedlist) nextid)
          )
     )
  )
)

(define (cleanclust ida idb biglist)
  (cond
    ((null? biglist) '())
    ((= ida (car (car biglist))) (cleanclust ida idb (cdr biglist)))
    ((= idb (car (car biglist))) (cleanclust ida idb (cdr biglist)))
    (else (append (list(cleaned (car biglist) ida idb))(cleanclust ida idb (cdr biglist))))
  )
)

(define (cleaned clust ida idb) ;should return the cluster with distlist cleaned and takes in one cluster
  (define distlist (cadr (cdr clust)))
  (define cleanedlist (cleanit distlist ida idb))
  (list (car clust) (car (cdr clust)) cleanedlist)
)

(define (cleanit distlist ida idb) ;returns cleaned distance list by removing distances from ida idb
  (cond
    ((null? distlist) '())
    ((= ida (car (car distlist))) (cleanit (cdr distlist) ida idb))
    ((= idb (car (car distlist))) (cleanit (cdr distlist) ida idb))
    (else (append (list(car distlist))(cleanit (cdr distlist) ida idb)))
  )
)

(define (createclust ida idb nextid biglist) ;returns new cluster with distances from ida idb removed and self distance added
  (define clusta (getclust ida biglist))
  (define clustb (getclust idb biglist))
  (define worda (cadr clusta))
  (define wordb (cadr clustb))
  (define listofwords (set->list(set-union (list->set worda) (list->set wordb))))
  (define sortedwords (sort listofwords comparator))
  (define distlist (getdistances (cadr (cdr clusta)) (cadr (cdr clustb)) '()))
  (list nextid sortedwords (append (cleanit distlist ida idb) (list(list nextid 100))))
)


(define (getdistances dista distb acc) ;takes ((1 100)(2 1/2)(3 1/3)) ((1 1/2)(2 100)(3 2/3)) and returns ((1 1/2)(2 1/2)(3 1/3))
  (cond
    ((null? dista) acc)
    (else(getdistances (cdr dista) (cdr distb) (append acc (list (list (caar dista) (if(< (cadar dista) (cadar distb)) (cadar dista) (cadar distb)))))))
  )
)

 
(define (comparator a b)
  (cond
    ((string<? (string-upcase (symbol->string a)) (string-upcase (symbol->string b))) #t)
    (else #f)
  )
)

(define (getclust ida biglist) ;returns required cluster from biglist
  (cond
    ((null? biglist) '())
    ((= ida (car (car biglist))) (car biglist))
    (else (getclust ida (cdr biglist)))
  )
)

 
;minclust returns (1 3 1/3) the minimum distance clusters and distance
(define (minclust listm) ;listm is -> '( (1 1 100)(1 2 1/2)(1 3 1/3)(2 1 1/2)(2 2 100)...)
  (cond
    ((null? listm) '())
    ((= (length listm) 1) (car listm))
    ((<= (cadr (cdr (car listm))) (cadr (cdr (minclust (cdr listm)))))(car listm))
    (else (minclust (cdr listm)))
  )
)

;biglist is of form ( (1 (is) ((1 100)(2 3/4)(3 1/2))) (2 (the) ((1 1/2)(2 100)(3 3/4))) (3 ))
(define (minidistclust biglist acc) ;returns list of form ((1 1 100)(1 2 3/4)(1 3 2/3)(2 1 3/4)(2 2 100)(2 3 4/5)()()())
  (cond
    ((null? biglist) acc)
    (else (minidistclust (cdr biglist) (append acc (forone (car (car biglist)) (cadr (cdr (car biglist))) '()))))
  )
)


(define (forone id dooriyan acc) ;receives 1 ((1 100)(2 1/3)(3 3/4)) '() and should return ((1 1 100)(1 2 1/2)(1 3 3/4))
  (cond
    ((null? dooriyan)  acc)
    (else (forone id (cdr dooriyan) (append acc (list (cons id (car dooriyan)) ))))
  )
)

(define step4 (baharwalaloop step3 uniqid))
(display step4)