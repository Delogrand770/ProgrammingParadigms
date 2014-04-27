/*
 * File:   Flintstones.c
 * Author: Randall.Bower
 */

#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <math.h>
#include <time.h>

#include "people.h"

void flintstones_demo() {
	printf("\n\Flintstones Demo\n================\n");

	struct Person fred;  // These are actual structures,
	struct Person wilma; // not pointers to structures.

	// The dot notation should look familiar.
	fred.height = 72;
	fred.weight = 219.5;
	fred.gender = 'M';

	wilma.height = 66;
	wilma.weight = 109.5;
	wilma.gender = 'F';

	fred.spouse = &wilma; // Notice the & on these two lines; the
	wilma.spouse = &fred; // spouse field of PERSON is a pointer.

	printf("Fred and Wilma:\n");
	print_person(&fred);  // Notice we must pass a pointer to fred,
	print_person(&wilma); // and a pointer to wilma.
	printf("\n");

	printf("Fred's spouse and Wilma's spouse:\n");
	print_person(fred.spouse);  // But fred.spouse is already a pointer,
	print_person(wilma.spouse); // as is wilma.spouse.
	printf("\n");

	// How would wilma change fred's weight? Must de-reference the
	// spouse pointer before accessing the weight field.
	(*wilma.spouse).weight = 185.0;

	// C provides a much better notation for this.
	wilma.spouse->weight = 185.0; // Does the same thing as the line above.

	printf("Fred and Wilma, after Fred's diet:\n");
	print_person(&fred);
	print_person(&wilma);
	printf("\n");

	// How about some kids? Declaring individual variables such as fred and wilma
	// for each PERSON is not feasible when we don't know how many we may need.
	// Thus, using pointers to "walk" along a list is necessary.
	person_ptr kids, temp;

	// Seed the random number generator using the system clock.
	// Be sure this only happens once (i.e., is NOT in a loop!)
	srand((int) time(NULL ));

	// Make the first kid.
	temp = malloc(sizeof(struct Person));
	temp->height = rand() % 24 + 48;   // Random value in range [48,72).
	temp->weight = rand() % 100 + 60; // Random value in range [60,160).
	temp->gender = (rand() < RAND_MAX / 2) ? 'M' : 'F'; // Random gender.
	/*
	 * The above notation is shorthand for:
	 * if( rand() < RAND_MAX/2 )
	 *   temp->gender = 'M';
	 * else
	 *   temp->gender = 'F';
	 */
	temp->spouse = NULL; // Kids aren't generally married.
	temp->sibling = NULL; // No younger siblings yet.

	// Hold on to the first child before starting the loop.
	kids = temp;

	// Loop through a few more random kids.
	int i;
	for (i = 0; i < 5; i++) {
		// Allocate the memory for the sibling.
		temp->sibling = malloc(sizeof(struct Person));

		// Move temp!
		temp = temp->sibling;

		// Randomly fill in the rest of the new person.
		temp->height = rand() % 24 + 48;   // Random value in range [48,72).
		temp->weight = rand() % 100 + 100; // Random value in range [100,200).
		temp->gender = (rand() < RAND_MAX / 2) ? 'M' : 'F'; // Random gender.
		temp->spouse = NULL; // Kids aren't generally married.
		temp->sibling = NULL; // No younger siblings yet.
	}

	// Now let's see the kids.
	printf("Kids:\n");
	temp = kids;
	while (temp != NULL ) {
		print_person(temp);
		temp = temp->sibling;
	}
}
