(load "mk.scm") ;; => #<unspecified>
(load "mkextraforms.scm") ;; => #<unspecified>
(load "previous_chapters.scm") ;; => #<unspecified>

(define int->binary-list
  (lambda (n)
    (cond
     ((zero? n) '())
     (else (cons (remainder n 2)
                 (int->binary-list (quotient n 2))))))) ;; => #<unspecified>

(define binary-list->int
  (lambda (lon)
    (letrec
        ((helper (lambda (lon n)
                   (cond
                    ((null? lon) 0)
                    (else (+ (* (car lon) n)
                             (helper (cdr lon) (* 2 n))))))))
      (helper lon 1)))) ;; => #<unspecified>

(binary-list->int '(0 0 0 1)) ;; => 8
(binary-list->int '(1 1 1 1)) ;; => 15
(binary-list->int '()) ;; => 0
(binary-list->int '(1 1 1 1 0)) ;; => 15

(define lon?
  (lambda (l)
    (cond
     ((null? l) #t)
     ((list? l) (and (number? (car l))
                     (lon? (cdr l))))
     (else #f)))) ;; => #<unspecified>

(lon? '(1 2 3 4)) ;; => #t
(lon? '(1 2 3 x)) ;; => #f
(lon? (car '((1 2 3) x))) ;; => #t
(lon? '(_.0 1 2)) ;; => #f
(lon? '(hello 2 3)) ;; => #f

(define replace-binary
  (lambda (l)
    (cond
     ((null? l) '())
     ((list? l) (cond
                 ((null? (car l)) (cons '()
                                        (replace-binary (cdr l))))
                 ((lon? (car l)) (cons (binary-list->int (car l))
                                       (replace-binary (cdr l))))
                 (else (cons (replace-binary (car l))
                             (replace-binary (cdr l))))))
     (else l)))) ;; => #<unspecified>

(define replace-base10
  (lambda (l)
    (cond
     ((null? l) '())
     ((list? l) (cond
                 ((null? (car l)) (cons '()
                                        (replace-base10 (cdr l))))
                 ((number? (car l)) (cons (int->binary-list (car l))
                                          (replace-base10 (cdr l))))
                 (else (cons (replace-base10 (car l))
                             (replace-base10 (cdr l))))))
     (else l)))) ;; => #<unspecified>

(replace-base10
 (replace-binary '(hello ((1 1 1) (1))))
 ) ;; => (hello ((1 1 1) (1)))

(define bound-*o
  (lambda (q p n m)
    (conde
     ((nullo q) (pairo p))
     (else
      (fresh (x y z)
             (cdro q x)
             (cdro p y)
             (condi
              ((nullo n)
               (cdro m z)
               (bound-*o x y z '()))
              (else
               (cdro n z)
               (bound-*o x y z m)))))))) ;; => #<unspecified>

(define odd-*o
  (lambda (x n m p)
    (fresh (q)
           (bound-*o q p n m)
           (*o x m q)
           (+o `(0 . ,q) m p)))) ;; => #<unspecified>


(define *o
  (lambda (n m p)
    (condi
     ((== '() n) (== '() p))
     ((poso n) (== '() m) (== '() p))
     ((== '(1) n) (poso m) (== m p))
     ((>1o n) (== '(1) m) (== n p))
     ((fresh (x z)
             (== `(0 . ,x) n) (poso x)
             (== `(0 . ,z) p) (poso z)
             (>1o m)
             (*o x m z)))
     ((fresh (x y)
             (== `(1 . ,x) n) (poso x)
             (== `(0 . ,y) m) (poso y)
             (*o m n p)))
     ((fresh (x y)
             (== `(1 . ,x) n) (poso x)
             (== `(1 . ,y) m) (poso y)
             (odd-*o x n m p)))
     (else fail)))) ;; => #<unspecified>


(run 34 (t)
     (fresh (x y r)
            (*o x y r)
            (== `(,x ,y ,r) t))) #| => |# '(
                                            (() _.0 ())
                                            ((_.0 . _.1) () ())
                                            ((1) (_.0 . _.1) (_.0 . _.1))
                                            ((_.0 _.1 . _.2) (1) (_.0 _.1 . _.2))
                                            ((0 1) (_.0 _.1 . _.2) (0 _.0 _.1 . _.2))
                                            ((1 _.0 . _.1) (0 1) (0 1 _.0 . _.1))
                                            ((0 0 1) (_.0 _.1 . _.2) (0 0 _.0 _.1 . _.2))
                                            ((1 1) (1 1) (1 0 0 1))
                                            ((0 1 _.0 . _.1) (0 1) (0 0 1 _.0 . _.1))
                                            ((1 _.0 . _.1) (0 0 1) (0 0 1 _.0 . _.1))
                                            ((0 0 0 1) (_.0 _.1 . _.2) (0 0 0 _.0 _.1 . _.2))
                                            ((1 1) (1 0 1) (1 1 1 1))
                                            ((0 1 1) (1 1) (0 1 0 0 1))
                                            ((1 1) (0 1 1) (0 1 0 0 1))
                                            ((0 0 1 _.0 . _.1) (0 1) (0 0 0 1 _.0 . _.1))
                                            ((1 1) (1 1 1) (1 0 1 0 1))
                                            ((0 1 _.0 . _.1) (0 0 1) (0 0 0 1 _.0 . _.1))
                                            ((1 _.0 . _.1) (0 0 0 1) (0 0 0 1 _.0 . _.1))
                                            ((0 0 0 0 1) (_.0 _.1 . _.2) (0 0 0 0 _.0 _.1 . _.2))
                                            ((1 0 1) (1 1) (1 1 1 1))
                                            ((0 1 1) (1 0 1) (0 1 1 1 1))
                                            ((1 0 1) (0 1 1) (0 1 1 1 1))
                                            ((0 0 1 1) (1 1) (0 0 1 0 0 1))
                                            ((1 1) (1 0 0 1) (1 1 0 1 1))
                                            ((0 1 1) (0 1 1) (0 0 1 0 0 1))
                                            ((1 1) (0 0 1 1) (0 0 1 0 0 1))
                                            ((0 0 0 1 _.0 . _.1) (0 1) (0 0 0 0 1 _.0 . _.1))
                                            ((1 1) (1 1 0 1) (1 0 0 0 0 1))
                                            ((0 1 1) (1 1 1) (0 1 0 1 0 1))
                                            ((1 1 1) (0 1 1) (0 1 0 1 0 1))
                                            ((0 0 1 _.0 . _.1) (0 0 1) (0 0 0 0 1 _.0 . _.1))
                                            ((1 1) (1 0 1 1) (1 1 1 0 0 1))
                                            ((0 1 _.0 . _.1) (0 0 0 1) (0 0 0 0 1 _.0 . _.1))
                                            ((1 _.0 . _.1) (0 0 0 0 1) (0 0 0 0 1 _.0 . _.1))
                                            )

(replace-binary (run 34 (t)
                     (fresh (x y r)
                            (*o x y r)
                            (== `(,x ,y ,r) t)))) #| => |# '((() _.0 ())
                                                             ((_.0 . _.1) () ())
                                                             (1 (_.0 . _.1) (_.0 . _.1))
                                                             ((_.0 _.1 . _.2) 1 (_.0 _.1 . _.2))
                                                             (2 (_.0 _.1 . _.2) (0 _.0 _.1 . _.2))
                                                             ((1 _.0 . _.1) 2 (0 1 _.0 . _.1))
                                                             (4 (_.0 _.1 . _.2) (0 0 _.0 _.1 . _.2))
                                                             (3 3 9)
                                                             ((0 1 _.0 . _.1) 2 (0 0 1 _.0 . _.1))
                                                             ((1 _.0 . _.1) 4 (0 0 1 _.0 . _.1))
                                                             (8 (_.0 _.1 . _.2) (0 0 0 _.0 _.1 . _.2))
                                                             (3 5 15)
                                                             (6 3 18)
                                                             (3 6 18)
                                                             ((0 0 1 _.0 . _.1) 2 (0 0 0 1 _.0 . _.1))
                                                             (3 7 21)
                                                             ((0 1 _.0 . _.1) 4 (0 0 0 1 _.0 . _.1))
                                                             ((1 _.0 . _.1) 8 (0 0 0 1 _.0 . _.1))
                                                             (16 (_.0 _.1 . _.2) (0 0 0 0 _.0 _.1 . _.2))
                                                             (5 3 15)
                                                             (6 5 30)
                                                             (5 6 30)
                                                             (12 3 36)
                                                             (3 9 27)
                                                             (6 6 36)
                                                             (3 12 36)
                                                             ((0 0 0 1 _.0 . _.1) 2 (0 0 0 0 1 _.0 . _.1))
                                                             (3 11 33)
                                                             (6 7 42)
                                                             (7 6 42)
                                                             ((0 0 1 _.0 . _.1) 4 (0 0 0 0 1 _.0 . _.1))
                                                             (3 13 39)
                                                             ((0 1 _.0 . _.1) 8 (0 0 0 0 1 _.0 . _.1))
                                                             ((1 _.0 . _.1) 16 (0 0 0 0 1 _.0 . _.1))
                                                             )
(replace-binary (run* (t)
                      (fresh (n m)
                             (*o n m (int->binary-list 97))
                             (== `(,n ,m) t))))


(define =lo
  (lambda (n m)
    (conde
     ((== '() n) (== '() m))
     ((== '(1) n) (== '(1) m))
     (else
      (fresh (a x b y)
             (== `(,a . ,x) n) (poso x)
             (== `(,b . ,y) m) (poso y)
             (=lo x y)))))) ;; => #<unspecified>

(run* (t)
      (fresh (w x y)
             (=lo `(1 ,w ,x . ,y) `(0 1 1 0 1))
             (== `(,w ,x ,y) t))) ;; => ((_.0 _.1 (_.2 1)))

(run* (b)
      (=lo `(1) `(,b))) ;; => (1)

(run* (n)
      (=lo `(1 0 1 . ,n) `(0 1 1 0 1))) ;; => ((_.0 1))

(run 5 (t)
     (fresh (y z)
            (=lo `(1 . ,y) `(1 . ,z))
            (== `(,y ,z) t))) #| => |# '(
                                         (() ())
                                         ((1) (1))
                                         ((_.0 1) (_.1 1))
                                         ((_.0 _.1 1) (_.2 _.3 1))
                                         ((_.0 _.1 _.2 1) (_.3 _.4 _.5 1))
                                         )

(run 5 (t)
     (fresh (y z)
            (=lo `(1 . ,y) `(0 . ,z))
            (== `(,y ,z) t))) #| => |# '(
                                         ((1) (1))
                                         ((_.0 1) (_.1 1))
                                         ((_.0 _.1 1) (_.2 _.3 1))
                                         ((_.0 _.1 _.2 1) (_.3 _.4 _.5 1))
                                         ((_.0 _.1 _.2 _.3 1) (_.4 _.5 _.6 _.7 1))
                                         )

(run 5 (t)
     (fresh (y z)
            (=lo `(1 . ,y) `(0 1 1 0 1 . ,z))
            (== `(,y ,z) t))) #| => |# '(
                                         ((_.0 _.1 _.2 1) ())
                                         ((_.0 _.1 _.2 _.3 1) (1))
                                         ((_.0 _.1 _.2 _.3 _.4 1) (_.5 1))
                                         ((_.0 _.1 _.2 _.3 _.4 _.5 1) (_.6 _.7 1))
                                         ((_.0 _.1 _.2 _.3 _.4 _.5 _.6 1) (_.7 _.8 _.9 1))
                                         )

(define <lo
  (lambda (n m)
    (conde
     ((== '() n) (poso m))
     ((== '(1) n) (>1o m))
     (else
      (fresh (a x b y)
             (== `(,a . ,x) n ) (poso x)
             (== `(,b . ,y) m ) (poso y)
             (<lo x y)))))) ;; => #<unspecified>

(run 5 (t)
     (fresh (y z)
            (<lo `(1 . ,y) `(0 1 1 0 1 . ,z))
            (== `(,y ,z) t))) #| => |# '(
                                         (() _.0)
                                         ((1) _.0)
                                         ((_.0 1) _.1)
                                         ((_.0 _.1 1) _.2)
                                         ((_.0 _.1 _.2 1) (_.3 . _.4))
                                         )
(define <=lo
  (lambda (n m)
    (conde
     ((=lo n m) S)
     ((<lo n m) S)
     (else U)))) ;; => #<unspecified>

(run 8 (t)
     (fresh (n m)
            (<=lo n m)
            (== `(,n ,m) t))) #| => |# '(
                                         (() ())
                                         ((1) (1))
                                         ((_.0 1) (_.1 1))
                                         ((_.0 _.1 1) (_.2 _.3 1))
                                         ((_.0 _.1 _.2 1) (_.3 _.4 _.5 1))
                                         ((_.0 _.1 _.2 _.3 1) (_.4 _.5 _.6 _.7 1))
                                         ((_.0 _.1 _.2 _.3 _.4 1) (_.5 _.6 _.7 _.8 _.9 1))
                                         ((_.0 _.1 _.2 _.3 _.4 _.5 1) (_.6 _.7 _.8 _.9 _.10 _.11 1))
                                         )


(run 1 (t)
     (fresh (n m)
            (<=lo n m)
            (*o n `(0 1) m)
            (== `(,n ,m) t))) ;; => ((() ()))

'(run 2 (t) ;; this has no value, because the first conde line always succeeds.
      (fresh (n m)
             (<=lo n m)
             (*o n `(0 1) m)
             (== `(,n ,m) t)))

(define <=lo
  (lambda (n m)
    (condi
     ((=lo n m) S)
     ((<lo n m) S)
     (else U)))) ;; => #<unspecified>

(run 2 (t)
     (fresh (n m)
            (<=lo n m)
            (*o n `(0 1) m)
            (== `(,n ,m) t))) ;; => ((() ()) ((1) (0 1)))

(run 10 (t)
     (fresh (n m)
            (<=lo n m)
            (*o n `(0 1) m)
            (== `(,n ,m) t))) #| => |# '(
                                         (() ())
                                         ((1) (0 1))
                                         ((0 1) (0 0 1))
                                         ((1 1) (0 1 1))
                                         ((0 0 1) (0 0 0 1))
                                         ((1 _.0 1) (0 1 _.0 1))
                                         ((0 1 1) (0 0 1 1))
                                         ((0 0 0 1) (0 0 0 0 1))
                                         ((1 _.0 _.1 1) (0 1 _.0 _.1 1))
                                         ((0 1 _.0 1) (0 0 1 _.0 1))
                                         )

(run 15 (t)
     (fresh (n m)
            (<=lo n m)
            (== `(,n ,m) t))) #| => |# '(
                                         (() ())
                                         (() (_.0 . _.1))
                                         ((1) (1))
                                         ((1) (_.0 _.1 . _.2))
                                         ((_.0 1) (_.1 1))
                                         ((_.0 1) (_.1 _.2 _.3 . _.4))
                                         ((_.0 _.1 1) (_.2 _.3 1))
                                         ((_.0 _.1 1) (_.2 _.3 _.4 _.5 . _.6))
                                         ((_.0 _.1 _.2 1) (_.3 _.4 _.5 1))
                                         ((_.0 _.1 _.2 1) (_.3 _.4 _.5 _.6 _.7 . _.8))
                                         ((_.0 _.1 _.2 _.3 1) (_.4 _.5 _.6 _.7 1))
                                         ((_.0 _.1 _.2 _.3 1) (_.4 _.5 _.6 _.7 _.8 _.9 . _.10))
                                         ((_.0 _.1 _.2 _.3 _.4 1) (_.5 _.6 _.7 _.8 _.9 1))
                                         ((_.0 _.1 _.2 _.3 _.4 1) (_.5 _.6 _.7 _.8 _.9 _.10 _.11 . _.12))
                                         ((_.0 _.1 _.2 _.3 _.4 _.5 1) (_.6 _.7 _.8 _.9 _.10 _.11 1))
                                         )

(define <o
  (lambda (n m)
    (condi
     ((<lo n m) S)
     ((=lo n m) (fresh (x)
                       (poso x)
                       (+o n x m)))
     (else U)))) ;; => #<unspecified>

(define <=o
  (lambda (n m)
    (condi
     ((== n m) S)
     ((<o n m) S)
     (else U)))) ;; => #<unspecified>

(run* (q)
      (<o `(1 0 1) `(1 1 1))
      (== #t q)) ;; => (#t)

(run* (q)
      (<o `(1 1 1) `(1 0 1))
      (== #t q)) ;; => ()

(run* (q)
      (<o `(1 0 1) `(1 0 1))
      (== #t q)) ;; => ()

(run 6 (n)
     (<o n `(1 0 1))) ;; => (() (0 0 1) (1) (_.0 1))

(run 6 (n)
     (<o `(1 0 1) n)) ;; => ((_.0 _.1 _.2 _.3 . _.4) (0 1 1) (1 1 1))

(define /o
  ;;;;;;;;;3 2 1 1
  ;;;;;;;;;8 2 4 0
  (lambda (n m q r)
    (condi
     ((== '() q) (== n r) (<o n m))
     ((== '(1) q) (== '() r) (== n m) (<o r m))
     ((<o m n) (<o r m) (fresh (mq)
                               (<=lo mq n)
                               (*o m q mq)
                               (+o mq r n)))
     (else U)))) ;; => #<unspecified>

(run 15 (t)
     (fresh (n m q r)
            (/o n m q r)
            (== `(,n ,m ,q ,r) t))) #| => |# '(
                                               (() (_.0 . _.1) () ())
                                               ((_.0 . _.1) (_.0 . _.1) (1) ())
                                               ((0 1) (1 1) () (0 1))
                                               ((1 1) (0 1) (1) (1))
                                               ((1) (_.0 _.1 . _.2) () (1))
                                               ((_.0 1) (1) (_.0 1) ())
                                               ((0 _.0 1) (1 _.0 1) () (0 _.0 1))
                                               ((_.0 _.1 1) (1) (_.0 _.1 1) ())
                                               ((_.0 1) (_.1 _.2 _.3 . _.4) () (_.0 1))
                                               ((_.0 _.1 _.2 1) (1) (_.0 _.1 _.2 1) ())
                                               ((0 0 1) (0 1 1) () (0 0 1))
                                               ((_.0 _.1 _.2 _.3 1) (1) (_.0 _.1 _.2 _.3 1) ())
                                               ((_.0 _.1 1) (_.2 _.3 _.4 _.5 . _.6) () (_.0 _.1 1))
                                               ((_.0 _.1 _.2 _.3 _.4 1) (1) (_.0 _.1 _.2 _.3 _.4 1) ())
                                               ((1 0 1) (0 1 1) () (1 0 1))
                                               )
(run* (m)
      (fresh (r)
             (/o '(1 0 1) m '(1 1 1) r))) ;; => ()
(binary-list->int '(1 1 1))


(define /o
  (lambda (n m q r)
    (condi
     ((== r n) (== '() q) (<o n m))
     ((== '(1) q) (=lo n m) (+o r m n)
      (<o r m))
     (else
      (alli
       (<lo m n)
       (<o r m)
       (poso q)
       (fresh (nh nl qh ql qlm qlmr rr rh)
              (alli
               (splito n r nl nh)
               (splito q r ql qh)
               (conde
                ((== '() nh)
                 (== '() qh)
                 (-o nl r qlm)
                 (*o ql m qlm))
                (else
                 (alli
                  (poso nh)
                  (*o ql m qlm)
                  (+o qlm r qlmr)
                  (-o qlmr nl rr)
                  (splito rr r '() rh)
                  (/o nh m qh rh))))))))))) ;; => #<unspecified>

(define splito
  (lambda (n r l h)
    (condi
     ((== '() n) (== '() h) (== '() l))
     ((fresh (b n^)
             (== `(0 ,b . ,n^) n)
             (== '() r)
             (== `(,b . ,n^) h)
             (== '() l)))
     ((fresh (n^)
             (==  `(1 . ,n^) n)
             (== '() r)
             (== n^ h)
             (== '(1) l)))
     ((fresh (b n^ a r^)
             (== `(0 ,b . ,n^) n)
             (== `(,a . ,r^) r)
             (== '() l)
             (splito `(,b . ,n^) r^ '() h)))
     ((fresh (n^ a r^)
             (== `(1 . ,n^) n)
             (== `(,a . ,r^) r)
             (== '(1) l)
             (splito n^ r^ '() h)))
     ((fresh (b n^ a r^ l^)
             (== `(,b . ,n^) n)
             (== `(,a . ,r^) r)
             (== `(,b . ,l^) l)
             (poso l^)
             (splito n^ r^ l^ h)))
     (else fail)))) ;; => #<unspecified>

(define logo
  (lambda (n b q r)
    (condi
     ((== '(1) n) (poso b) (== '() q) (== '() r))
     ((== '() q) (<o n b) (+o r '(1) n))
     ((== '(1) q) (>1o b) (=lo n b) (+o r b n))
     ((== '(1) b) (poso q) (+o r '(1) n))
     ((== '() b) (poso q) (== r n))
     ((== '(0 1) b)
      (fresh (a ad dd)
             (poso dd)
             (== `(,a ,ad . ,dd) n)
             (exp2 n '() q)
             (fresh (s)
                    (splito n dd r s))))
     ((fresh (a ad add ddd)
             (conde
              ((== '(1 1) b))
              (else (== `(,a ,ad ,add . ,ddd) b))))
      (<lo b n)
      (fresh (bw1 bw nw nw1 ql1 ql s)
             (exp2 b '() bw1)
             (+o bw1 '(1) bw)
             (<lo q n)
             (fresh (q1 bwq1)
                    (+o q '(1) q1)
                    (*o bw q1 bwq1)
                    (<o nw1 bwq1))
             (exp2 n '() nw1)
             (+o nw1 '(1) nw)
             (/o nw bw ql1 s)
             (+o ql '(1) ql1)
             (conde
              ((== q ql))
              (else (<lo ql q)))
             (fresh (bql qh s qdh qd)
                    (repeated-mul b ql bql)
                    (/o nw bw1 qh s)
                    (+o ql qdh qh)
                    (+o ql qd q)
                    (conde
                     ((== qd qdh))
                     (else (<o qd qdh)))
                    (fresh (bqd bq1 bq)
                           (repeated-mul b qd bqd)
                           (*o bql bqd bq)
                           (*o b bq bq1)
                           (+o bq r n)
                           (<o n bq1)))))
     (else fail)))) ;; => #<unspecified>

(define exp2
  (lambda (n b q)
    (condi
     ((== '(1) n) (== '() q))
     ((>1o n) (== '(1) q)
      (fresh (s)
             (splito n b s '(1))))
     ((fresh (q1 b2)
             (alli
              (== `(0 . ,q1) q)
              (poso q1)
              (<lo b n)
              (appendo b `(1 . ,b) b2)
              (exp2 n b2 q1))))
     ((fresh (q1 nh b2 s)
             (alli
              (== `(1 . ,q1) q)
              (poso q1)
              (poso nh)
              (splito n b s nh)
              (appendo b `(1 . ,b) b2)
              (exp2 nh b2 q1))))
     (else fail)))) ;; => #<unspecified>

(define repeated-mul
  (lambda (n q nq)
    (conde
     ((poso n) (== '() q) (== '(1) nq))
     ((== '(1) q) (== n nq))
     ((>1o q)
      (fresh (q1 nq1)
             (+o q1 '(1) q)
             (repeated-mul n q1 nq1)
             (*o nq1 n nq)))
     (else fail)))) ;; => #<unspecified>

(run* (r)
      (logo `(0 1 1 1) `(0 1) `(1 1) r)) ;; => ((0 1 1))

'(run 8 (s) ;; This works, (apparently) but it takes a while to actually output
      ;; the numbers so for new we're happy to just say it works.
      (fresh (b q r)
             (logo `(0 0 1 0 0 0 1) b q r)
             (>1o q)
             (== `(,b ,q ,r) s)
             )
      ) ;; =>

(define expo
  (lambda (b q n)
    (logo n b q '()))) ;; => #<unspecified>

'(run* (t)
       (expo '(1 1) '(1 0 1) t)) ;; => ((1 1 0 0 1 1 1 1))
