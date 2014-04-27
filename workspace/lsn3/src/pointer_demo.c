/*
 *   File: pointer_demo.c
 * Author: Randall.Bower
 *
 * Description: A bit of pointer fun.
 */

#include <stdio.h>
#include <stdlib.h>

// If you put this and the string_demo.c in the same project,
// only one can define main at a time.
void pointer_demo()
{
  printf( "\n\nPointer Demo\n============\n" );

  int answer;   // A simple integer variable.
  answer = 42;
  printf( "answer = %d\n\n", answer );

  int* brutus;  // A pointer to an integer. (My favorite dog Brutus was a pointer.)
  brutus = &answer;  // Assigns the address of answer to brutus.

  // This shows the address of the variable answer is now stored in brutus.
  printf( "answer is at = %p\n", &answer );
  printf( "brutus       = %p\n\n", brutus );

  // How to de-reference a pointer to see what it actually points to.
  printf( "brutus points to the value %d\n", *brutus );
}
