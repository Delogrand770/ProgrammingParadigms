/*
 * File:   People.h
 * Author: Randall.Bower
 */

#ifndef PEOPLE_H
#define	PEOPLE_H

struct Person {
  int height;
  double weight;
  char gender;
  struct Person* spouse;
  struct Person* sibling;
}; // Yes, this semicolon looks out of place here. Deal with it.

typedef struct Person* person_ptr;  // Convenient shorthand.

void print_person( person_ptr p );

#endif	/* PEOPLE_H */
