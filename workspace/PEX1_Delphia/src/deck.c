/*
 * File:   deck.c
 * Author: Gavin Delphia
 *
 * Description: This file contains various deck creation and manipulation functions.
 */

#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <time.h>

#include "deck.h"
#include "files.h"

/*
 * Description: Creates a new deck with all cards in ascending order. This function
 *              must explicitly allocate memory for each card structure.
 * Input:       None.
 * Result:      Returns a pointer to the "top" card in a new deck.
 * PRE:         None.
 * POST:        The pointer returned will point to a circular, doubly-linked list
 *              of NUM_CARDS Card structures sorted in ascending order.
 */
card_ptr new_deck() {
	card_ptr top_card, last_card, temp;

	//Handle first card
	temp = malloc(sizeof(struct Card));
	temp->number = 1;
	temp->next = NULL;
	temp->prev = NULL;

	//Save top card
	top_card = temp;

	//Handle cards other than first and last
	int i;
	for (i = 2; i <= JOKER_A; i++) {
		last_card = temp;
		temp->next = malloc(sizeof(struct Card));
		temp = temp->next;

		temp->number = i;
		temp->prev = last_card;
		temp->next = NULL;
	}

	//Handle last card
	last_card = temp;
	temp->next = malloc(sizeof(struct Card));
	temp = temp->next;

	temp->number = JOKER_B;
	temp->prev = last_card; //issue here
	temp->next = top_card;

	//Attach top card to bottom
	top_card->prev = temp;
	top_card->prev->next = top_card;

	return top_card;
}

/*
 * Description: Shuffles a deck by removing cards one at a time from the original deck,
 *              inserting them in random locations into a new deck, and then returning
 *              a pointer to the top of the new deck.
 *              NOTE: The number field with the Card structures are NOT changed! The
 *              shuffle is accomplished by rearranging pointers to the structures.
 * Input:       A pointer to a "deck" of cards.
 * Result:      A pointer to a randomly shuffled "deck" of cards.
 * PRE:         The input pointer references a doubly-linked, circular list of Card structures.
 * POST:        The returned pointer references a doubly-linked, circular list of Card structures
 *              containing all Card structures from the original deck (i.e., nothing is lost).
 */
card_ptr shuffle_deck(card_ptr oldTop) {
	// Seed the random number generator using the system clock.
	// Leave this as the very first line in this function!!!
	srand((int) time(NULL ));
	int count = 0;

	//Create a newTop and put the oldTop card on it
	card_ptr newTop = oldTop;
	oldTop = oldTop->next;

	//Point the newTop to itself
	newTop->next = newTop;
	newTop->prev = newTop;

	while (count < JOKER_A) {
		int r = rand() % NUM_CARDS;
		int i;
		for (i = 0; i < r; i++) {
			newTop = newTop->next;
		}
		card_ptr first = newTop;
		card_ptr middle = oldTop;
		card_ptr last = newTop->next;

		oldTop = oldTop->next;

		newTop->next = middle;
		last->prev = middle;
		middle->prev = first;
		middle->next = last;

		count++;
		//show_deck2(newTop, count, r);
	}

	return newTop;
}

/*
 * Description: Shows a deck from "top" to "bottom".
 * Input:       A pointer to a "deck" of cards.
 * Result:      The number field of each card displayed on stdout.
 * PRE:         The input pointer references a doubly-linked, circular list of Card structures.
 * POST:        The doubly-linked, circular list of Card structures is unchanged.
 */
void show_deck(card_ptr topOfDeck) {
	// Make sure there's cards to print.
	if (topOfDeck != NULL ) {
		printf("%3d", topOfDeck->number); // Print the top card first.
		card_ptr card = topOfDeck->next; // Set a pointer to the second card.
		while (card != NULL && card != topOfDeck) // Loop until out of cards or back to the top.
		{
			printf("%3d", card->number);
			card = card->next;
		}
		printf("\n");
	}
}

/*
 * Description: Shows a deck from "bottom" to "top". (I.e., backward. Thus the name ... get it?)
 *              NOTE: It is not mandatory in the final product to display a deck of cards in
 *              reversed order, but it will prove very handy to test correctness of all pointers.
 * Input:       A pointer to a "deck" of cards.
 * Result:      The number field of each card displayed on stdout.
 * PRE:         The input pointer references a doubly-linked, circular list of Card structures.
 * POST:        The doubly-linked, circular list of Card structures is unchanged.
 */
void kced_wohs(card_ptr topOfDeck) {
	// Make sure there's cards to print.
	topOfDeck = topOfDeck->prev;
	if (topOfDeck != NULL ) {
		printf("%3d", topOfDeck->number); // Print the top card first.
		card_ptr card = topOfDeck->prev; // Set a pointer to the second card.
		while (card != NULL && card != topOfDeck) // Loop until out of cards or back to the top.
		{
			printf("%3d", card->number);
			card = card->prev;
		}
		printf("\n");
	}
}

/*
 * Description: Writes a deck to an output file from "top" to "bottom".
 * Input:       A pointer to a "deck" of cards.
 *              A character string with a file name.
 * Result:      The number field of each card is written to a file with the given name.
 * PRE:         The input pointer references a doubly-linked, circular list of Card structures.
 * POST:        The doubly-linked, circular list of Card structures is unchanged.
 *              If there was an error opening the file for writing, an error message will
 *              be displayed (by the open_output_file utility) and execution terminated
 *              with a result of EXIT_FAILURE.
 */
void write_deck_to_file(card_ptr topOfDeck, char* filename) {
	FILE* file = open_output_file(filename);
	int count;
	for (count = 0; count < NUM_CARDS; count++) {
		fprintf(file, "%3d", topOfDeck->number);
		topOfDeck = topOfDeck->next;
	}
	fclose(file);
}

/*
 * Description: Creates a new deck with card values from the given input file. This function
 *              must explicitly allocate memory for each card structure.
 * Input:       A character string with a file name.
 * Result:      Returns a pointer to the "top" card in a new deck.
 * PRE:         The filename must be a valid file containing integers representing a valid deck.
 * POST:        The pointer returned will point to a circular, doubly-linked list
 *              of NUM_CARDS Card structures with card values in the order in which they
 *              appear in the input file.
 *              If there was an error opening the file for reading, an error message will
 *              be displayed (by the open_output_file utility) and execution terminated
 *              with a result of EXIT_FAILURE.
 */
card_ptr read_deck_from_file(char* filename) {
	card_ptr top_card, last_card, temp;

	int num;
	int count = 0;
	FILE* file = open_input_file(filename);
	while (fscanf(file, "%3d", &num) != EOF) {
		if (count == 0) { //Handle first card
			temp = malloc(sizeof(struct Card));
			temp->number = num;
			temp->next = NULL;
			temp->prev = NULL;

			//Save top card
			top_card = temp;
		} else if (count <= JOKER_A) { //Handle cards other than first and last
			last_card = temp;
			temp->next = malloc(sizeof(struct Card));
			temp = temp->next;

			temp->number = num;
			temp->prev = last_card;
			temp->next = NULL;
		} else { //Handle last card
			last_card = temp;
			temp->next = malloc(sizeof(struct Card));
			temp = temp->next;

			temp->number = num;
			temp->prev = last_card; //issue here
			temp->next = top_card;

		}
		count++;
	}

	//Attach top card to bottom
	top_card->prev = temp;
	top_card->prev->next = top_card;

	fclose(file);
	return top_card;
}
