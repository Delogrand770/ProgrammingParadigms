/*
 * File:   pontifex.c
 * Author: Gavin Delphia
 *
 * Description: Definitions of methods used to implement the Pontifex encryption scheme.
 *              http://www.schneier.com/solitaire.html
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "deck.h"
#include "files.h"
#include "pontifex.h"
/*
 * Description: Calls move_jokersA and B in the correct order.
 * Input:       card_ptr to the "top" card in a deck.
 * Result:      Returns a pointer to the "top" card in the deck.
 * PRE:			The input pointer references a doubly-linked, circular list of Card structures.
 * POST:		The returned pointer references a doubly-linked, circular list of Card structures
 *              containing all Card structures from the original deck (i.e., nothing is lost).
 */
card_ptr move_jokers(card_ptr topOfDeck) {
	return move_jokerB(move_jokerA(topOfDeck));
}

/*
 * Description: Moves jokerA one card forward.
 * Input:       card_ptr to the "top" card in a deck.
 * Result:      Returns a pointer to the "top" card in the deck.
 * PRE:			The input pointer references a doubly-linked, circular list of Card structures.
 * POST:		The returned pointer references a doubly-linked, circular list of Card structures
 *              containing all Card structures from the original deck (i.e., nothing is lost).
 */
card_ptr move_jokerA(card_ptr topOfDeck) {
	int count = 0;
	int found = 0;
	card_ptr oldTop = topOfDeck;
	card_ptr last = topOfDeck->prev;
	card_ptr rcard = oldTop;
	while (count < NUM_CARDS && !found) {
		if (topOfDeck->number == JOKER_A) {
			card_ptr first = topOfDeck->prev;
			card_ptr second = topOfDeck;
			card_ptr third = topOfDeck->next;
			card_ptr fourth = topOfDeck->next->next;

			if (second == last) {
				rcard = second;
			} else if (second == oldTop) {
				rcard = oldTop->next;
			}

			first->next = third;
			third->prev = first;
			third->next = second;
			second->prev = third;
			second->next = fourth;
			fourth->prev = second;

			found = 1;
		} else {
			count++;
			topOfDeck = topOfDeck->next;
		}
	}
	return rcard;
}

/*
 * Description: Moves jokerB two cards forward.
 * Input:       card_ptr to the "top" card in a deck.
 * Result:      Returns a pointer to the "top" card in the deck.
 * PRE:			The input pointer references a doubly-linked, circular list of Card structures.
 * POST:		The returned pointer references a doubly-linked, circular list of Card structures
 *              containing all Card structures from the original deck (i.e., nothing is lost).
 */
card_ptr move_jokerB(card_ptr topOfDeck) {
	int count = 0;
	int found = 0;
	card_ptr oldTop = topOfDeck;
	card_ptr rcard = oldTop;
	card_ptr last = topOfDeck->prev;
	card_ptr STL = last->prev;
	while (count < NUM_CARDS && !found) {
		if (topOfDeck->number == JOKER_B) {
			card_ptr first = topOfDeck->prev;
			card_ptr second = topOfDeck;
			card_ptr third = topOfDeck->next;
			card_ptr fourth = topOfDeck->next->next;
			card_ptr fifth = topOfDeck->next->next->next;

			if (second == last) {
				rcard = third;
			} else if (second == STL) {
				rcard = fourth;
			} else if (second == oldTop) {
				rcard = oldTop->next;
			}

			first->next = third;
			third->prev = first;
			fourth->next = second;
			second->prev = fourth;
			second->next = fifth;
			fifth->prev = second;

			found = 1;
		} else {
			count++;
			topOfDeck = topOfDeck->next;
		}
	}
	return rcard;
}

/*
 * Description: Swaps the cards on either side of the jokers with each other.
 * Input:       card_ptr to the "top" card in a deck.
 * Result:      Returns a pointer to the "top" card in the deck.
 * PRE:			The input pointer references a doubly-linked, circular list of Card structures.
 * POST:		The returned pointer references a doubly-linked, circular list of Card structures
 *              containing all Card structures from the original deck (i.e., nothing is lost).
 */
