/*
 * main.c
 *
 *  Created on: Aug 15, 2012
 *      Author: C14Gavin.Delphia
 */


#include <stdio.h>
#include <stdlib.h>

void iterate(int);

int main( int argc, char** argv ){
  printf( "Hello\n" );

  iterate(7);
  iterate(3);
  return EXIT_SUCCESS;
}

void iterate( int howmany ){
	int i;
	for (i = 0; i < howmany; i++){
		printf("i = %d\n",i);
	}
}
