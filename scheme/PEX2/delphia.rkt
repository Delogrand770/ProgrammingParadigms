;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname delphia) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ())))
; File: delphia.rkt
;
; Author: C2C Gavin Delphia
;
; Description: PEX2
;
; Prelim documentation statement: None, In class you told me about the char math for valueOf.
;
; PEX documentation statement:  None

;Defining oparators for ease of use.
(define mult (first (string->list "*")))
(define div (first (string->list "/")))
(define add (first (string->list "+")))
(define sub (first (string->list "-")))
(define zero (first (string->list "0")))

;Defining parenthesis for ease of use.
(define leftParen (first (string->list "(")))
(define rightParen (first (string->list ")")))

;Takes a symbol and determines if it is a valid math operator (+,-,*,/)
(define (operator? sym)
  (cond ((eqv? sym mult) true)
        ((eqv? sym div) true)
        ((eqv? sym add) true)
        ((eqv? sym sub) true)
        (else false)))

;Takes two symbols and determines if sym1 has precendece over sym2.
;Same symbols always evaluate to true.
(define (precedence? sym1 sym2)
  (and (operator? sym1)
       (operator? sym2)
       (or (eqv? sym1 mult) (eqv? sym1 div)
           (eqv? sym2 add) (eqv? sym2 sub))))
;  (cond ((eqv? sym1 mult) true)
;        ((and (eqv? sym1 div) (not (eqv? sym2 mult))) true)
;        ((and (and (eqv? sym1 add) (not (eqv? sym2 mult))) (not (eqv? sym2 div))) true)
;        ((and (and (and (eqv? sym1 sub) (not (eqv? sym2 mult))) (not (eqv? sym2 div))) (not (eqv? sym2 add))) true)
;        (else false)))

;Performs a calculation when given an operator and two numbers.
; Result is (num1 oparator num2)
(define (calculate operator num1 num2)
  (cond ((eqv? operator mult) (* num1 num2))
        ((eqv? operator div) (/ num1 num2))
        ((eqv? operator add) (+ num1 num2))
        ((eqv? operator sub) (- num1 num2))
        (else (error "ERROR: calculate | Invalid math operator"))))
        
;Converts a character to a number if possible.
(define (valueOf char)
  (- (char->integer char) (char->integer zero)))        

;Given a stack of characters (that are numbers), the resulting number will be outputted.
(define (getNumber stk)
           (getNumberHelper stk 0 1))

;Recursive helper function for getNumber.
(define (getNumberHelper stk total place)
                 (cond ((isEmpty? stk) total)
                       (else (getNumberHelper (rest stk) (+ total (* place (valueOf (top stk)))) (* place 10)))))
                 
;Converts a string to a number. 
;This assumes the string consists of a valud number.
(define (stringToNumber str)
  (stringToNumberHelper (string->list str) (newStack)))

;Recursive helper function for stringToNumber.
(define (stringToNumberHelper charList stk)
  (cond ((null? charList) (getNumber stk))
        (else (stringToNumberHelper (rest charList) (push (first charList) stk)))))

;Converts a string into a list of numbers, operators, and parenthesis.
;Removes white space.
(define (tokenize str) 
 (tokenizeHelper (removeWhite (string->list str)) (newStack)))

;Recursive helper function for tokenize.
(define (tokenizeHelper lst stk)
  (cond ((null? lst) (if (isEmpty? stk) lst (cons (getNumber stk) lst)))
        ((not (or (or (operator? (first lst)) (eqv? (first lst) leftParen)) (eqv? (first lst) rightParen))) 
         (tokenizeHelper (rest lst) (push (first lst) stk)))
        (else (if (isEmpty? stk) 
                  (cons (first lst) (tokenizeHelper (rest lst) (newStack))) 
                  (cons (getNumber stk) (cons (first lst) (tokenizeHelper (rest lst) (newStack))))))))

;Add item to the end of a list
(define (addToEnd item lst)
  (cond ((null? lst) (cons item lst))
        (else (cons (first lst) (addToEnd item (rest lst))))))

