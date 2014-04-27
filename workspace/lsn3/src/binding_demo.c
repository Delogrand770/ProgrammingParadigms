/*
 *   File: binding_demo.c
 * Author: Randall.Bower
 *
 * Description: Demonstrates static binding in C (and discusses dynamic binding).
 */

#include <stdio.h>
#include <stdlib.h>

/*
 * The variable answer is a static variable (not to be confused with Java's
 * concept of static) declared outside any function has file scope meaning
 * it is visible and usable by any code in this file.
 *
 * Such variables are often called global variables.
 *
 * This is a demonstration of the concept only; using such variable is NOT good
 * programming practice and is not allowed or necessary for your PEX!
 *
 * Do Not Do This! (This means you, Keane.)
 */
int answer;

void blah();
void blahblahblah( int );
void yadda();
void constants();

void binding_demo()
{
  printf( "\n\nBinding Demo\n============\n" );

  answer = 42; // Assigns a value to the global variable.
  yadda();
  blah();

  // These calls will likely show the stack-dynamic variable in the same location ... why?
//  blah();
//  blah();

  // This will show the stack-dynamic variable for each call in a different location.
//  blahblahblah( 5 );

  // This shows when constants are bound in C.
//  constants();
}

void blah()
{
  int answer = 37; // A local, stack-dynamic, variable with the same name as the global variable.

  printf( "In blah,  answer is at %p and contains %d\n", &answer, answer );

  //yadda();
}

/*
 * This shows the local variable in blah is a stack-dynamic variable as each
 * call creates a new copy of the variable answer in a different location.
 */
void blahblahblah( int n )
{
  if( n > 0 )
  {
    blah();
    blahblahblah( n - 1 );
  }
}

/*
 * With static binding, this will always print 42.
 *
 * With dynamic binding, the second time it is called from within blah,
 * the local variable declared in blah would be used by this function.
 */
void yadda()
{
  printf( "In yadda, answer is at %p and contains %d\n", &answer, answer );
}

/*
 * When does constant binding happen in C?
 */
void constants()
{
  // Declare and initialize a variable.
  int myVar = 1967;

  // Now scan a value from the keyboard into the variable.
  printf( "\nEnter myVar: " );  fflush( stdout );
  scanf( "%d", &myVar );
  printf( "myVar = %d\n", myVar );

  // Is the value of MAX bound at compile time or run time?
  // What value will give us the answer to this question?
  const int MAX = myVar;

  printf( "myVar = %d\n", myVar );
  printf( "SIZE = %d\n", MAX );

  // Is the binding of SIZE done or will it change when myVar changes?
  myVar++;

  printf( "myVar = %d\n", myVar );
  printf( "SIZE = %d\n", MAX );
}