card_ptr triple_cut(card_ptr topOfDeck) {
	card_ptr rcard;
	card_ptr second, third, midA, midB;

	card_ptr first = topOfDeck;
	card_ptr last = topOfDeck->prev;

	int isFirstJoker = isJoker(first);
	int isLastJoker = isJoker(last);

	//Find needed cards for pointer assignments
	int keepGoing = 1;
	int count = 1;
	int pass = 0;
	topOfDeck = topOfDeck->next;
	while (count < NUM_CARDS - 1 && keepGoing) {
		if (isFirstJoker && !isLastJoker) { //first
			if (isJoker(topOfDeck)) {
				rcard = topOfDeck->next;
				keepGoing = 0;
			}
		} else if (!isFirstJoker && isLastJoker) { //last
			if (isJoker(topOfDeck)) {
				rcard = topOfDeck;
				keepGoing = 0;
			}
		} else if (isFirstJoker && isLastJoker) { //both
			rcard = first;
			keepGoing = 0;

		} else { //neither
			if (isJoker(topOfDeck)) {
				if (!pass) {
					pass = 1;
					midA = topOfDeck;
					second = topOfDeck->prev;
				} else {
					midB = topOfDeck;
					third = topOfDeck->next;

					if (first != second && last != third) {
						third->prev = second;
						second->next = third;
						last->next = midA;
						midA->prev = last;
						midB->next = first;
						first->prev = midB;
						rcard = third;
					} else if (first == second && last != third) {
						first->next = third;
						third->prev = first;
						midB->next = first;
						first->prev = midB;
						last->next = midA;
						midA->prev = last;
						rcard = third;
					} else {
						third->prev = second;
						second->next = third;
						third->next = midA;
						midA->prev = third;
						midB->next = first;
						first->prev = midB;
						rcard = third;
					}

					keepGoing = 0;
				}
			}
		}
		topOfDeck = topOfDeck->next;
		count++;
	}
	return rcard;
}

/*
 * Description: Determines if a given card is a joker or not
 * Input:       card_ptr to the a card in a deck
 * Result:      Returns the int 1 for true and 0 for false
 * PRE:			The input pointer references a doubly-linked, circular list of Card structures.
 * POST:		The returned int is either a zero or one
 */
int isJoker(card_ptr card) {
	return (card->number == JOKER_A || card->number == JOKER_B);
}

/*
 * Description: Looks at the bottom card and counts down that many from the top and cuts the deck after.
 * 				This upper portion of the deck is placed right before the last card.
 * Input:       card_ptr to the "top" card in a deck
 * Result:      Returns a pointer to the "top" card in the deck.
 * PRE:
 * POST:		The returned pointer references a doubly-linked, circular list of Card structures
 *              containing all Card structures from the original deck (i.e., nothing is lost).
 */
card_ptr count_cut(card_ptr topOfDeck) {
	card_ptr last = topOfDeck->prev;
	card_ptr first = topOfDeck;
	card_ptr STL = last->prev; //Second to Last
	card_ptr target = first;
	card_ptr RAT; //Right After Target

	if (isJoker(last)) { //Bottom card is a joker so do nothing.
		return topOfDeck;
	} else {
		int countTo = last->number - 1;
		while (countTo != 0) {
			countTo--;
			target = target->next;
		}
		RAT = target->next;

		if (target == STL) { // Cutting wont do anything since the card is already second to last.
			return first;
		} else {
			if (RAT == STL) {
				STL->next = first;
				first->prev = STL;
				target->next = last;
				last->prev = target;
				last->next = STL;
				STL->prev = last;
				return STL;
			} else {
				RAT->prev = last;
				last->next = RAT;
				STL->next = first;
				first->prev = STL;
				target->next = last;
				last->prev = target;
				return RAT;
			}
		}
	}
}

/*
 * Description: Looks at the top card of the deck and counts down that many cards.
 * 				If the top card is a joker it uses the bottom card.
 * Input:       card_ptr to the "top" card in a deck.
 * Result:      Returns a pointer to the card counted down to in the deck.
 * PRE:			The input pointer references a doubly-linked, circular list of Card structures.
 * POST:		The returned pointer references a doubly-linked, circular list of Card structures
 *              containing all Card structures from the original deck (i.e., nothing is lost).
 */
card_ptr get_outputCard(card_ptr topOfDeck) {
	int countTo = topOfDeck->number;
	card_ptr target = topOfDeck;
	if (isJoker(target)) {
		return topOfDeck->prev;
	}
	while (countTo != 0) {
		countTo--;
		target = target->next;
	}
	return target;
}