;Given an infix expression this will convert it to a postfix expression.
(define (infixToPostfix lst)
  (infixToPostfixHelper (addToEnd rightParen lst) '() (push leftParen (newStack))))

;Recursive helper function for infixToPostfix.
(define (infixToPostfixHelper lstI lstP stk)
  (cond ((isEmpty? stk) lstP)
        ((eqv? leftParen (first lstI)) 
         (infixToPostfixHelper (rest lstI) lstP (push leftParen stk)))
        ((operator? (first lstI)) 
         (if (precedence? (top stk) (first lstI)) 
             (infixToPostfixHelper lstI (addToEnd (top stk) lstP) (pop stk)) 
             (infixToPostfixHelper (rest lstI) lstP (push (first lstI) stk))))
        ((and (eqv? (first lstI) rightParen)
              (operator? (top stk)))
         (infixToPostfixHelper lstI (addToEnd (top stk) lstP) (pop stk)))
        ((eqv? (first lstI) rightParen) ; Must be a left paren on the top of the stack.
         (infixToPostfixHelper (rest lstI) lstP (pop stk)))
        (else (infixToPostfixHelper (rest lstI) (addToEnd (first lstI) lstP) stk))))
  
;Given a postfix expression this will evaluate the result.
(define (evaluatePostfix lst)
  (evaluatePostfixHelper lst (newStack)))

;Recursive helper function for evaluatePostfix.
(define (evaluatePostfixHelper lst stk)
  (cond ((null? lst) (top stk))
        ((number? (first lst)) (evaluatePostfixHelper (rest lst) (push (first lst) stk)))
        (else (evaluatePostfixHelper (rest lst) (push (calculate (first lst) (top (pop stk)) (top stk)) (pop (pop stk)))))))
  
;Given a string that contains a math problem within the scope of this assignment it will output the resulting answer.
(define (evaluate str)
  (evaluatePostfix (infixToPostfix (tokenize str))))

;Removes the white space 
(define (removeWhite lst)
  (cond ((null? lst)  lst)
        ((eqv? #\space (first lst))
               (removeWhite (rest lst)))
         (else (cons (first lst) (removeWhite (rest lst))))))
  
; ================================================================
; Stack functions - Leave these at the bottom of your file.
; You do not have to write function headers for these functions.
(define (newStack)
  '())

(define (isEmpty? stk)
  (null? stk))

(define (push item stk)
  (cons item stk))

(define (top stk)
  (if (isEmpty? stk)
      (error "ERROR: Accessed top of empty stack.")
      (first stk)))

(define (pop stk)
  (if (isEmpty? stk)
      (error "ERROR: Popped empty stack.")
      (rest stk)))

; ==============================================================================
; =========================== PEX Grading Functions ============================
; ==============================================================================
; Paste this code at the very bottom of your file and DO NOT CHANGE IN ANY WAY!!
; ==============================================================================

; Function: (grade)
; Description: Grades the entire PEX.
; PRE: infix, tokens, postfix, and results must be defined as described in
;      gradeTokenizer, gradeToPostfix, gradeEvaluatePostfix, and gradeEvaluate.
; POST: A percentage of tests passed will be returned.
; USE: (grade)
(define (grade)
  (* 100 (/ (+ (gradeTokenizer) (gradeToPostfix) (gradeEvaluatePostfix) (gradeEvaluate)) (* 4 (length infix)))))

; Function: (gradeTokenizer)
; Description: Grades the tokenizer method.
; PRE: infix must be defined as a list of strings that are valid expressions.
;      tokens must be defined as a list of lists containing the tokens
;      corresponding to the infix expressions.
; POST: The number of correct matches is returned.
; USE: (gradeTokenizer)
(define (gradeTokenizer)
  (gradeTokenizerHelper infix tokens 0))

; Function: (gradeTokenizerHelper infixList tokenList numCorrect)
; Description: A helper function for gradeTokenizer.
; PRE: infixList is a list of strings that are valid expressions.
;      tokenLists is a list of lists containing the tokens
;      corresponding to the infix expressions.
; POST: The number of correct matches is returned.
; USE: (gradeTokenizerHelper infix tokens 0)
(define (gradeTokenizerHelper infixList tokenLists numCorrect)
  (cond ((null? infixList)
         numCorrect)
        ((equal? (tokenize (first infixList)) (first tokenLists))
         (gradeTokenizerHelper (rest infixList) (rest tokenLists) (+ 1 numCorrect)))
        (else
         (gradeTokenizerHelper (rest infixList) (rest tokenLists) (+ 0 numCorrect)))))

; Function: (gradeToPostfix)
; Description: Grades the infixToPostfix method.
; PRE: tokens must be defined as a list of lists containing tokenized expressions.
;      postfix must be defined as a list of lists containing the tokens
;      corresponding to the tokenized expressions in postfix notation.
; POST: The number of correct matches is returned.
; USE: (gradeToPostfix)
(define (gradeToPostfix)
  (gradeToPostfixHelper tokens postfix 0))

; Function: (gradeToPostfixHelper tokenLists postfixLists numCorrect)
; Description: A helper function for gradeToPostfix.
; PRE: tokenLists is a list of lists containing tokenized expressions.
;      postfixLists is a list of lists containing the tokens
;      corresponding to the tokenized expressions in postfix notation.
; POST: The number of correct matches is returned.
; USE: (gradeToPostfixHelper tokens postfix 0)
(define (gradeToPostfixHelper tokenLists postfixLists numCorrect)
  (cond ((null? tokenLists)
         numCorrect)
        ((equal? (infixToPostfix (first tokenLists)) (first postfixLists))
         (gradeToPostfixHelper (rest tokenLists) (rest postfixLists) (+ 1 numCorrect)))
        (else
         (gradeToPostfixHelper (rest tokenLists) (rest postfixLists) (+ 0 numCorrect)))))

; Function: (gradeEvaluatePostfix)
; Description: Grades the evaluatePostfix method.
; PRE: postfix must be defined as a list of lists containing tokens in postfix notation.
;      results must be a list of values corresponding to the results of the postfix expressions.
; POST: The number of correct matches is returned.
; USE: (gradeEvaluatePostfix)
(define (gradeEvaluatePostfix)
  (gradeEvaluatePostfixHelper postfix results 0))

; Function: (gradeEvaluatePostfixHelper postfixLists resultList numCorrect)
; Description: A helper function for gradeEvaluatePostfix.
; PRE: postfixLists is a list of lists containing tokens in postfix notation.
;      resultList is a list of values corresponding to the results of the postfix expressions.
; POST: The number of correct matches is returned.
; USE: (gradeEvaluatePostfixHelper postfix results 0)
(define (gradeEvaluatePostfixHelper postfixLists resultList numCorrect)
  (cond ((null? postfixLists)
         numCorrect)
        ((closeEnough (evaluatePostfix (first postfixLists)) (first resultList))
         (gradeEvaluatePostfixHelper (rest postfixLists) (rest resultList) (+ 1 numCorrect)))
        (else
         (gradeEvaluatePostfixHelper (rest postfixLists) (rest resultList) (+ 0 numCorrect)))))

; Function: (gradeEvaluate)
; Description: Grades the evaluate method.
; PRE: infix must be defined as a list of strings that are valid expressions.
;      results must be a list of values corresponding to the results expressions.
; POST: The number of correct matches is returned.
; USE: (gradeEvaluate)
(define (gradeEvaluate)
  (gradeEvaluateHelper infix results 0))

; Function: (gradeEvaluateHelper infixList resultList numCorrect)
; Description: A helper function for gradeEvaluatePostfix.
; PRE: infixList must be a list of strings that are valid expressions.
;      resultList is a list of values corresponding to the results of the expressions.
; POST: The number of correct matches is returned.
; USE: (gradeEvaluateHelper infix results 0)
(define (gradeEvaluateHelper infixList resultList numCorrect)
  (cond ((null? infixList)
         numCorrect)
        ((closeEnough (evaluate (first infixList)) (first resultList))
         (gradeEvaluateHelper (rest infixList) (rest resultList) (+ 1 numCorrect)))
        (else
         (gradeEvaluateHelper (rest infixList) (rest resultList) (+ 0 numCorrect)))))

; Function: (closeEnough a b)
; Description: Determines if two numeric values are within a defined tolerance.
; PRE: a must be a number, b must be a number, and tolerance must be defined as a number.
; POST: The function will return true if the difference between a and b is less than the
;       tolerance; false otherwise.
; USE: (closeEnough 3.14 3.14159)
(define (closeEnough a b)
  (< (abs (- a b)) tolerance))

; Definition of tolerance for the closeEnough function.
(define tolerance 0.0001)

; Function: (get n lst)
; Description: Gets a specific element from a list.
; PRE: lst must be a list, n must be a number between 0 and length of lst - 1.
; POST: The nth element will be returned.
; USE: (get 0 '(a b c d e f g h)) ; will return 'a
;      (get 7 '(a b c d e f g h)) ; will return 'h
(define (get n lst)
  (cond ((= n 0)
         (first lst))
        (else
         (get (- n 1) (rest lst)))))

; A list of strings containing valid infix expressions.
(define infix
  '("42"
    "(6+2)*5-8/4"
    "(64+32)*15-888/444"
    "4+16*10/4-2"
    "4 + 16 * 10 / 4 - 2"
    "(4+16)*10/(4-2)"
    "16 + 4"
    "16 - 4"
    "16 * 4"
    "16 / 4"
    "16 + 4 + 2"
    "16 - 4 - 2"
    "16 * 4 * 2"
    "16 / 4 / 2"
    "16 + 4 - 2"
    "16 - 4 + 2"
    "16 * 4 / 2"
    "16 / 4 * 2"
    "16 + 8 + 4 + 2"
    "16 - 8 - 4 - 2"
    "16 * 8 * 4 * 2"
    "16 / 8 / 4 / 2"
    "16 - 8 + 4 - 2"
    "16 + 8 - 4 + 2"
    "16 - 8 - 4 + 2"
    "16 + 8 - 4 - 2"
    "16 / 8 * 4 / 2"
    "16 * 8 / 4 * 2"
    "16 * 8 * 4 / 2"
    "16 * 8 / 4 / 2"
    "2 + 4 - 6 * 8 / 10"
    "2 + 4 - 6 / 8 * 10"
    "2 + 4 * 6 - 8 / 10"
    "2 + 4 * 6 / 8 - 10"
    "2 + 4 / 6 - 8 * 10"
    "2 + 4 / 6 * 8 - 10"
    "2 - 4 + 6 * 8 / 10"
    "2 - 4 + 6 / 8 * 10"
    "2 - 4 * 6 + 8 / 10"
    "2 - 4 * 6 / 8 + 10"
    "2 - 4 / 6 + 8 * 10"
    "2 - 4 / 6 * 8 + 10"
    "2 * 4 + 6 - 8 / 10"
    "2 * 4 + 6 / 8 - 10"
    "2 * 4 - 6 + 8 / 10"
    "2 * 4 - 6 / 8 + 10"
    "2 * 4 / 6 + 8 - 10"
    "2 * 4 / 6 - 8 + 10"
    "2 / 4 + 6 - 8 * 10"
    "2 / 4 + 6 * 8 - 10"
    "2 / 4 - 6 + 8 * 10"
    "2 / 4 - 6 * 8 + 10"
    "2 / 4 * 6 + 8 - 10"
    "2 / 4 * 6 - 8 + 10"
    "( 2 + 4 ) - 6 * 8 / 10"
    "( 2 + 4 ) - 6 / 8 * 10"
    "( 2 + 4 ) * 6 - 8 / 10"
    "( 2 + 4 ) * 6 / 8 - 10"
    "( 2 + 4 ) / 6 - 8 * 10"
    "( 2 + 4 ) / 6 * 8 - 10"
    "2 - ( 4 + 6 ) * 8 / 10"
    "2 - ( 4 + 6 ) / 8 * 10"
    "2 - 4 * ( 6 + 8 ) / 10"
    "2 - 4 * 6 / ( 8 + 10 )"
    "2 - 4 / ( 6 + 8 ) * 10"
    "2 - 4 / 6 * ( 8 + 10 )"
    "2 * ( 4 + 6 ) - 8 / 10"
    "2 * ( 4 + 6 ) / 8 - 10"
    "2 * 4 - ( 6 + 8 ) / 10"
    "2 * 4 - 6 / ( 8 + 10 )"
    "2 * 4 / ( 6 + 8 ) - 10"
    "2 * 4 / 6 - ( 8 + 10 )"
    "2 / ( 4 + 6 ) - 8 * 10"
    "2 / ( 4 + 6 ) * 8 - 10"
    "2 / 4 - ( 6 + 8 ) * 10"
    "2 / 4 - 6 * ( 8 + 10 )"
    "2 / 4 * ( 6 + 8 ) - 10"
    "2 / 4 * 6 - ( 8 + 10 )"
    "2 + ( 4 - 6 ) * 8 / 10"
    "2 + ( 4 - 6 ) / 8 * 10"
    "2 + 4 * ( 6 - 8 ) / 10"
    "2 + 4 * 6 / ( 8 - 10 )"
    "2 + 4 / ( 6 - 8 ) * 10"
    "2 + 4 / 6 * ( 8 - 10 )"
    "( 2 - 4 ) + 6 * 8 / 10"
    "( 2 - 4 ) + 6 / 8 * 10"
    "( 2 - 4 ) * 6 + 8 / 10"
    "( 2 - 4 ) * 6 / 8 + 10"
    "( 2 - 4 ) / 6 + 8 * 10"
    "( 2 - 4 ) / 6 * 8 + 10"
    "2 * 4 + ( 6 - 8 ) / 10"
    "2 * 4 + 6 / ( 8 - 10 )"
    "2 * ( 4 - 6 ) + 8 / 10"
    "2 * ( 4 - 6 ) / 8 + 10"
    "2 * 4 / 6 + ( 8 - 10 )"
    "2 * 4 / ( 6 - 8 ) + 10"
    "2 / 4 + ( 6 - 8 ) * 10"
    "2 / 4 + 6 * ( 8 - 10 )"
    "2 / ( 4 - 6 ) + 8 * 10"
    "2 / ( 4 - 6 ) * 8 + 10"
    "2 / 4 * 6 + ( 8 - 10 )"
    "2 / 4 * ( 6 - 8 ) + 10"
    "( 2 + 4 - 6 ) * 8 / 10"
    "( 2 + 4 - 6 ) / 8 * 10"
    "( 2 + 4 ) * ( 6 - 8 ) / 10"
    "( 2 + 4 ) * 6 / ( 8 - 10 )"
    "( 2 + 4 ) / ( 6 - 8 ) * 10"
    "( 2 + 4 ) / 6 * ( 8 - 10 )"
    "( 2 - 4 + 6 ) * 8 / 10"
    "( 2 - 4 + 6 ) / 8 * 10"
    "( 2 - 4 ) * ( 6 + 8 ) / 10"
    "( 2 - 4 ) * 6 / ( 8 + 10 )"
    "( 2 - 4 ) / ( 6 + 8 ) * 10"
    "( 2 - 4 ) / 6 * ( 8 + 10 )"
    "2 * ( 4 + 6 - 8 ) / 10"
    "2 * ( 4 + 6 ) / ( 8 - 10 )"
    "2 * ( 4 - 6 + 8 ) / 10"
    "2 * ( 4 - 6 ) / ( 8 + 10 )"
    "2 * 4 / ( 6 + 8 - 10 )"
    "2 * 4 / ( 6 - 8 + 10 )"
    "2 / ( 4 + 6 - 8 ) * 10"
    "2 / ( 4 + 6 ) * ( 8 - 10 )"
    "2 / ( 4 - 6 + 8 ) * 10"
    "2 / ( 4 - 6 ) * ( 8 + 10 )"
    "2 / 4 * ( 6 + 8 - 10 )"
    "2 / 4 * ( 6 - 8 + 10 )"
    "( 2 + 4 - 6 * 8 / 10 )"
    "2 + 4 - ( 6 / 8 * 10 )"
    "2 + ( 4 * 6 ) - ( 8 / 10 )"
    "2 + ( 4 * 6 / 8 ) - 10"
    "( 2 * 4 ) + 6 - ( 8 / 10 )"
    "( 2 * ( 4 / 6 ) ) + 8 - 10"
    "2 * 4 / ( 6 - ( 8 + 10 ) )"
    "( 2 + ( 4 - 6 ) * ( 8 / 10 ) )"))

; A list of token lists corresponding to the list of infix expressions.
(define tokens
  '((42)
    (#\( 6 #\+ 2 #\) #\* 5 #\- 8 #\/ 4)
    (#\( 64 #\+ 32 #\) #\* 15 #\- 888 #\/ 444)
    (4 #\+ 16 #\* 10 #\/ 4 #\- 2)
    (4 #\+ 16 #\* 10 #\/ 4 #\- 2)
    (#\( 4 #\+ 16 #\) #\* 10 #\/ #\( 4 #\- 2 #\))
    (16 #\+ 4)
    (16 #\- 4)
    (16 #\* 4)
    (16 #\/ 4)
    (16 #\+ 4 #\+ 2)
    (16 #\- 4 #\- 2)
    (16 #\* 4 #\* 2)
    (16 #\/ 4 #\/ 2)
    (16 #\+ 4 #\- 2)
    (16 #\- 4 #\+ 2)
    (16 #\* 4 #\/ 2)
    (16 #\/ 4 #\* 2)
    (16 #\+ 8 #\+ 4 #\+ 2)
    (16 #\- 8 #\- 4 #\- 2)
    (16 #\* 8 #\* 4 #\* 2)
    (16 #\/ 8 #\/ 4 #\/ 2)
    (16 #\- 8 #\+ 4 #\- 2)
    (16 #\+ 8 #\- 4 #\+ 2)
    (16 #\- 8 #\- 4 #\+ 2)
    (16 #\+ 8 #\- 4 #\- 2)
    (16 #\/ 8 #\* 4 #\/ 2)
    (16 #\* 8 #\/ 4 #\* 2)
    (16 #\* 8 #\* 4 #\/ 2)
    (16 #\* 8 #\/ 4 #\/ 2)
    (2 #\+ 4 #\- 6 #\* 8 #\/ 10)
    (2 #\+ 4 #\- 6 #\/ 8 #\* 10)
    (2 #\+ 4 #\* 6 #\- 8 #\/ 10)
    (2 #\+ 4 #\* 6 #\/ 8 #\- 10)
    (2 #\+ 4 #\/ 6 #\- 8 #\* 10)
    (2 #\+ 4 #\/ 6 #\* 8 #\- 10)
    (2 #\- 4 #\+ 6 #\* 8 #\/ 10)
    (2 #\- 4 #\+ 6 #\/ 8 #\* 10)
    (2 #\- 4 #\* 6 #\+ 8 #\/ 10)
    (2 #\- 4 #\* 6 #\/ 8 #\+ 10)
    (2 #\- 4 #\/ 6 #\+ 8 #\* 10)
    (2 #\- 4 #\/ 6 #\* 8 #\+ 10)
    (2 #\* 4 #\+ 6 #\- 8 #\/ 10)
    (2 #\* 4 #\+ 6 #\/ 8 #\- 10)
    (2 #\* 4 #\- 6 #\+ 8 #\/ 10)
    (2 #\* 4 #\- 6 #\/ 8 #\+ 10)
    (2 #\* 4 #\/ 6 #\+ 8 #\- 10)
    (2 #\* 4 #\/ 6 #\- 8 #\+ 10)
    (2 #\/ 4 #\+ 6 #\- 8 #\* 10)
    (2 #\/ 4 #\+ 6 #\* 8 #\- 10)
    (2 #\/ 4 #\- 6 #\+ 8 #\* 10)
    (2 #\/ 4 #\- 6 #\* 8 #\+ 10)
    (2 #\/ 4 #\* 6 #\+ 8 #\- 10)
    (2 #\/ 4 #\* 6 #\- 8 #\+ 10)
    (#\( 2 #\+ 4 #\) #\- 6 #\* 8 #\/ 10)
    (#\( 2 #\+ 4 #\) #\- 6 #\/ 8 #\* 10)
    (#\( 2 #\+ 4 #\) #\* 6 #\- 8 #\/ 10)
    (#\( 2 #\+ 4 #\) #\* 6 #\/ 8 #\- 10)
    (#\( 2 #\+ 4 #\) #\/ 6 #\- 8 #\* 10)
    (#\( 2 #\+ 4 #\) #\/ 6 #\* 8 #\- 10)
    (2 #\- #\( 4 #\+ 6 #\) #\* 8 #\/ 10)
    (2 #\- #\( 4 #\+ 6 #\) #\/ 8 #\* 10)
    (2 #\- 4 #\* #\( 6 #\+ 8 #\) #\/ 10)
    (2 #\- 4 #\* 6 #\/ #\( 8 #\+ 10 #\))
    (2 #\- 4 #\/ #\( 6 #\+ 8 #\) #\* 10)
    (2 #\- 4 #\/ 6 #\* #\( 8 #\+ 10 #\))
    (2 #\* #\( 4 #\+ 6 #\) #\- 8 #\/ 10)
    (2 #\* #\( 4 #\+ 6 #\) #\/ 8 #\- 10)
    (2 #\* 4 #\- #\( 6 #\+ 8 #\) #\/ 10)
    (2 #\* 4 #\- 6 #\/ #\( 8 #\+ 10 #\))
    (2 #\* 4 #\/ #\( 6 #\+ 8 #\) #\- 10)
    (2 #\* 4 #\/ 6 #\- #\( 8 #\+ 10 #\))
    (2 #\/ #\( 4 #\+ 6 #\) #\- 8 #\* 10)
    (2 #\/ #\( 4 #\+ 6 #\) #\* 8 #\- 10)
    (2 #\/ 4 #\- #\( 6 #\+ 8 #\) #\* 10)
    (2 #\/ 4 #\- 6 #\* #\( 8 #\+ 10 #\))
    (2 #\/ 4 #\* #\( 6 #\+ 8 #\) #\- 10)
    (2 #\/ 4 #\* 6 #\- #\( 8 #\+ 10 #\))
    (2 #\+ #\( 4 #\- 6 #\) #\* 8 #\/ 10)
    (2 #\+ #\( 4 #\- 6 #\) #\/ 8 #\* 10)
    (2 #\+ 4 #\* #\( 6 #\- 8 #\) #\/ 10)
    (2 #\+ 4 #\* 6 #\/ #\( 8 #\- 10 #\))
    (2 #\+ 4 #\/ #\( 6 #\- 8 #\) #\* 10)
    (2 #\+ 4 #\/ 6 #\* #\( 8 #\- 10 #\))
    (#\( 2 #\- 4 #\) #\+ 6 #\* 8 #\/ 10)
    (#\( 2 #\- 4 #\) #\+ 6 #\/ 8 #\* 10)
    (#\( 2 #\- 4 #\) #\* 6 #\+ 8 #\/ 10)
    (#\( 2 #\- 4 #\) #\* 6 #\/ 8 #\+ 10)
    (#\( 2 #\- 4 #\) #\/ 6 #\+ 8 #\* 10)
    (#\( 2 #\- 4 #\) #\/ 6 #\* 8 #\+ 10)
    (2 #\* 4 #\+ #\( 6 #\- 8 #\) #\/ 10)
    (2 #\* 4 #\+ 6 #\/ #\( 8 #\- 10 #\))
    (2 #\* #\( 4 #\- 6 #\) #\+ 8 #\/ 10)
    (2 #\* #\( 4 #\- 6 #\) #\/ 8 #\+ 10)
    (2 #\* 4 #\/ 6 #\+ #\( 8 #\- 10 #\))
    (2 #\* 4 #\/ #\( 6 #\- 8 #\) #\+ 10)
    (2 #\/ 4 #\+ #\( 6 #\- 8 #\) #\* 10)
    (2 #\/ 4 #\+ 6 #\* #\( 8 #\- 10 #\))
    (2 #\/ #\( 4 #\- 6 #\) #\+ 8 #\* 10)
    (2 #\/ #\( 4 #\- 6 #\) #\* 8 #\+ 10)
    (2 #\/ 4 #\* 6 #\+ #\( 8 #\- 10 #\))
    (2 #\/ 4 #\* #\( 6 #\- 8 #\) #\+ 10)
    (#\( 2 #\+ 4 #\- 6 #\) #\* 8 #\/ 10)
    (#\( 2 #\+ 4 #\- 6 #\) #\/ 8 #\* 10)
    (#\( 2 #\+ 4 #\) #\* #\( 6 #\- 8 #\) #\/ 10)
    (#\( 2 #\+ 4 #\) #\* 6 #\/ #\( 8 #\- 10 #\))
    (#\( 2 #\+ 4 #\) #\/ #\( 6 #\- 8 #\) #\* 10)
    (#\( 2 #\+ 4 #\) #\/ 6 #\* #\( 8 #\- 10 #\))
    (#\( 2 #\- 4 #\+ 6 #\) #\* 8 #\/ 10)
    (#\( 2 #\- 4 #\+ 6 #\) #\/ 8 #\* 10)
    (#\( 2 #\- 4 #\) #\* #\( 6 #\+ 8 #\) #\/ 10)
    (#\( 2 #\- 4 #\) #\* 6 #\/ #\( 8 #\+ 10 #\))
    (#\( 2 #\- 4 #\) #\/ #\( 6 #\+ 8 #\) #\* 10)
    (#\( 2 #\- 4 #\) #\/ 6 #\* #\( 8 #\+ 10 #\))
    (2 #\* #\( 4 #\+ 6 #\- 8 #\) #\/ 10)
    (2 #\* #\( 4 #\+ 6 #\) #\/ #\( 8 #\- 10 #\))
    (2 #\* #\( 4 #\- 6 #\+ 8 #\) #\/ 10)
    (2 #\* #\( 4 #\- 6 #\) #\/ #\( 8 #\+ 10 #\))
    (2 #\* 4 #\/ #\( 6 #\+ 8 #\- 10 #\))
    (2 #\* 4 #\/ #\( 6 #\- 8 #\+ 10 #\))
    (2 #\/ #\( 4 #\+ 6 #\- 8 #\) #\* 10)
    (2 #\/ #\( 4 #\+ 6 #\) #\* #\( 8 #\- 10 #\))
    (2 #\/ #\( 4 #\- 6 #\+ 8 #\) #\* 10)
    (2 #\/ #\( 4 #\- 6 #\) #\* #\( 8 #\+ 10 #\))
    (2 #\/ 4 #\* #\( 6 #\+ 8 #\- 10 #\))
    (2 #\/ 4 #\* #\( 6 #\- 8 #\+ 10 #\))
    (#\( 2 #\+ 4 #\- 6 #\* 8 #\/ 10 #\))
    (2 #\+ 4 #\- #\( 6 #\/ 8 #\* 10 #\))
    (2 #\+ #\( 4 #\* 6 #\) #\- #\( 8 #\/ 10 #\))
    (2 #\+ #\( 4 #\* 6 #\/ 8 #\) #\- 10)
    (#\( 2 #\* 4 #\) #\+ 6 #\- #\( 8 #\/ 10 #\))
    (#\( 2 #\* #\( 4 #\/ 6 #\) #\) #\+ 8 #\- 10)
    (2 #\* 4 #\/ #\( 6 #\- #\( 8 #\+ 10 #\) #\))
    (#\( 2 #\+ #\( 4 #\- 6 #\) #\* #\( 8 #\/ 10 #\) #\))))

; A list of postfix token lists corresponding to the list of infix expressions.
(define postfix
  '((42)
    (6 2 #\+ 5 #\* 8 4 #\/ #\-)
    (64 32 #\+ 15 #\* 888 444 #\/ #\-)
    (4 16 10 #\* 4 #\/ #\+ 2 #\-)
    (4 16 10 #\* 4 #\/ #\+ 2 #\-)
    (4 16 #\+ 10 #\* 4 2 #\- #\/)
    (16 4 #\+)
    (16 4 #\-)
    (16 4 #\*)
    (16 4 #\/)
    (16 4 #\+ 2 #\+)
    (16 4 #\- 2 #\-)
    (16 4 #\* 2 #\*)
    (16 4 #\/ 2 #\/)
    (16 4 #\+ 2 #\-)
    (16 4 #\- 2 #\+)
    (16 4 #\* 2 #\/)
    (16 4 #\/ 2 #\*)
    (16 8 #\+ 4 #\+ 2 #\+)
    (16 8 #\- 4 #\- 2 #\-)
    (16 8 #\* 4 #\* 2 #\*)
    (16 8 #\/ 4 #\/ 2 #\/)
    (16 8 #\- 4 #\+ 2 #\-)
    (16 8 #\+ 4 #\- 2 #\+)
    (16 8 #\- 4 #\- 2 #\+)
    (16 8 #\+ 4 #\- 2 #\-)
    (16 8 #\/ 4 #\* 2 #\/)
    (16 8 #\* 4 #\/ 2 #\*)
    (16 8 #\* 4 #\* 2 #\/)
    (16 8 #\* 4 #\/ 2 #\/)
    (2 4 #\+ 6 8 #\* 10 #\/ #\-)
    (2 4 #\+ 6 8 #\/ 10 #\* #\-)
    (2 4 6 #\* #\+ 8 10 #\/ #\-)
    (2 4 6 #\* 8 #\/ #\+ 10 #\-)
    (2 4 6 #\/ #\+ 8 10 #\* #\-)
    (2 4 6 #\/ 8 #\* #\+ 10 #\-)
    (2 4 #\- 6 8 #\* 10 #\/ #\+)
    (2 4 #\- 6 8 #\/ 10 #\* #\+)
    (2 4 6 #\* #\- 8 10 #\/ #\+)
    (2 4 6 #\* 8 #\/ #\- 10 #\+)
    (2 4 6 #\/ #\- 8 10 #\* #\+)
    (2 4 6 #\/ 8 #\* #\- 10 #\+)
    (2 4 #\* 6 #\+ 8 10 #\/ #\-)
    (2 4 #\* 6 8 #\/ #\+ 10 #\-)
    (2 4 #\* 6 #\- 8 10 #\/ #\+)
    (2 4 #\* 6 8 #\/ #\- 10 #\+)
    (2 4 #\* 6 #\/ 8 #\+ 10 #\-)
    (2 4 #\* 6 #\/ 8 #\- 10 #\+)
    (2 4 #\/ 6 #\+ 8 10 #\* #\-)
    (2 4 #\/ 6 8 #\* #\+ 10 #\-)
    (2 4 #\/ 6 #\- 8 10 #\* #\+)
    (2 4 #\/ 6 8 #\* #\- 10 #\+)
    (2 4 #\/ 6 #\* 8 #\+ 10 #\-)
    (2 4 #\/ 6 #\* 8 #\- 10 #\+)
    (2 4 #\+ 6 8 #\* 10 #\/ #\-)
    (2 4 #\+ 6 8 #\/ 10 #\* #\-)
    (2 4 #\+ 6 #\* 8 10 #\/ #\-)
    (2 4 #\+ 6 #\* 8 #\/ 10 #\-)
    (2 4 #\+ 6 #\/ 8 10 #\* #\-)
    (2 4 #\+ 6 #\/ 8 #\* 10 #\-)
    (2 4 6 #\+ 8 #\* 10 #\/ #\-)
    (2 4 6 #\+ 8 #\/ 10 #\* #\-)
    (2 4 6 8 #\+ #\* 10 #\/ #\-)
    (2 4 6 #\* 8 10 #\+ #\/ #\-)
    (2 4 6 8 #\+ #\/ 10 #\* #\-)
    (2 4 6 #\/ 8 10 #\+ #\* #\-)
    (2 4 6 #\+ #\* 8 10 #\/ #\-)
    (2 4 6 #\+ #\* 8 #\/ 10 #\-)
    (2 4 #\* 6 8 #\+ 10 #\/ #\-)
    (2 4 #\* 6 8 10 #\+ #\/ #\-)
    (2 4 #\* 6 8 #\+ #\/ 10 #\-)
    (2 4 #\* 6 #\/ 8 10 #\+ #\-)
    (2 4 6 #\+ #\/ 8 10 #\* #\-)
    (2 4 6 #\+ #\/ 8 #\* 10 #\-)
    (2 4 #\/ 6 8 #\+ 10 #\* #\-)
    (2 4 #\/ 6 8 10 #\+ #\* #\-)
    (2 4 #\/ 6 8 #\+ #\* 10 #\-)
    (2 4 #\/ 6 #\* 8 10 #\+ #\-)
    (2 4 6 #\- 8 #\* 10 #\/ #\+)
    (2 4 6 #\- 8 #\/ 10 #\* #\+)
    (2 4 6 8 #\- #\* 10 #\/ #\+)
    (2 4 6 #\* 8 10 #\- #\/ #\+)
    (2 4 6 8 #\- #\/ 10 #\* #\+)
    (2 4 6 #\/ 8 10 #\- #\* #\+)
    (2 4 #\- 6 8 #\* 10 #\/ #\+)
    (2 4 #\- 6 8 #\/ 10 #\* #\+)
    (2 4 #\- 6 #\* 8 10 #\/ #\+)
    (2 4 #\- 6 #\* 8 #\/ 10 #\+)
    (2 4 #\- 6 #\/ 8 10 #\* #\+)
    (2 4 #\- 6 #\/ 8 #\* 10 #\+)
    (2 4 #\* 6 8 #\- 10 #\/ #\+)
    (2 4 #\* 6 8 10 #\- #\/ #\+)
    (2 4 6 #\- #\* 8 10 #\/ #\+)
    (2 4 6 #\- #\* 8 #\/ 10 #\+)
    (2 4 #\* 6 #\/ 8 10 #\- #\+)
    (2 4 #\* 6 8 #\- #\/ 10 #\+)
    (2 4 #\/ 6 8 #\- 10 #\* #\+)
    (2 4 #\/ 6 8 10 #\- #\* #\+)
    (2 4 6 #\- #\/ 8 10 #\* #\+)
    (2 4 6 #\- #\/ 8 #\* 10 #\+)
    (2 4 #\/ 6 #\* 8 10 #\- #\+)
    (2 4 #\/ 6 8 #\- #\* 10 #\+)
    (2 4 #\+ 6 #\- 8 #\* 10 #\/)
    (2 4 #\+ 6 #\- 8 #\/ 10 #\*)
    (2 4 #\+ 6 8 #\- #\* 10 #\/)
    (2 4 #\+ 6 #\* 8 10 #\- #\/)
    (2 4 #\+ 6 8 #\- #\/ 10 #\*)
    (2 4 #\+ 6 #\/ 8 10 #\- #\*)
    (2 4 #\- 6 #\+ 8 #\* 10 #\/)
    (2 4 #\- 6 #\+ 8 #\/ 10 #\*)
    (2 4 #\- 6 8 #\+ #\* 10 #\/)
    (2 4 #\- 6 #\* 8 10 #\+ #\/)
    (2 4 #\- 6 8 #\+ #\/ 10 #\*)
    (2 4 #\- 6 #\/ 8 10 #\+ #\*)
    (2 4 6 #\+ 8 #\- #\* 10 #\/)
    (2 4 6 #\+ #\* 8 10 #\- #\/)
    (2 4 6 #\- 8 #\+ #\* 10 #\/)
    (2 4 6 #\- #\* 8 10 #\+ #\/)
    (2 4 #\* 6 8 #\+ 10 #\- #\/)
    (2 4 #\* 6 8 #\- 10 #\+ #\/)
    (2 4 6 #\+ 8 #\- #\/ 10 #\*)
    (2 4 6 #\+ #\/ 8 10 #\- #\*)
    (2 4 6 #\- 8 #\+ #\/ 10 #\*)
    (2 4 6 #\- #\/ 8 10 #\+ #\*)
    (2 4 #\/ 6 8 #\+ 10 #\- #\*)
    (2 4 #\/ 6 8 #\- 10 #\+ #\*)
    (2 4 #\+ 6 8 #\* 10 #\/ #\-)
    (2 4 #\+ 6 8 #\/ 10 #\* #\-)
    (2 4 6 #\* #\+ 8 10 #\/ #\-)
    (2 4 6 #\* 8 #\/ #\+ 10 #\-)
    (2 4 #\* 6 #\+ 8 10 #\/ #\-)
    (2 4 6 #\/ #\* 8 #\+ 10 #\-)
    (2 4 #\* 6 8 10 #\+ #\- #\/)
    (2 4 6 #\- 8 10 #\/ #\* #\+)))

; A list of results corresponding to the list of infix expressions.
(define results
  '(42
    38
    1438
    42
    42
    100
    20.0
    12.0
    64.0
    4.0
    22.0
    10.0
    128.0
    2.0
    18.0
    14.0
    32.0
    8.0
    30.0
    2.0
    1024.0
    0.25
    10.0
    22.0
    6.0
    18.0
    4.0
    64.0
    256.0
    16.0
    1.2
    -1.5
    25.2
    -5.0
    -77.3333
    -2.6666
    2.8
    5.5
    -21.2
    9.0
    81.3333
    6.6666
    13.2
    -1.25
    2.8
    17.25
    -0.6666
    3.3333
    -73.5
    38.5
    74.5
    -37.5
    1.0
    5.0
    1.2
    -1.5
    35.2
    -5.5
    -79.0
    -2.0
    -6.0
    -10.5
    -3.6
    0.6666
    -0.8571
    -10.0
    19.2
    -7.5
    6.6
    7.6666
    -9.4286
    -16.6666
    -79.8
    -8.4
    -139.5
    -107.5
    -3.0
    -15.0
    0.4
    -0.5
    1.2
    -10.0
    -18.0
    0.6666
    2.8
    5.5
    -11.2
    8.5
    79.6666
    7.3333
    7.8
    5.0
    -3.2
    9.5
    -0.6666
    6.0
    -19.5
    -11.5
    79.0
    2.0
    1.0
    9.0
    0.0
    0.0
    -1.2
    -18.0
    -30.0
    -2.0
    3.2
    5.0
    -2.8
    -0.6666
    -1.4286
    -6.0
    0.4
    -10.0
    1.2
    -0.2222
    2.0
    1.0
    10.0
    -0.4
    3.3333
    -18.0
    2.0
    4.0
    1.2
    -1.5
    25.2
    -5.0
    13.2
    -0.6666
    -0.6666
    0.4))
