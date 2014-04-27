/*
 *   File: main.c
 * Author: Randall.Bower
 *
 * Description: Demonstrating a stack.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>  // Need the strlen function.
#include <ctype.h>   // Need the isdigit function.
#include "stack.h"

int evaluate( char* ); // Prototype for function defined below.

int main( int argc, char *argv[ ] )
{
  stack_ptr stack = new_stack();

  printf( "\nStack Test\n\n" );
  printf( "isEmpty: %d\n\n", is_empty( stack ) ); // A new stack is empty.

  push( stack, 37 );
  printf( "isEmpty: %d\n", is_empty( stack ) );
  printf( "peek: %d\n\n", peek( stack ) );

  push( stack, 42 );
  printf( "isEmpty: %d\n", is_empty( stack ) );
  printf( "peek: %d\n\n", peek( stack ) );

  printf( "%d popped\n", pop( stack ) );
  printf( "isEmpty: %d\n\n", is_empty( stack ) );

  printf( "%d popped\n", pop( stack ) );
  printf( "isEmpty: %d\n\n", is_empty( stack ) );

  // We didn't get to this example in class today, but here's the
  // algorithm to evaluate a postfix expression.

  //  char   expression17[] = "89+";
  //  char*  expression38  = "62+5*84/-";
  //
  //  printf( "%s = %d\n", expression17, evaluate( expression17 ) );
  //  printf( "%s = %d\n", expression38, evaluate( expression38 ) );

  return EXIT_SUCCESS;
}

/*
 * Description: Evaluates an expression in postfix notation using a stack.
 * Input:       A string containing a postfix expression.
 * Result:      The integer result of evaluating the expression.
 * PRE:         The string parameter must contain a properly formatted postfix
 *              expression with no whitespace and only single-digit numbers.
 * POST:        The value returned will be the result of evaluating the expression.
 *              If the postfix notation contains an error, whitespace, or double-
 *              digit numbers, the result is not guaranteed.
 */
int evaluate( char* postfix )
{
  stack_ptr stack = new_stack();

  int i, x, y;
  for( i = 0; i < strlen( postfix ); i++ )
  {
    if( isdigit( (int)postfix[ i ] ) )
    {
      push( stack, postfix[ i ] - '0' );
    }
    else
    {
      x = pop( stack );
      y = pop( stack );
      switch( postfix[ i ] )
      {
        case '+':
          push( stack, y + x );
          break;
        case '-':
          push( stack, y - x );
          break;
        case '*':
          push( stack, y * x );
          break;
        case '/':
          push( stack, y / x );
          break;
      }
    }
  }

  return pop( stack );
}