/*
 * Description: Mods a int by the alphabet size
 * Input:       card_ptr to a card in a deck
 * Result:      Returns a int modded by the alphabet.
 * PRE:			The input pointer references a doubly-linked, circular list of Card structures.
 * POST:
 */
int card_mod(card_ptr card) {
	return card->number % ALPHABET_SIZE;
}

/*
 * Description: Generates a keystream based on a given deck and how many keys required.
 * Input:       card_ptr to the "top" card in a deck and a int to determine how many keys to generate.
 * Result:      None
 * PRE:			The input pointer references a doubly-linked, circular list of Card structures.
 * 				It also requires a valid integer.
 * POST:
 */
void keyStream(card_ptr deck, int howMany) {
	int i;
	card_ptr target;
	printf("KEY STREAM: ");
	for (i = 0; i < howMany; i++) {
		deck = move_jokers(deck);
		deck = triple_cut(deck);
		deck = count_cut(deck);
		target = get_outputCard(deck);
		if (!isJoker(target)) {
			printf("%3d", card_mod(target));
		} else {
			i--;
		}
	}
	printf("\n");
}

/*
 * Description: Converts a character to the appropriate integer value.
 * Input:       character to be converted.
 * Result:      Returns a integer value for that character.
 * PRE:			Requires a valid character that is UpperCase.
 * POST:		The returned int is in the range 0 to (ALPHABET_SIZE - 1)
 */
int charToInt(char ch) {
	int i = 0;
	char* alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	while (i < ALPHABET_SIZE) {
		if (alphabet[i] == ch) {
			return i;
		}
		i++;
	}
	return -1;
}

/*
 * Description: Encrypts a message based on a deck and outputs the result to a file.
 * Input:       card_ptr to the "top" card in a deck.
 * 				a valid plaintext filename.
 * 				a valid cipher text filename.
 * Result:      None
 * PRE:			The input pointer references a doubly-linked, circular list of Card structures.
 * 				A valid file names are required as well
 * POST:		None
 */
void encrypt(card_ptr deck, char* plaintextFile, char* ciphertextFile) {
	char ch;
	char* alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	card_ptr target;
	FILE* in_file = open_input_file(plaintextFile);
	FILE* out_file = open_output_file(ciphertextFile);

	int sum = 0;
	while (fscanf(in_file, "%c", &ch) != EOF) {
		sum = charToInt(ch);
		target = NULL;
		while (target == NULL ) {
			deck = move_jokers(deck);
			deck = triple_cut(deck);
			deck = count_cut(deck);
			target = get_outputCard(deck);
			if (isJoker(target)) {
				target = NULL;
			}
		}
		sum += card_mod(target);
		sum = sum % ALPHABET_SIZE;
		fprintf(out_file, "%c", alphabet[sum]);
	}
	fclose(in_file);
	fclose(out_file);
}

/*
 * Description: Decrypts a message based on a deck and outputs the result to a file.
 * Input:       card_ptr to the "top" card in a deck.
 * 				a valid plaintext filename.
 * 				a valid cipher text filename.
 * Result:      None
 * PRE:			The input pointer references a doubly-linked, circular list of Card structures.
 * 				Valid file names are required as well.
 * POST:		None
 */
void decrypt(card_ptr deck, char* ciphertextFile, char* plaintextFile) {
	char ch;
	char* alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	card_ptr target;
	FILE* in_file = open_input_file(ciphertextFile);
	FILE* out_file = open_output_file(plaintextFile);

	int sum = 0;
	while (fscanf(in_file, "%c", &ch) != EOF) {
		sum = charToInt(ch);
		target = NULL;
		while (target == NULL ) {
			deck = move_jokers(deck);
			deck = triple_cut(deck);
			deck = count_cut(deck);
			target = get_outputCard(deck);
			if (isJoker(target)) {
				target = NULL;
			}
		}
		sum -= card_mod(target);
		while (sum < 0) {
			sum += ALPHABET_SIZE;
		}
		sum = sum % ALPHABET_SIZE;
		fprintf(out_file, "%c", alphabet[sum]);
	}
	fclose(in_file);
	fclose(out_file);
}
