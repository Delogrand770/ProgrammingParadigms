/*
 *   File: coercion_demo.c
 * Author: Randall.Bower
 *
 * Description:
 */

#include <stdio.h>
#include <stdlib.h>

void coercion_demo()
{
  printf( "\n\nCoercion Demo\n=============\n" );

  int i = 3;

  // Experiment 1
  int f = 6.75;         // Does this compile? Strangely, yes.
  printf( "%d\n", f );  // Truncates.

  // Experiment 2
//  float f = 6.75;
//  int mixed = i + f;
//  printf( "mixed = %d\n", mixed );  // Guesses?

  // Experiment 3
//  float f = 6.75;
//  float mixed = i + f;
//  printf( "mixed = %f\n", mixed );

  // NOTE: All of this happens without a whisper from the compiler ... so you gotta know what's happening!
}
