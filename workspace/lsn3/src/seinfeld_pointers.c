/*
 *   File: seinfeld_pointers.c
 * Author: Randall.Bower
 *
 * Description: Another pointer demo.
 */

#include <stdio.h>
#include <stdlib.h>

void seinfeld_demo()
{
  printf( "\n\nSeinfeld Pointer Demo\n=====================\n" );

  int *jerry;
  int *george;

  int elaine = 37;
  int kramer = 42;

  jerry = &elaine;
  george = &kramer;

  printf( "elaine is:        %d    kramer is:        %d\n", elaine, kramer );
  printf( "jerry points at:  %d    george points at: %d\n\n", *jerry, *george );

  // Do each of these experiments individually.
  // *jerry = *george;
  // *george = *jerry;
  // jerry = george;

  // Do the following two lines together.
  // george = jerry;
  // *george++;       // Is this (*george)++ or *(george++)?

  // (*george)++;
  // *(george++);

  printf( "elaine is:        %d    kramer is:        %d\n", elaine, kramer );
  printf( "jerry points at:  %d    george points at: %d\n\n", *jerry, *george );
}
