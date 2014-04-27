/*
 * File:   People.c
 * Author: Randall.Bower
 */

#include <stdio.h>
#include <stdlib.h>

#include "people.h"

void print_person( person_ptr p )
{
  printf( "%c: %d %4.1f\n", p->gender, p->height, p->weight );
}
