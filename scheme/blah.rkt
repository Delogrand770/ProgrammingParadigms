;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname blah) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ())))
; Quick sort
(define (qsort lst)
  (if (null? lst)
      lst
      (append (qsort (filter (lambda (x) (< x (first lst))) lst))
              (filter (lambda (x) (= x (first lst))) lst)
              (qsort (filter (lambda (x) (> x (first lst))) lst)))))

; Quick sort 2 with "let" statements
(define (qsort2 lst)
  (if (null? lst)
      lst
      (let ((pivot (first lst))
            (answer 42)) ;Just a statement tho show "let" statement syntax
        (append (qsort2 (filter (lambda (x) (< x pivot)) lst))
               (filter (lambda (x) (= x pivot)) lst)
               (qsort2 (filter (lambda (x) (> x pivot)) lst))))))

; Temperature conversion
(define (f2c f) 
  (* (/ 5 9) (- f 32)))

(define (c2f c) 
  (+ 32 (* c (/ 9 5))))
  

; Description: Function example from class.
;
; f( x, y, z, w ) = 4x2 + 2y – 3z + g( z ) * w
; g( x ) = x – 5
; h( x ) = 2x3
;
; f( g( g( 2 ) ), h( f( 0, 3, 0, 2 ) ), h( -3 ), g( h( -1 ) ) ) – 533 = ???
; f( g( -3 ),     h( -4 ),              -54,     g( -2 ) )      - 533 = ???
; f( -8,          -128,                 -54,     -7 )           - 533 = ???
; 575                                                           - 533 = ???
;                                                                     = 42
;
; Usage: (fortytwo)
;
(define 
  (f x y z w) (+ (- (+ (* 4 (* x x)) (* 2 y)) (* 3 z)) (* (g z) w)))

(define (h x) 
  (* 2 (expt x 3)))

(define (g x) 
  (- x 5))

(define (fortytwo) 
  (- (f (g (g 2)) (h (f 0 3 0 2)) (h -3) (g (h -1))) 533))


;Define constants (they cannot be changed once defined)
(define answer 42)
(define xlii 42)
(define xxxvii 37)

;Check types
;(number? 42)
;(symbol? 42)
;(list? 42)
;(number? answer)
;(char? #\a)
;(integer? 3.14)
;(real? 3.14)
;(empty? '(1 2 3))
;(empty? '())
;(= answer xlii)
;(eq? answer 'dog)
;(eqv? answer 'dog)
;(equal? (list 1 2 3) (list 1 2 3))
;(eqv? (integer->char 955) (integer->char 955))
;(eq? (integer->char 955) (integer->char 955))
;(eqv? (expt 2 100) (expt 2 100))
;(eq? (expt 2 100) (expt 2 100))

;isEven?
(define (isEven? n) 
  (and (number? n) (= 0 (modulo n 2))))

;isOdd?
(define (isOdd? n) 
  (and (number? n) (= 1 (modulo n 2))))

;isTriangle?
(define (isTriangle? a b c)
  (and (< a (+ b c))
       (< b (+ a c))
       (< c (+ a b))))

;isRightTriangle?
(define (isRightTriangle? a b c)
  (or (= (+ (* a a) (* b b)) (* c c))
      (= (+ (* b b) (* c c)) (* a a))
      (= (+ (* a a) (* c c)) (* b b))))
      
(define (fact n)
  (if (<= n 0) 1 (* n (fact (- n 1)))))

(define (factorial n)
  (cond ((< n 0) (error "ERROR: Negative value!"))
        ((= n 0) 1)
        ((> n 0) (* n (factorial (- n 1))))))

(define (fib n)
  (cond ((= n 0) 0)
        ((< n 0) (error "ERROR: Undefined!"))
        ((<= n 2) 1)
        (else (+ (fib (- n 1)) (fib (- n 2))))))

;List work
;(define lst '(1 2 3 4 5 6 7 8))
;(car lst)
;(cdr lst)
;(car (cdr lst))
;(caddr lst)
;(cdddr lst)
;(first lst)
;(second lst)
;(rest lst)
;(cons 0 lst) ;Adds 0 to front of lst

;List contains?
(define (contains? item lst)
  (cond ((null? lst) false)
        ((eqv? item (first lst)) true)
        (else (contains? item (rest lst)))))

;Get list length
(define (len lst)
  (if (null? lst) 
      0 
      (+ 1 (len (rest lst)))))
 
;Sum list of numbers
(define (sum lst)
  (if (null? lst) 
      0 
      (+ (first lst) (sum (rest lst)))))

;Delete item from list
(define (del item lst)
  (cond ((null? lst)
         lst)
        ((eqv? item (first lst))
         (rest lst))
        (else 
         (cons (first lst) (del item (rest lst))))))
        
;Add item to the end of a list
(define (addToEnd item lst)
  (cond ((null? lst)
         (cons item lst))
        (else
         (cons (first lst) (addToEnd item (rest lst))))))


;Stack functions
(define (newStack)
  '())

(define (isEmpty? stk)
  (null? stk))
  
(define (push item stk)
  (cons item stk))

(define (top stk)
  (if (isEmpty? stk)
      (error "ERROR: Accesed top of empty stack.")
      (first stk)))

(define (pop stk)
  (if (isEmpty? stk)
      (error "ERROR: Popped empty stack.")
      (rest stk)))


;Queue functions. Uses addToEnd above here
(define (newQueue)
  '())

(define (enqueue item que)
  (if (null? que)
      (list item)
      (cons (first que) (addToEnd item (rest que)))))
  
(define (front que)
  (if (isEmpty? que)
      (error "ERROR: Front of an empty queue.")
      (first que)))

(define (dequeue que)
  (if (isEmpty? que)
      (error "ERROR: Dequeue of an empty queue.")
      (rest que)))

;Palindrom checking with queues and stacks
(define (palindrome? str)
  (palindromeHelper? (removeWhite (string->list str)) (newStack) (newQueue)))

(define (palindromeHelper? charList stk que)
  (cond ((null? charList)
         (or (and (isEmpty? stk) (isEmpty? que))
             (and (eqv? (top stk) (front que))
                  (palindromeHelper? charList (pop stk) (dequeue que)))))
        (else
         (palindromeHelper? (rest charList)
                            (push (first charList) stk)
                            (enqueue (first charList) que)))))

(define (removeWhite lst)
  (cond ((null? lst) lst)
        ((eqv? (first lst) #\space)
               (removeWhite (rest lst)))
         (else     
        (cons (first lst) (removeWhite (rest lst))))))
              
;(require racket/trace)
;(trace factorial)
;(factorial 5)

;Double list
(define (double lst)
  (cond ((null? lst) '())
        (else (cons (first lst) (cons (first lst) (double (rest lst)))))))

;Weave list
(define (weave lstA lstB)
  (cond ((null? lstA) lstB)
        ((null? lstB) lstA)
        ((and (null? lstA) (null? lstB)) '())
        (else (cons (first lstA) (cons (first lstB) (weave (rest lstA) (rest lstB)))))))

;Append lst
(define (app lstA lstB)
  (cond ((null? lstA) lstB)
        (else (cons (first lstA) (app (rest lstA) lstB)))))

;Merge lst
(define (merge lstA lstB)
  (qsort (app lstA lstB)))

; Display a list with newlines between each element. Uses "begin"
(define (displayln lst)
  (cond ((null? lst)
         (display ""))
        (else
         (begin (display (first lst))
                (newline)
                (displayln (rest lst))))))